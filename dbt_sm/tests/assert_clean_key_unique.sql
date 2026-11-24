select fixture_id, player_id, count(*) as n
from {{ ref('fct_player_match') }}
group by fixture_id, player_id
having count(*) > 1
