with pokemon_types as (
    select
        cast(raw_pokemon.id as integer) as pokemon_id,
        max(case when pokemon_types.slot = 1 then pokemon_types.type__name end) as primary_type,
        max(case when pokemon_types.slot = 2 then pokemon_types.type__name end) as secondary_type
    from {{ source('raw', 'pokemon') }} as raw_pokemon
    inner join {{ source('raw', 'pokemon__types') }} as pokemon_types
        on raw_pokemon._dlt_id = pokemon_types._dlt_root_id
    group by raw_pokemon.id
),

pokemon_moves as (
    select
        cast(raw_pokemon.id as integer) as pokemon_id,
        cast(pokemon_moves.move__name as string) as move_name
    from {{ source('raw', 'pokemon') }} as raw_pokemon
    inner join {{ source('raw', 'pokemon__moves') }} as pokemon_moves
        on raw_pokemon._dlt_id = pokemon_moves._dlt_root_id
)

select
    pokemon.pokemon_name,
    moves.move_name,
    moves.move_type,
    moves.power,
    moves.accuracy,
    moves.damage_class,
    coalesce(
        moves.move_type = pokemon_types.primary_type
        or moves.move_type = pokemon_types.secondary_type,
        false
    ) as is_stab,
    case
        when moves.power is null then null
        when moves.move_type = pokemon_types.primary_type
            or moves.move_type = pokemon_types.secondary_type
            then cast(moves.power as {{ 'float64' if target.type == 'bigquery' else 'double' }}) * 1.5
        else cast(moves.power as {{ 'float64' if target.type == 'bigquery' else 'double' }})
    end as stab_adjusted_power
from {{ ref('stg_pokemon') }} as pokemon
inner join pokemon_types
    on pokemon.pokemon_id = pokemon_types.pokemon_id
inner join pokemon_moves
    on pokemon.pokemon_id = pokemon_moves.pokemon_id
inner join {{ ref('stg_moves') }} as moves
    on pokemon_moves.move_name = moves.move_name
