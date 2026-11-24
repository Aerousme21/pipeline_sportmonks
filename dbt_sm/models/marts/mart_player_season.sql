select
    player_id,
    team_id,
    league_id,
    season_id,
    max(player_name)                    as player_name,
    count(distinct fixture_id)          as total_fixtures,
    sum(minutes_played)                 as total_minutes,
    round(avg(rating), 2)               as avg_rating,
    sum(goals)                          as total_goals,
    sum(assists)                        as total_assists,
    count(xg)                           as fixtures_with_xg,
    round(sum(xg), 2)                   as total_xg,
    round(sum(case when xg is not null then coalesce(goals, 0) end) - sum(xg), 2) as goals_minus_xg
from {{ ref('fct_player_match') }}
group by player_id, team_id, league_id, season_id
