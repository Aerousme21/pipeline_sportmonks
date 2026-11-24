select
    quarantine_reason,
    count(*) as total_rows,
    round(100.0 * count(*) / (select count(*) from {{ ref('stg_player_stats') }}), 2) as pct_of_raw
from {{ ref('quarantine_player_stats') }}
group by quarantine_reason
