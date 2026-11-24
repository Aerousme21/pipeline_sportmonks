select
    *,
    nullif(concat_ws('; ',
        case when rating is null then 'rating_missing:rating' end,
        case when rating is not null and (rating < 0 or rating > 10)
             then 'rating_out_of_range_0_10:rating' end,
        case when posisi_id is null then 'required_missing:posisi' end,
        case when player_id is null then 'required_missing:player_id' end,
        case when fixture_id is null or team_id is null
                  or league_id is null or season_id is null
             then 'required_missing:key' end,
        case when match_at is null then 'invalid_date:tanggal' end,
        case when match_at > extracted_at then 'date_after_extraction:tanggal' end,
        case when minutes_played < 0 or xg < 0 or xgot < 0
             then 'negative_value' end
    ), '') as quarantine_reason
from {{ ref('stg_player_stats') }}
