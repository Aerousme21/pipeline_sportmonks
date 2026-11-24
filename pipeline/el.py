from pathlib import Path
import duckdb
BASE = Path(__file__).resolve().parent.parent
DB_PATH = str(BASE / 'warehouse.duckdb')
RAW_DIR = BASE / 'data' / 'raw'

FILES = {
    'player_stats': 'player_stats.csv',
    'ref_liga': 'ref_liga.csv',
}


def load_all() -> None:
    con = duckdb.connect(DB_PATH)
    con.execute('CREATE SCHEMA IF NOT EXISTS raw')
    for table, fname in FILES.items():
        path = RAW_DIR / fname
        if not path.exists():
            raise FileNotFoundError(f'File tidak ditemukan: {path}')
        # CREATE OR REPLACE = hapus lalu muat ulang -> aman dijalankan berulang (idempotent)
        con.execute(f'''
            CREATE OR REPLACE TABLE raw.{table} AS
            SELECT *,
                   now() AS _loaded_at,
                   '{fname}' AS _source_file
            FROM read_csv('{path.as_posix()}', header=true, all_varchar=true)
        ''')
        n = con.execute(f'SELECT count(*) FROM raw.{table}').fetchone()[0]
        if n == 0:
            raise ValueError(f'raw.{table} kosong')
        print(f'raw.{table}: {n} baris')
    con.close()


if __name__ == '__main__':
    load_all()
