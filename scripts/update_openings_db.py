#!/usr/bin/env python3

import csv
import os
import sqlite3
import subprocess
import sys

if len(sys.argv) <= 1:
    print("Usage: ./update_openings_db.py <path to lichess-org/chess-openings repo>")
    sys.exit(1)

path_to_chess_openings = sys.argv[1]

if not os.path.isdir(path_to_chess_openings):
    print(f"Error: {path_to_chess_openings} is not a valid directory.")
    sys.exit(1)

subprocess.run(["make", "all"], cwd=path_to_chess_openings, check=True)

db_path = os.path.join(os.path.dirname(__file__), '../assets/chess_openings.db')
conn = sqlite3.connect(db_path)

old_openings = set()
new_openings = set()

openings_sql = 'SELECT eco || " " || name || " " || pgn FROM openings ORDER BY eco, name, pgn;'

with open(os.path.join(path_to_chess_openings, 'dist/all.tsv'), 'r') as f:
    dr = csv.DictReader(f, delimiter='\t')
    to_db = [(i['eco'], i['name'], i['pgn'], i['uci'], i['epd']) for i in dr]

    cur = conn.cursor()

    old_openings = set(row[0] for row in cur.execute(openings_sql))
    cur.execute('DELETE FROM openings;')
    conn.commit()

    cur.executemany('INSERT INTO openings (eco, name, pgn, uci, epd) VALUES (?, ?, ?, ?, ?);', to_db)
    conn.commit()
    new_openings = set(row[0] for row in cur.execute(openings_sql))
conn.close()

print(f"Opening changes:")
print("```diff")
[print(f"-  {o}") for o in sorted(old_openings - new_openings)]
[print(f"+  {o}") for o in sorted(new_openings - old_openings)]
print("```")
