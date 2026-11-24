select * exclude (quarantine_reason)
from {{ ref('int_player_checked') }}
where quarantine_reason is null
