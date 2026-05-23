import csv
import random
from datetime import datetime

OUTPUT_FILE = "ac_sales_data.csv"

BRANDS = ["LG", "Samsung", "Daikin", "Hitachi", "Voltas", "Godrej"]
AC_TYPES = ["Window", "Split", "Inverter", "Portable"]
MONTHS = ["April", "May", "June"]


def generate_sales_data(start_year=2018, end_year=2025):
    header = ["year", "month", "temperature", "cost", "ac_type", "brand"]
    rows = []

    for year in range(start_year, end_year + 1):
        for month in MONTHS:
            for _ in range(150):
                temperature = round(random.uniform(22.0, 42.0), 1)
                ac_type = random.choices(
                    AC_TYPES,
                    weights=[2, 5, 4, 1],
                    k=1,
                )[0]
                cost = random.choice([25000, 30000, 35000, 40000, 45000, 55000, 65000, 85000, 110000])

                brand = choose_brand(temperature, cost, ac_type, month)
                rows.append([year, month, temperature, cost, ac_type, brand])

    with open(OUTPUT_FILE, "w", newline="", encoding="utf-8") as f:
        writer = csv.writer(f)
        writer.writerow(header)
        writer.writerows(rows)
    print(f"Synthetic data generated at {OUTPUT_FILE}")


def choose_brand(temperature, cost, ac_type, month):
    if ac_type == "Inverter":
        return random.choices(["Daikin", "LG", "Samsung", "Hitachi"], [4, 3, 3, 2])[0]
    if cost >= 85000:
        return random.choices(["Daikin", "Hitachi", "LG"], [4, 3, 2])[0]
    if temperature >= 35:
        return random.choices(["Voltas", "LG", "Samsung"], [4, 3, 3])[0]
    if month == "May":
        return random.choices(["Samsung", "LG", "Godrej"], [4, 3, 2])[0]
    return random.choices(["Voltas", "Samsung", "LG", "Godrej"], [3, 3, 2, 1])[0]


def print_annual_sales(year):
    sales = {month: 0 for month in MONTHS}
    with open(OUTPUT_FILE, newline="", encoding="utf-8") as f:
        reader = csv.DictReader(f)
        for row in reader:
            if int(row["year"]) == year:
                sales[row["month"]] += 1
    print(f"Year {year} AC units sold in Apr/May/June:")
    for month in MONTHS:
        print(f"  {month}: {sales[month]} units")


def main():
    generate_sales_data()
    print_annual_sales(datetime.now().year - 1)


if __name__ == "__main__":
    main()
