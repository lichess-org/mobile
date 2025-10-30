#!/usr/bin/env python3

# usage: ./update_openings_db.py <path to lichess-org/chess-openings repo>

import csv
import os
import sys
import sqlite3

path_to_chess_openings = sys.argv[1]

os.system(f"cd {path_to_chess_openings} && make all")

conn = sqlite3.connect('../assets/chess_openings.db')
cur = conn.cursor()
cur.execute('DELETE FROM openings;')
conn.commit()

with open(os.path.join(path_to_chess_openings, 'dist/all.tsv'), 'r') as f:
    dr = csv.DictReader(f, delimiter='\t')
    to_db = [(i['eco'], i['name'], i['pgn'], i['uci'], i['epd']) for i in dr]

cur.executemany('INSERT INTO openings (eco, name, pgn, uci, epd) VALUES (?, ?, ?, ?, ?);', to_db)
conn.commit()
conn.close()
