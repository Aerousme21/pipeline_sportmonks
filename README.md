# Pipeline ELT Statistik Pemain Sepak Bola (Sportmonks)

Pipeline ELT: CSV -> DuckDB (raw) -> dbt (staging, clean, quarantine, mart) -> dbt test, dijadwalkan Apache Airflow.

## Struktur
- `pipeline/el.py`: extract dan load ke skema `raw` (idempotent)
- `dbt_sm/`: model, test, dan profil dbt
- `dags/sportmonks_elt_dag.py`: DAG Airflow (jadwal harian 02.00 UTC, retry 2 kali)
- `data/raw/`: letak berkas sumber (lihat bagian Data)

## Prasyarat
Ubuntu (WSL2), Python 3.10-3.12.

## Data
Berkas `data/raw/player_stats.csv` (snapshot Sportmonks Football API) tidak disertakan karena ketentuan penggunaan data Sportmonks. Letakkan berkas tersebut pada `data/raw/`. Berkas `ref_liga.csv` sudah disertakan. Tidak ada kredensial pada paket ini.

## Menjalankan dari awal
```bash
python3 -m venv .venv-dbt && source .venv-dbt/bin/activate
pip install -r requirements-dbt.txt
python -m pipeline.el
export DBT_PROJECT_DIR=dbt_sm DBT_PROFILES_DIR=dbt_sm
dbt run && dbt test
deactivate
```

## Menjalankan dengan Airflow
```bash
python3 -m venv .venv-airflow && source .venv-airflow/bin/activate
# pasang apache-airflow sesuai dokumentasi resmi (dengan file constraints), lalu:
pip install duckdb
export PROJECT_DIR=$(pwd) DBT_BIN=$(pwd)/.venv-dbt/bin/dbt
export AIRFLOW_HOME=$(pwd)/airflow_home AIRFLOW__CORE__DAGS_FOLDER=$(pwd)/dags
export AIRFLOW__CORE__LOAD_EXAMPLES=False
airflow standalone
```
Buka http://localhost:8080, aktifkan DAG `sportmonks_elt`, lalu Trigger.

## Catatan
DuckDB hanya mengizinkan satu proses penulis; jangan membuka `warehouse.duckdb` saat DAG berjalan.
