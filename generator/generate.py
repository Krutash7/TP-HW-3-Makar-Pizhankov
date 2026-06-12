import csv
import random
import os
import sys

NUM_ROWS = 50


COLUMNS = ["Имя_Героя", "Класс", "Уровень", "Золото_в_кошельке"]

def generate_row():
    names = ["Арагорн", "Гэндальф", "Леголас", "Гимли", "Боромир", "Фродо", "Сэм", "Джайна", "Тралл", "Иллидан"]
    classes = ["Воин", "Маг", "Лучник", "Жрец", "Разбойник", "Паладин"]

    return {
        "Имя_Героя": random.choice(names),
        "Класс": random.choice(classes),
        "Уровень": random.randint(1, 80),
        "Золото_в_кошельке": round(random.uniform(10.5, 9999.9), 2),
    }

OUTPUT_DIR = sys.argv[1] if len(sys.argv) > 1 else "/data"
OUTPUT_FILE = os.path.join(OUTPUT_DIR, "data.csv")

os.makedirs(OUTPUT_DIR, exist_ok=True)

rows = [generate_row() for _ in range(NUM_ROWS)]

with open(OUTPUT_FILE, "w", newline="", encoding="utf-8") as f:
    writer = csv.DictWriter(f, fieldnames=COLUMNS)
    writer.writeheader()
    writer.writerows(rows)