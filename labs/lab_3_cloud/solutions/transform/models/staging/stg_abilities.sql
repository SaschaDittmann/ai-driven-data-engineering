select
    cast(abilities.id as integer) as ability_id,
    cast(abilities.name as string) as ability_name,
    cast(abilities.is_main_series as boolean) as is_main_series,
    cast(abilities.generation__name as string) as generation_name,
    loads.inserted_at as _loaded_at
from {{ source('raw', 'abilities') }} as abilities
left join {{ source('raw', '_dlt_loads') }} as loads
    on abilities._dlt_load_id = loads.load_id
