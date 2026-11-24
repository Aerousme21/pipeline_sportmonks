select
    try_cast(league_id as bigint) as league_id,
    nama_liga,
    negara
from {{ source('raw', 'ref_liga') }}
