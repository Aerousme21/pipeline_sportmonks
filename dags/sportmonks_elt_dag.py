import os
import subprocess
import sys
from datetime import datetime, timedelta
from pathlib import Path

from airflow.sdk import dag, task

PROJECT = Path(os.environ.get('PROJECT_DIR', '~/pipeline_sportmonks')).expanduser()
DBT_BIN = os.environ.get('DBT_BIN', 'dbt')
DBT_DIR = str(PROJECT / 'dbt_sm')


def run_dbt(cmd: str) -> None:
    result = subprocess.run(
        [DBT_BIN, cmd, '--project-dir', DBT_DIR, '--profiles-dir', DBT_DIR],
        cwd=str(PROJECT),
        capture_output=True,
        text=True,
    )
    print(result.stdout)
    if result.returncode != 0:
        print(result.stderr)
        raise RuntimeError(f'dbt {cmd} gagal (kode {result.returncode})')


@dag(
    dag_id='sportmonks_elt',
    schedule='0 2 * * *',          # tiap hari 02.00 UTC (setelah laga malam Eropa selesai, beban rendah)
    start_date=datetime(2026, 11, 1),
    catchup=False,
    max_active_runs=1,             # DuckDB hanya mengizinkan satu penulis
    default_args={'retries': 2, 'retry_delay': timedelta(minutes=2)},
    tags=['praktikum', 'sportmonks'],
)
def sportmonks_elt():
    @task
    def extract_load():
        sys.path.insert(0, str(PROJECT))
        from pipeline.el import load_all
        load_all()

    @task
    def dbt_run():
        run_dbt('run')

    @task
    def dbt_test():
        run_dbt('test')

    extract_load() >> dbt_run() >> dbt_test()


sportmonks_elt()
