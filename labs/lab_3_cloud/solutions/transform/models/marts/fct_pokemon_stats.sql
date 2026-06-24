with pokemon_stats_long as (
    select
        cast(raw_pokemon.id as integer) as pokemon_id,
        cast(pokemon_stats.stat__name as string) as stat_name,
        cast(pokemon_stats.base_stat as integer) as base_stat
    from {{ source('raw', 'pokemon') }} as raw_pokemon
    inner join {{ source('raw', 'pokemon__stats') }} as pokemon_stats
        on raw_pokemon._dlt_id = pokemon_stats._dlt_root_id
),

pokemon_stats_pivot as (
    select
        pokemon_id,
        max(case when stat_name = 'hp' then base_stat end) as hp,
        max(case when stat_name = 'attack' then base_stat end) as attack,
        max(case when stat_name = 'defense' then base_stat end) as defense,
        max(case when stat_name = 'special-attack' then base_stat end) as sp_attack,
        max(case when stat_name = 'special-defense' then base_stat end) as sp_defense,
        max(case when stat_name = 'speed' then base_stat end) as speed
    from pokemon_stats_long
    group by pokemon_id
),

pokemon_types as (
    select
        cast(raw_pokemon.id as integer) as pokemon_id,
        max(case when pokemon_types.slot = 1 then pokemon_types.type__name end) as primary_type,
        max(case when pokemon_types.slot = 2 then pokemon_types.type__name end) as secondary_type
    from {{ source('raw', 'pokemon') }} as raw_pokemon
    inner join {{ source('raw', 'pokemon__types') }} as pokemon_types
        on raw_pokemon._dlt_id = pokemon_types._dlt_root_id
    group by raw_pokemon.id
),

type_averages as (
    select
        pokemon_types.primary_type,
        avg(pokemon_stats_pivot.hp) as avg_hp,
        avg(pokemon_stats_pivot.attack) as avg_attack,
        avg(pokemon_stats_pivot.defense) as avg_defense,
        avg(pokemon_stats_pivot.sp_attack) as avg_sp_attack,
        avg(pokemon_stats_pivot.sp_defense) as avg_sp_defense,
        avg(pokemon_stats_pivot.speed) as avg_speed
    from pokemon_stats_pivot
    inner join pokemon_types
        on pokemon_stats_pivot.pokemon_id = pokemon_types.pokemon_id
    where pokemon_types.primary_type is not null
    group by pokemon_types.primary_type
)

select
    pokemon.pokemon_id,
    pokemon.pokemon_name,
    pokemon_types.primary_type,
    pokemon_types.secondary_type,
    pokemon_stats_pivot.hp,
    pokemon_stats_pivot.attack,
    pokemon_stats_pivot.defense,
    pokemon_stats_pivot.sp_attack,
    pokemon_stats_pivot.sp_defense,
    pokemon_stats_pivot.speed,
    (
        pokemon_stats_pivot.hp
        + pokemon_stats_pivot.attack
        + pokemon_stats_pivot.defense
        + pokemon_stats_pivot.sp_attack
        + pokemon_stats_pivot.sp_defense
        + pokemon_stats_pivot.speed
    ) as base_stat_total,
    pokemon_stats_pivot.hp - type_averages.avg_hp as hp_vs_type_avg,
    pokemon_stats_pivot.attack - type_averages.avg_attack as attack_vs_type_avg,
    pokemon_stats_pivot.defense - type_averages.avg_defense as defense_vs_type_avg,
    pokemon_stats_pivot.sp_attack - type_averages.avg_sp_attack as sp_attack_vs_type_avg,
    pokemon_stats_pivot.sp_defense - type_averages.avg_sp_defense as sp_defense_vs_type_avg,
    pokemon_stats_pivot.speed - type_averages.avg_speed as speed_vs_type_avg
from {{ ref('stg_pokemon') }} as pokemon
inner join pokemon_stats_pivot
    on pokemon.pokemon_id = pokemon_stats_pivot.pokemon_id
inner join pokemon_types
    on pokemon.pokemon_id = pokemon_types.pokemon_id
inner join type_averages
    on pokemon_types.primary_type = type_averages.primary_type
