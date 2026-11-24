select *
from (
    select
        (select count(*) from {{ ref('stg_player_stats') }}) as n_raw,
        (select count(*) from {{ ref('fct_player_match') }})
          + (select count(*) from {{ ref('quarantine_player_stats') }}) as n_split
)
where n_raw <> n_split
