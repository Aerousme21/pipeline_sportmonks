select *
from {{ ref('fct_player_match') }}
where rating < 0 or rating > 10
