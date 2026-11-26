
import csv
import random
from pathlib import Path
from decimal import Decimal, ROUND_HALF_UP
from collections import Counter

# ==========================================
# SAP HANA SALES & CUSTOMER ANALYTICS
# REALISTIC PRODUCT DATA GENERATION
# ==========================================

random.seed(42)

OUTPUT_FILE = Path(__file__).resolve().parent / "product_data.csv"

# Product details:
# (Product Name, Minimum Price, Maximum Price,
#  Minimum Stock, Maximum Stock)
#
# Prices are approximate synthetic INR ranges,
# not live market quotations.

products_by_category = {

    # CATEGORY 1: ELECTRONICS
    1: [
        ("Samsung Galaxy Smartphone", 12000, 85000, 10, 70),
        ("Apple iPhone", 45000, 130000, 5, 40),
        ("Dell Laptop", 35000, 110000, 5, 35),
        ("HP Laptop", 32000, 95000, 5, 40),
        ("Lenovo Tablet", 12000, 45000, 10, 65),
        ("Samsung LED Monitor", 7500, 32000, 10, 65),
        ("Wireless Mouse", 399, 1999, 40, 200),
        ("Mechanical Keyboard", 1499, 6999, 20, 120),
        ("Bluetooth Headphones", 999, 7999, 25, 150),
        ("Wireless Earbuds", 799, 9999, 30, 180),
        ("Smart Watch", 1499, 14999, 20, 120),
        ("Bluetooth Speaker", 899, 6999, 25, 130),
        ("Power Bank", 699, 2999, 40, 180),
        ("USB Flash Drive", 299, 1499, 60, 250),
        ("External SSD", 2999, 12999, 15, 90),
        ("WiFi Router", 1199, 5999, 20, 100),
        ("Webcam", 999, 4999, 20, 100),
        ("Laser Printer", 8999, 29999, 5, 35),
        ("Gaming Controller", 1299, 5999, 20, 100),
        ("Laptop Backpack", 799, 3499, 30, 150)
    ],

    # CATEGORY 2: CLOTHING
    2: [
        ("Men Cotton T-Shirt", 299, 999, 60, 250),
        ("Women Cotton T-Shirt", 299, 999, 60, 250),
        ("Men Formal Shirt", 699, 1999, 35, 170),
        ("Women Casual Shirt", 599, 1799, 35, 170),
        ("Men Denim Jeans", 999, 2999, 30, 150),
        ("Women Denim Jeans", 999, 2999, 30, 150),
        ("Men Formal Trousers", 899, 2499, 30, 140),
        ("Women Leggings", 399, 1199, 45, 200),
        ("Men Casual Jacket", 1499, 3999, 15, 90),
        ("Women Winter Jacket", 1699, 4499, 15, 90),
        ("Cotton Kurta", 599, 1799, 35, 160),
        ("Traditional Saree", 999, 5999, 20, 100),
        ("Men Sports Shorts", 399, 1199, 45, 200),
        ("Women Sports Leggings", 599, 1799, 40, 180),
        ("Cotton Hoodie", 899, 2499, 30, 140),
        ("Men Polo T-Shirt", 599, 1699, 45, 190),
        ("Women Summer Dress", 799, 2799, 30, 130),
        ("Men Track Pants", 599, 1799, 40, 180),
        ("Women Cotton Top", 399, 1299, 50, 200),
        ("Denim Jacket", 1499, 3499, 20, 100)
    ],

    # CATEGORY 3: SPORTS AND FITNESS
    3: [
        ("Yoga Mat", 399, 1999, 35, 160),
        ("Dumbbell Set", 999, 6999, 15, 80),
        ("Resistance Bands", 299, 1499, 40, 200),
        ("Skipping Rope", 149, 799, 50, 220),
        ("Cricket Bat", 799, 6999, 20, 110),
        ("Cricket Ball", 149, 899, 45, 200),
        ("Football", 499, 2499, 30, 150),
        ("Basketball", 599, 2999, 25, 130),
        ("Badminton Racket", 699, 4999, 25, 120),
        ("Badminton Shuttlecock Set", 299, 1499, 40, 170),
        ("Table Tennis Bat", 399, 2499, 30, 140),
        ("Tennis Ball Set", 249, 999, 40, 180),
        ("Gym Gloves", 299, 1499, 40, 180),
        ("Gym Water Bottle", 199, 999, 50, 220),
        ("Fitness Exercise Bench", 3999, 15999, 5, 35),
        ("Treadmill", 19999, 69999, 5, 20),
        ("Cycling Helmet", 799, 3999, 20, 100),
        ("Sports Shoes", 999, 7999, 30, 140),
        ("Foam Roller", 499, 1999, 30, 140),
        ("Pull Up Bar", 799, 3499, 20, 100)
    ],

    # CATEGORY 4: GROCERIES
    4: [
        ("Basmati Rice 5kg", 399, 999, 60, 250),
        ("Wheat Flour 5kg", 199, 449, 70, 250),
        ("Toor Dal 1kg", 119, 249, 70, 250),
        ("Moong Dal 1kg", 109, 229, 70, 250),
        ("Sugar 1kg", 40, 79, 80, 250),
        ("Salt 1kg", 20, 49, 80, 250),
        ("Cooking Oil 1L", 119, 249, 70, 250),
        ("Tea Powder 500g", 149, 449, 60, 230),
        ("Coffee Powder 200g", 149, 499, 50, 200),
        ("Breakfast Cereal 500g", 179, 449, 50, 200),
        ("Oats 1kg", 149, 349, 60, 230),
        ("Peanut Butter 500g", 179, 449, 50, 190),
        ("Tomato Ketchup 500g", 79, 179, 60, 230),
        ("Biscuits Family Pack", 49, 199, 80, 250),
        ("Pasta 500g", 69, 199, 60, 230),
        ("Instant Noodles Pack", 49, 149, 80, 250),
        ("Mixed Spices Pack", 99, 349, 60, 220),
        ("Honey 500g", 179, 449, 45, 180),
        ("Dry Fruits 500g", 349, 999, 35, 160),
        ("Packaged Fruit Juice 1L", 89, 199, 70, 240)
    ],

    # CATEGORY 5: SELF CARE
    5: [
        ("Herbal Shampoo 500ml", 199, 699, 50, 200),
        ("Hair Conditioner 200ml", 149, 499, 50, 200),
        ("Face Wash 100ml", 129, 499, 50, 220),
        ("Moisturizing Cream 100g", 149, 599, 45, 190),
        ("Sunscreen SPF 50", 299, 999, 40, 170),
        ("Body Lotion 400ml", 199, 699, 50, 200),
        ("Hand Wash 250ml", 79, 249, 70, 250),
        ("Bathing Soap Pack", 99, 349, 70, 250),
        ("Toothpaste 150g", 79, 249, 70, 250),
        ("Toothbrush Pack", 69, 299, 70, 250),
        ("Deodorant Spray 150ml", 149, 499, 50, 200),
        ("Hair Oil 200ml", 119, 399, 60, 220),
        ("Face Serum 30ml", 299, 1299, 30, 130),
        ("Lip Balm", 99, 349, 50, 200),
        ("Body Wash 250ml", 149, 499, 50, 200),
        ("Shaving Cream 100g", 99, 299, 60, 220),
        ("Hand Sanitizer 500ml", 99, 299, 60, 220),
        ("Talcum Powder 200g", 99, 299, 60, 220),
        ("Face Moisturizer 50g", 199, 699, 40, 180),
        ("Body Scrub 200g", 249, 799, 35, 150)
    ]
}

# ------------------------------------------
# 1. PRICE GENERATION
# ------------------------------------------

def generate_price(min_price, max_price):

    # Prefer prices toward the lower-middle of
    # each realistic product-specific range.
    price = random.triangular(
        min_price,
        max_price,
        min_price + (max_price - min_price) * 0.35
    )

    # Round to whole rupees for clean catalog prices.
    rounded = Decimal(str(price)).quantize(
        Decimal("1"),
        rounding=ROUND_HALF_UP
    )

    return f"{rounded:.2f}"

# ------------------------------------------
# 2. GENERATE PRODUCT RECORDS
# ------------------------------------------

records = []
product_id = 1

for category_id, product_list in products_by_category.items():

    for (
        product_name,
        min_price,
        max_price,
        min_stock,
        max_stock
    ) in product_list:

        unit_price = generate_price(
            min_price,
            max_price
        )

        stock_quantity = random.randint(
            min_stock,
            max_stock
        )

        records.append({
            "PRODUCT_ID": product_id,
            "PRODUCT_NAME": product_name,
            "CATEGORY_ID": category_id,
            "UNIT_PRICE": unit_price,
            "STOCK_QUANTITY": stock_quantity
        })

        product_id += 1

# ------------------------------------------
# 3. DATA VALIDATION
# ------------------------------------------

assert len(records) == 100, "Expected 100 products."

assert len({
    p["PRODUCT_ID"] for p in records
}) == 100, "Duplicate product IDs detected."

assert len({
    p["PRODUCT_NAME"] for p in records
}) == 100, "Duplicate product names detected."

assert all(
    Decimal(p["UNIT_PRICE"]) > 0
    for p in records
), "Invalid product price detected."

assert all(
    p["STOCK_QUANTITY"] > 0
    for p in records
), "Invalid stock quantity detected."

assert set(
    p["CATEGORY_ID"] for p in records
) == {1, 2, 3, 4, 5}

# ------------------------------------------
# 4. EXPORT CSV
# ------------------------------------------

fieldnames = [
    "PRODUCT_ID",
    "PRODUCT_NAME",
    "CATEGORY_ID",
    "UNIT_PRICE",
    "STOCK_QUANTITY"
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
# 5. GENERATION SUMMARY
# ------------------------------------------

category_counts = Counter(
    p["CATEGORY_ID"] for p in records
)

print("\nPRODUCT DATA GENERATION COMPLETE")
print("--------------------------------")
print(f"Total Products: {len(records)}")
print(f"CSV File: {OUTPUT_FILE}")

print("\nProducts by Category:")

category_names = {
    1: "Electronics",
    2: "Clothing",
    3: "Sports and Fitness",
    4: "Groceries",
    5: "Self Care"
}

for category_id in sorted(category_names):

    print(
        f"{category_names[category_id]}: "
        f"{category_counts[category_id]}"
    )

print("\nAll product validations passed.")
