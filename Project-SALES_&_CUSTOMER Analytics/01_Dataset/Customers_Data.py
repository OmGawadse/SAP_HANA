
import csv
import random
from datetime import date, timedelta
from pathlib import Path
from collections import Counter

# ==========================================
# SAP HANA SALES & CUSTOMER ANALYTICS
# CUSTOMER DATA GENERATION
# ==========================================

random.seed(42)

TOTAL_CUSTOMERS = 500
OUTPUT_FILE = Path(__file__).resolve().parent / "customer_data.csv"

START_DATE = date(2022, 1, 1)
END_DATE = date(2026, 10, 31)

# ------------------------------------------
# 1. INDIAN CUSTOMER NAMES
# ------------------------------------------

first_names = [
    "Aarav", "Aditya", "Arjun", "Rahul", "Rohan",
    "Amit", "Vikram", "Karan", "Siddharth", "Om",
    "Rohit", "Akash", "Nikhil", "Sahil", "Pranav",
    "Yash", "Harsh", "Aniket", "Saurabh", "Varun",
    "Priya", "Ananya", "Sneha", "Neha", "Pooja",
    "Aisha", "Kavya", "Isha", "Riya", "Meera",
    "Tanvi", "Sakshi", "Shruti", "Divya", "Anjali",
    "Nisha", "Aditi", "Simran", "Swati", "Pallavi"
]

last_names = [
    "Sharma", "Patil", "Deshmukh", "Joshi",
    "Kulkarni", "Shah", "Verma", "Gupta",
    "Reddy", "Nair", "Iyer", "Singh",
    "Khan", "Mehta", "Pawar", "Jadhav",
    "More", "Mishra", "Das", "Rao",
    "Chavan", "Shinde", "Yadav", "Kapoor",
    "Bose", "Naik", "Shetty", "Malhotra",
    "Saxena", "Bhat"
]

# ------------------------------------------
# 2. REGIONS AND CITIES
# Match REGION table IDs in SAP HANA
# ------------------------------------------

regions = {
    1: [
        "Delhi", "Jaipur",
        "Chandigarh", "Lucknow"
    ],
    2: [
        "Bengaluru", "Chennai",
        "Hyderabad", "Kochi"
    ],
    3: [
        "Kolkata", "Patna",
        "Bhubaneswar", "Ranchi"
    ],
    4: [
        "Mumbai", "Pune",
        "Ahmedabad", "Surat"
    ],
    5: [
        "Bhopal", "Indore",
        "Nagpur", "Raipur"
    ]
}

# Approximate synthetic customer distribution
region_weights = [22, 25, 15, 28, 10]

# ------------------------------------------
# 3. REGISTRATION DATE GENERATION
# ------------------------------------------

# Synthetic growth pattern by year
year_weights = {
    2022: 10,
    2023: 15,
    2024: 25,
    2025: 30,
    2026: 20
}

def generate_registration_date():

    year = random.choices(
        list(year_weights.keys()),
        weights=list(year_weights.values()),
        k=1
    )[0]

    year_start = max(
        START_DATE,
        date(year, 1, 1)
    )

    year_end = min(
        END_DATE,
        date(year, 12, 31)
    )

    available_days = (year_end - year_start).days

    return year_start + timedelta(
        days=random.randint(0, available_days)
    )

# ------------------------------------------
# 4. GENERATE CUSTOMERS
# ------------------------------------------

customers = []

for customer_id in range(1, TOTAL_CUSTOMERS + 1):

    first_name = random.choice(first_names)
    last_name = random.choice(last_names)

    full_name = f"{first_name} {last_name}"

    region_id = random.choices(
        list(regions.keys()),
        weights=region_weights,
        k=1
    )[0]

    city = random.choice(regions[region_id])

    # Unique synthetic email
    email = (
        f"{first_name.lower()}."
        f"{last_name.lower()}."
        f"{customer_id}@example.com"
    )

    # Synthetic 10-digit phone number
    phone_number = str(9000000000 + customer_id)

    registration_date = generate_registration_date()

    customers.append({
        "CUSTOMER_ID": customer_id,
        "NAME": full_name,
        "CITY": city,
        "EMAIL": email,
        "PHN_NO": phone_number,
        "REG_DATE": registration_date.isoformat(),
        "REGION_ID": region_id
    })

# ------------------------------------------
# 5. VALIDATE DATA BEFORE EXPORT
# ------------------------------------------

assert len(customers) == TOTAL_CUSTOMERS

assert len({
    c["CUSTOMER_ID"] for c in customers
}) == TOTAL_CUSTOMERS

assert len({
    c["EMAIL"] for c in customers
}) == TOTAL_CUSTOMERS

assert all(
    len(c["PHN_NO"]) == 10
    and c["PHN_NO"].isdigit()
    for c in customers
)

assert all(
    START_DATE <= date.fromisoformat(c["REG_DATE"]) <= END_DATE
    for c in customers
)

assert all(
    c["CITY"] in regions[c["REGION_ID"]]
    for c in customers
)

# ------------------------------------------
# 6. EXPORT CSV
# ------------------------------------------

fieldnames = [
    "CUSTOMER_ID",
    "NAME",
    "CITY",
    "EMAIL",
    "PHN_NO",
    "REG_DATE",
    "REGION_ID"
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
    writer.writerows(customers)

# ------------------------------------------
# 7. GENERATION SUMMARY
# ------------------------------------------

region_counts = Counter(
    c["REGION_ID"] for c in customers
)

year_counts = Counter(
    date.fromisoformat(c["REG_DATE"]).year
    for c in customers
)

print("\nCUSTOMER DATA GENERATION COMPLETE")
print("--------------------------------")
print(f"Total Customers: {len(customers)}")
print(f"Unique Emails: {len(set(c['EMAIL'] for c in customers))}")
print(f"CSV File: {OUTPUT_FILE}")

print("\nCustomers by Region:")
for region_id in sorted(regions):
    print(
        f"Region {region_id}: "
        f"{region_counts[region_id]}"
    )

print("\nRegistrations by Year:")
for year in sorted(year_weights):
    print(
        f"{year}: {year_counts[year]}"
    )

print("\nAll customer validations passed.")
