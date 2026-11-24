select
    l.league_id,
    l.nama_liga,
    l.negara,
    f.season_id,
    count(distinct f.player_id)   as total_players,
    count(distinct f.fixture_id)  as total_fixtures,
    round(avg(f.rating), 2)       as avg_rating,
    sum(f.goals)                  as total_goals,
    round(sum(f.xg), 2)           as total_xg
from {{ ref('fct_player_match') }} f
left join {{ ref('stg_ref_liga') }} l on f.league_id = l.league_id
group by l.league_id, l.nama_liga, l.negara, f.season_id
