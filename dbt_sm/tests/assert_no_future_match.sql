select *
from {{ ref('fct_player_match') }}
where match_at > extracted_at
