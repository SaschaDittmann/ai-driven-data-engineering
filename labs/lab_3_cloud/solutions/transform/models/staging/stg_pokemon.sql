select
    cast(pokemon.id as integer) as pokemon_id,
    cast(pokemon.name as string) as pokemon_name,
    cast(pokemon.base_experience as integer) as base_experience,
    cast(pokemon.height as integer) as height,
    cast(pokemon.weight as integer) as weight,
    cast(pokemon.is_default as boolean) as is_default,
    cast(pokemon."order" as integer) as pokemon_order,
    cast(pokemon.species__name as string) as species_name,
    loads.inserted_at as _loaded_at
from {{ source('raw', 'pokemon') }} as pokemon
left join {{ source('raw', '_dlt_loads') }} as loads
    on pokemon._dlt_load_id = loads.load_id
