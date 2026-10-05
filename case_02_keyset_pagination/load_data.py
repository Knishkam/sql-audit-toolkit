import random
from datetime import datetime, timedelta
import mysql.connector

DB = dict(host="127.0.0.1", port=3307, user="root", password="root", database="auditdb")
TOTAL_ROWS = 300_000
BATCH = 5000
random.seed(42)

def main():
    cnx = mysql.connector.connect(**DB)
    cur = cnx.cursor()
    base = datetime(2026, 1, 1, 0, 0, 0)

    rows = []
    for i in range(1, TOTAL_ROWS + 1):
        user_id = random.randint(1, 200_000)
        status = "paid" if random.random() < 0.6 else random.choice(["pending", "failed", "refunded"])
        created_at = base + timedelta(seconds=i)
        amount = round(random.uniform(10, 5000), 2)
        rows.append((user_id, status, created_at.strftime("%Y-%m-%d %H:%M:%S.%f"), amount))

        if len(rows) >= BATCH:
            cur.executemany(
                "INSERT INTO orders (user_id, status, created_at, amount) VALUES (%s,%s,%s,%s)",
                rows
            )
            cnx.commit()
            rows = []
            if i % 50_000 == 0:
                print(f"Inserted {i}/{TOTAL_ROWS}")

    if rows:
        cur.executemany(
            "INSERT INTO orders (user_id, status, created_at, amount) VALUES (%s,%s,%s,%s)",
            rows
        )
        cnx.commit()

    cur.close()
    cnx.close()
    print("Done.")

if __name__ == "__main__":
    main()