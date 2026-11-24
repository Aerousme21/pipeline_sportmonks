cd ~/pipeline_sportmonks
source .venv-airflow/bin/activate
export PROJECT_DIR=$(pwd)
export DBT_BIN=$(pwd)/.venv-dbt/bin/dbt
export AIRFLOW_HOME=$(pwd)/airflow_home
export AIRFLOW__CORE__DAGS_FOLDER=$(pwd)/dags
export AIRFLOW__CORE__LOAD_EXAMPLES=False
