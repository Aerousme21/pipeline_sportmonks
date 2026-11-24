select *
from (select count(xg) as n_xg_filled from {{ ref('fct_player_match') }})
where n_xg_filled = 0
