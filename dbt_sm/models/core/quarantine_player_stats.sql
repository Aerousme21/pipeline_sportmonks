select *
from {{ ref('int_player_checked') }}
where quarantine_reason is not null
