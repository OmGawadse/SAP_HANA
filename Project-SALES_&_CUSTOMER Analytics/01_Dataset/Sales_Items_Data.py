
import csv
import random
from pathlib import Path
from decimal import Decimal
from collections import Counter

# ==========================================
# SAP HANA SALES & CUSTOMER ANALYTICS
# REALISTIC SALES ITEMS DATA GENERATION
# ==========================================

random.seed(42)

BASE_DIR = Path(__file__).resolve().parent

SALES_FILE = BASE_DIR / "sales_data.csv"
PRODUCT_FILE = BASE_DIR / "product_data.csv"
OUTPUT_FILE = BASE_DIR / "sales_items_data.csv"

EXPECTED_SALES = 5000
EXPECTED_PRODUCTS = 100
MAX_RECORDS = 10000

# ------------------------------------------
# 1. READ SOURCE CSV FILES
# ------------------------------------------

def read_csv(file_path):

    if not file_path.exists():
        raise FileNotFoundError(
            f"Required file not found: {file_path}"
        )

    with open(
        file_path,
        "r",
        encoding="utf-8-sig",
        newline=""
    ) as file:
        return list(csv.DictReader(file))


sales = read_csv(SALES_FILE)
products = read_csv(PRODUCT_FILE)

if len(sales) != EXPECTED_SALES:
    raise ValueError(
        f"Expected {EXPECTED_SALES} sales, "
        f"found {len(sales)}."
    )

if len(products) != EXPECTED_PRODUCTS:
    raise ValueError(
        f"Expected {EXPECTED_PRODUCTS} products, "
        f"found {len(products)}."
    )

# ------------------------------------------
# 2. VALIDATE SOURCE DATA
# ------------------------------------------

sales_ids = [int(s["SALES_ID"]) for s in sales]
product_ids = [int(p["PRODUCT_ID"]) for p in products]

if len(set(sales_ids)) != EXPECTED_SALES:
    raise ValueError("Duplicate SALES_ID detected.")

if len(set(product_ids)) != EXPECTED_PRODUCTS:
    raise ValueError("Duplicate PRODUCT_ID detected.")

for product in products:

    if Decimal(product["UNIT_PRICE"]) <= 0:
        raise ValueError("Invalid product price.")

    if int(product["CATEGORY_ID"]) not in range(1, 6):
        raise ValueError("Invalid product category.")

# ------------------------------------------
# 3. CATEGORY PURCHASE PROBABILITIES
# ------------------------------------------

# Synthetic retail demand distribution.
# Everyday items are more likely to be purchased.

category_weights = {
    1: 15,  # Electronics
    2: 20,  # Clothing
    3: 15,  # Sports and Fitness
    4: 30,  # Groceries
    5: 20   # Self Care
}

products_by_category = {
    category_id: []
    for category_id in category_weights
}

for product in products:

    category_id = int(product["CATEGORY_ID"])

    products_by_category[category_id].append(product)

# ------------------------------------------
# 4. GENERATE REALISTIC QUANTITIES
# ------------------------------------------

def generate_quantity(category_id, unit_price):

    if category_id == 1:

        # Expensive electronics: mostly one unit
        if unit_price >= Decimal("10000"):
            return random.choices(
                [1, 2],
                weights=[95, 5],
                k=1
            )[0]

        return random.choices(
            [1, 2, 3],
            weights=[75, 20, 5],
            k=1
        )[0]

    if category_id == 2:
        return random.choices(
            [1, 2, 3, 4],
            weights=[55, 30, 12, 3],
            k=1
        )[0]

    if category_id == 3:
        return random.choices(
            [1, 2, 3],
            weights=[75, 20, 5],
            k=1
        )[0]

    if category_id == 4:
        return random.choices(
            [1, 2, 3, 4, 5],
            weights=[40, 30, 18, 9, 3],
            k=1
        )[0]

    return random.choices(
        [1, 2, 3, 4],
        weights=[50, 30, 15, 5],
        k=1
    )[0]

# ------------------------------------------
# 5. GENERATE CATEGORY DISCOUNTS
# ------------------------------------------

def generate_discount(category_id, order_status):

    # Cancelled orders do not receive a discount.
    # Revenue reporting will later exclude them.

    if order_status == "Cancelled":
        return Decimal("0.00")

    discount_options = {
        1: ([0, 5, 10, 15], [55, 25, 15, 5]),
        2: ([0, 5, 10, 15, 20], [20, 25, 30, 20, 5]),
        3: ([0, 5, 10, 15], [35, 30, 25, 10]),
        4: ([0, 5, 10], [65, 25, 10]),
        5: ([0, 5, 10, 15, 20], [35, 30, 20, 10, 5])
    }

    values, weights = discount_options[category_id]

    discount = random.choices(
        values,
        weights=weights,
        k=1
    )[0]

    return Decimal(str(discount)).quantize(
        Decimal("0.01")
    )

# ------------------------------------------
# 6. GENERATE SALES ITEMS
# ------------------------------------------

records = []
sales_item_id = 1

for sale in sales:

    sales_id = int(sale["SALES_ID"])
    order_status = sale["ORDER_STATUS"]

    # 30% single-item orders
    # 70% two-item orders
    item_count = random.choices(
        [1, 2],
        weights=[30, 70],
        k=1
    )[0]

    selected_product_ids = set()

    for _ in range(item_count):

        # Choose a category based on demand.
        category_id = random.choices(
            list(category_weights.keys()),
            weights=list(category_weights.values()),
            k=1
        )[0]

        # Avoid duplicate products in the same sale.
        available_products = [
            p for p in products_by_category[category_id]
            if int(p["PRODUCT_ID"])
            not in selected_product_ids
        ]

        if not available_products:
            available_products = [
                p for p in products
                if int(p["PRODUCT_ID"])
                not in selected_product_ids
            ]

        product = random.choice(available_products)

        product_id = int(product["PRODUCT_ID"])
        selected_product_ids.add(product_id)

        actual_category = int(product["CATEGORY_ID"])
        unit_price = Decimal(product["UNIT_PRICE"])

        quantity = generate_quantity(
            actual_category,
            unit_price
        )

        discount = generate_discount(
            actual_category,
            order_status
        )

        records.append({
            "SALES_ITEM_ID": sales_item_id,
            "SALES_ID": sales_id,
            "PRODUCT_ID": product_id,
            "QUANTITY": quantity,
            "UNIT_PRICE": f"{unit_price:.2f}",
            "DISCOUNT_PERCENT": f"{discount:.2f}"
        })

        sales_item_id += 1

# ------------------------------------------
# 7. VALIDATE GENERATED DATA
# ------------------------------------------

if len(records) > MAX_RECORDS:
    raise ValueError(
        f"Record limit exceeded: {len(records)}"
    )

if len(records) < EXPECTED_SALES:
    raise ValueError("Some sales have no items.")

if len({
    r["SALES_ITEM_ID"] for r in records
}) != len(records):
    raise ValueError("Duplicate SALES_ITEM_ID.")

valid_sales_ids = set(sales_ids)
valid_product_ids = set(product_ids)

invalid_sales = sum(
    r["SALES_ID"] not in valid_sales_ids
    for r in records
)

invalid_products = sum(
    r["PRODUCT_ID"] not in valid_product_ids
    for r in records
)

if invalid_sales != 0 or invalid_products != 0:
    raise ValueError(
        "Invalid foreign key references detected."
    )

if set(r["SALES_ID"] for r in records) != valid_sales_ids:
    raise ValueError(
        "Not every sale has at least one item."
    )

if any(
    r["QUANTITY"] <= 0
    or Decimal(r["UNIT_PRICE"]) <= 0
    or not (
        Decimal("0")
        <= Decimal(r["DISCOUNT_PERCENT"])
        <= Decimal("100")
    )
    for r in records
):
    raise ValueError(
        "Invalid quantity, price, or discount."
    )

# ------------------------------------------
# 8. EXPORT CSV
# ------------------------------------------

fieldnames = [
    "SALES_ITEM_ID",
    "SALES_ID",
    "PRODUCT_ID",
    "QUANTITY",
    "UNIT_PRICE",
    "DISCOUNT_PERCENT"
]

with open(
    OUTPUT_FILE,
    "w",
    newline="",
    encoding="utf-8"
) as file:

    writer = csv.DictWriter(
        file,
        fieldnames=fieldnames
    )

    writer.writeheader()
    writer.writerows(records)

# ------------------------------------------
# 9. GENERATION SUMMARY
# ------------------------------------------

category_lookup = {
    int(p["PRODUCT_ID"]): int(p["CATEGORY_ID"])
    for p in products
}

category_counts = Counter(
    category_lookup[r["PRODUCT_ID"]]
    for r in records
)

print("\nSALES ITEMS GENERATION COMPLETE")
print("--------------------------------")
print(f"Total Sales: {len(sales)}")
print(f"Total Products: {len(products)}")
print(f"Generated Sales Items: {len(records)}")
print(f"Maximum Allowed: {MAX_RECORDS}")

print(f"Invalid Sales References: {invalid_sales}")
print(f"Invalid Product References: {invalid_products}")

print("\nSales Items by Category:")
for category_id in sorted(category_weights):
    print(
        f"Category {category_id}: "
        f"{category_counts[category_id]}"
    )

print(f"\nCSV File: {OUTPUT_FILE}")
print("All sales item validations passed.")
