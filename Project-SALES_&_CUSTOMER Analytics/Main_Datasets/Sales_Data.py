
import csv
import random
from datetime import date, timedelta
from pathlib import Path
from collections import Counter

# ==========================================
# SAP HANA SALES & CUSTOMER ANALYTICS
# REALISTIC SALES DATA GENERATION
# ==========================================

random.seed(42)

BASE_DIR = Path(__file__).resolve().parent

CUSTOMER_FILE = BASE_DIR / "customer_data.csv"
OUTPUT_FILE = BASE_DIR / "sales_data.csv"

TOTAL_SALES = 5000

SALES_START = date(2024, 1, 1)
SALES_END = date(2026, 11, 16)

# ------------------------------------------
# 1. READ CUSTOMER DATA
# ------------------------------------------

if not CUSTOMER_FILE.exists():
    raise FileNotFoundError(
        "customer_data.csv not found. "
        "Run Customers_Data.py first."
    )

with open(
    CUSTOMER_FILE,
    "r",
    encoding="utf-8-sig",
    newline=""
) as file:
    customers = list(csv.DictReader(file))

if len(customers) != 500:
    raise ValueError(
        f"Expected 500 customers, found {len(customers)}."
    )

customer_registration = {}

for customer in customers:

    customer_id = int(customer["CUSTOMER_ID"])
    registration_date = date.fromisoformat(
        customer["REG_DATE"]
    )

    if customer_id in customer_registration:
        raise ValueError(
            f"Duplicate CUSTOMER_ID: {customer_id}"
        )

    customer_registration[customer_id] = registration_date

# ------------------------------------------
# 2. CUSTOMER PURCHASING BEHAVIOR
# ------------------------------------------

# Some customers purchase much more frequently
# than others. This produces repeat customers.

customer_ids = list(customer_registration.keys())

customer_weights = {}

for customer_id in customer_ids:

    customer_weights[customer_id] = random.choices(
        [1, 2, 4, 8],
        weights=[35, 35, 20, 10],
        k=1
    )[0]

# ------------------------------------------
# 3. PAYMENT METHODS
# ------------------------------------------

payment_methods = [
    "UPI",
    "Credit Card",
    "Debit Card",
    "Net Banking",
    "Cash on Delivery"
]

payment_weights = [45, 20, 15, 5, 15]

# ------------------------------------------
# 4. ORDER STATUS
# ------------------------------------------

order_statuses = [
    "Delivered",
    "Shipped",
    "Processing",
    "Cancelled",
    "Returned"
]

order_status_weights = [78, 8, 5, 6, 3]

# ------------------------------------------
# 5. SEASONAL PURCHASE DATE GENERATION
# ------------------------------------------

# Synthetic seasonal demand weights.
# October/November receive higher weights
# to simulate festive shopping activity.

month_weights = {
    1: 7,
    2: 7,
    3: 8,
    4: 7,
    5: 8,
    6: 7,
    7: 8,
    8: 9,
    9: 9,
    10: 13,
    11: 12,
    12: 5
}

def generate_purchase_date(registration_date):

    earliest_date = max(
        SALES_START,
        registration_date
    )

    if earliest_date > SALES_END:
        raise ValueError(
            "Customer registration occurs "
            "after the sales period."
        )

    # Generate a date within the valid period.
    # A precomputed list avoids rejection loops.
    possible_dates = []
    possible_weights = []

    current_date = earliest_date

    while current_date <= SALES_END:

        possible_dates.append(current_date)

        possible_weights.append(
            month_weights[current_date.month]
        )

        current_date += timedelta(days=1)

    return random.choices(
        possible_dates,
        weights=possible_weights,
        k=1
    )[0]

# ------------------------------------------
# 6. GENERATE SALES
# ------------------------------------------

sales_records = []

for sales_id in range(1, TOTAL_SALES + 1):

    customer_id = random.choices(
        customer_ids,
        weights=[
            customer_weights[cid]
            for cid in customer_ids
        ],
        k=1
    )[0]

    registration_date = customer_registration[
        customer_id
    ]

    purchase_date = generate_purchase_date(
        registration_date
    )

    payment_method = random.choices(
        payment_methods,
        weights=payment_weights,
        k=1
    )[0]

    order_status = random.choices(
        order_statuses,
        weights=order_status_weights,
        k=1
    )[0]

    sales_records.append({
        "SALES_ID": sales_id,
        "CUSTOMER_ID": customer_id,
        "PURCHASE_DATE": purchase_date.isoformat(),
        "PAYMENT_METHOD": payment_method,
        "ORDER_STATUS": order_status
    })

# ------------------------------------------
# 7. VALIDATE SALES DATA
# ------------------------------------------

assert len(sales_records) == TOTAL_SALES

assert len({
    s["SALES_ID"] for s in sales_records
}) == TOTAL_SALES

invalid_dates = 0
invalid_customers = 0

for sale in sales_records:

    customer_id = sale["CUSTOMER_ID"]

    if customer_id not in customer_registration:
        invalid_customers += 1
        continue

    purchase_date = date.fromisoformat(
        sale["PURCHASE_DATE"]
    )

    registration_date = customer_registration[
        customer_id
    ]

    if purchase_date < registration_date:
        invalid_dates += 1

    if not SALES_START <= purchase_date <= SALES_END:
        raise ValueError(
            f"Purchase outside sales period: "
            f"{sale['SALES_ID']}"
        )

assert invalid_dates == 0
assert invalid_customers == 0

# ------------------------------------------
# 8. EXPORT CSV
# ------------------------------------------

fieldnames = [
    "SALES_ID",
    "CUSTOMER_ID",
    "PURCHASE_DATE",
    "PAYMENT_METHOD",
    "ORDER_STATUS"
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
    writer.writerows(sales_records)

# ------------------------------------------
# 9. GENERATION SUMMARY
# ------------------------------------------

status_counts = Counter(
    s["ORDER_STATUS"] for s in sales_records
)

payment_counts = Counter(
    s["PAYMENT_METHOD"] for s in sales_records
)

year_counts = Counter(
    date.fromisoformat(s["PURCHASE_DATE"]).year
    for s in sales_records
)

print("\nSALES DATA GENERATION COMPLETE")
print("--------------------------------")
print(f"Total Sales: {len(sales_records)}")
print(f"Invalid Customer References: {invalid_customers}")
print(f"Invalid Registration/Purchase Dates: {invalid_dates}")
print(f"CSV File: {OUTPUT_FILE}")

print("\nSales by Year:")
for year in sorted(year_counts):
    print(f"{year}: {year_counts[year]}")

print("\nOrder Status:")
for status, count in status_counts.items():
    print(f"{status}: {count}")

print("\nPayment Methods:")
for method, count in payment_counts.items():
    print(f"{method}: {count}")

print("\nAll sales validations passed.")
