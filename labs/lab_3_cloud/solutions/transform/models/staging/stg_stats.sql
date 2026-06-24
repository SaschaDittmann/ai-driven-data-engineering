select
    cast(stats.id as integer) as stat_id,
    cast(stats.name as string) as stat_name,
    cast(stats.game_index as integer) as game_index,
    cast(stats.is_battle_only as boolean) as is_battle_only,
    loads.inserted_at as _loaded_at
from {{ source('raw', 'stats') }} as stats
left join {{ source('raw', '_dlt_loads') }} as loads
    on stats._dlt_load_id = loads.load_id
