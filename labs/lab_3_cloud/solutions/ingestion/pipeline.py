import os
import time
import logging
import requests
import dlt

# Configure logging
logging.basicConfig(level=logging.INFO, format="%(asctime)s - %(levelname)s - %(message)s")
logger = logging.getLogger("pokemon_pipeline")

def fetch_data(url: str, max_retries: int = 5, backoff_factor: float = 2.0) -> dict:
    """Fetches data from PokeAPI with retry logic on 429 using exponential backoff."""
    retries = 0
    while True:
        try:
            response = requests.get(url, timeout=10)
            if response.status_code == 429:
                retries += 1
                if retries > max_retries:
                    logger.error(f"Max retries ({max_retries}) exceeded for URL: {url} on HTTP 429.")
                    response.raise_for_status()
                sleep_time = backoff_factor ** retries
                logger.warning(f"HTTP 429 (Too Many Requests). Retrying in {sleep_time}s...")
                time.sleep(sleep_time)
                continue
            response.raise_for_status()
            return response.json()
        except requests.exceptions.RequestException as e:
            if retries >= max_retries:
                logger.error(f"Request failed: {e}")
                raise
            retries += 1
            sleep_time = backoff_factor ** retries
            logger.warning(f"Request failed: {e}. Retrying in {sleep_time}s...")
            time.sleep(sleep_time)

def fetch_paginated_list(url: str, limit: int = 0) -> list:
    """Fetches items from a paginated API endpoint up to the specified limit (0 for unlimited)."""
    items = []
    current_url = url
    while current_url:
        data = fetch_data(current_url)
        results = data.get("results", [])
        for item in results:
            items.append(item)
            if limit > 0 and len(items) >= limit:
                return items
        current_url = data.get("next")
    return items

@dlt.resource(name="types", write_disposition="merge", primary_key="id")
def fetch_types():
    logger.info("Fetching Pokemon types...")
    list_url = "https://pokeapi.co/api/v2/type/?limit=100"
    types_list = fetch_paginated_list(list_url)
    for type_meta in types_list:
        detail = fetch_data(type_meta["url"])
        yield detail

@dlt.resource(name="abilities", write_disposition="merge", primary_key="id")
def fetch_abilities():
    logger.info("Fetching Pokemon abilities...")
    list_url = "https://pokeapi.co/api/v2/ability/?limit=100"
    abilities_list = fetch_paginated_list(list_url)
    for ability_meta in abilities_list:
        detail = fetch_data(ability_meta["url"])
        yield detail

@dlt.resource(name="moves", write_disposition="merge", primary_key="id")
def fetch_moves():
    logger.info("Fetching Pokemon moves...")
    list_url = "https://pokeapi.co/api/v2/move/?limit=100"
    moves_list = fetch_paginated_list(list_url)
    for move_meta in moves_list:
        detail = fetch_data(move_meta["url"])
        yield detail

@dlt.resource(name="stats", write_disposition="merge", primary_key="id")
def fetch_stats():
    logger.info("Fetching Pokemon stats catalog...")
    list_url = "https://pokeapi.co/api/v2/stat/?limit=100"
    stats_list = fetch_paginated_list(list_url)
    for stat_meta in stats_list:
        detail = fetch_data(stat_meta["url"])
        yield detail

@dlt.resource(name="pokemon", write_disposition="merge", primary_key="id")
def fetch_pokemon(pokemon_limit: int = 151):
    logger.info(f"Fetching Pokemon details (limit: {pokemon_limit})...")
    list_url = "https://pokeapi.co/api/v2/pokemon/?limit=100"
    pokemon_list = fetch_paginated_list(list_url, limit=pokemon_limit)
    for pkmn_meta in pokemon_list:
        detail = fetch_data(pkmn_meta["url"])
        yield detail

@dlt.source
def pokemon_source(pokemon_limit: int = 151):
    return [
        fetch_types(),
        fetch_abilities(),
        fetch_moves(),
        fetch_stats(),
        fetch_pokemon(pokemon_limit=pokemon_limit)
    ]

def get_pokemon_limit() -> int:
    limit_env = os.environ.get("POKEMON_LIMIT")
    if limit_env is not None:
        try:
            val = int(limit_env)
            return val if val >= 0 else 0
        except ValueError:
            logger.warning(f"Invalid POKEMON_LIMIT environment variable value '{limit_env}'. Defaulting to 151.")
            return 151
    return 151  # Default fallback if unset

def run_pipeline(db_path: str = "data/pokedex.db", pokemon_limit: int = 151):
    dest = os.environ.get("PIPELINE_DESTINATION", "duckdb").lower()
    logger.info(f"Starting PokeAPI ingestion pipeline. Limit: {pokemon_limit}, Destination: {dest}")
    
    source = pokemon_source(pokemon_limit=pokemon_limit)
    
    if dest == "bigquery":
        # Configure BigQuery destination with GCS staging
        bucket_url = os.environ.get("GCS_BUCKET_URL") or os.environ.get("DESTINATION__FILESYSTEM__BUCKET_URL")
        if not bucket_url:
            raise ValueError(
                "Either GCS_BUCKET_URL or DESTINATION__FILESYSTEM__BUCKET_URL environment variable must be set "
                "when PIPELINE_DESTINATION is set to 'bigquery'"
            )
        
        # Set the bucket URL environment variable expected by dlt's filesystem staging
        if "DESTINATION__FILESYSTEM__BUCKET_URL" not in os.environ:
            os.environ["DESTINATION__FILESYSTEM__BUCKET_URL"] = bucket_url
            
        pipeline = dlt.pipeline(
            pipeline_name="pokemon_analytics",
            destination="bigquery",
            staging="filesystem",
            dataset_name="pokedex_raw"
        )
        # Using Application Default Credentials automatically (no custom credentials argument needed)
        info = pipeline.run(source)
    else:
        # Default local DuckDB destination
        db_dir = os.path.dirname(db_path)
        if db_dir and not os.path.exists(db_dir):
            os.makedirs(db_dir, exist_ok=True)
            
        pipeline = dlt.pipeline(
            pipeline_name="pokemon_analytics",
            destination="duckdb",
            dataset_name="raw"
        )
        info = pipeline.run(source, credentials=f"duckdb:///{db_path}")
        
    logger.info(f"Pipeline completed successfully. Loading report:\n{info}")
    return info

if __name__ == "__main__":
    limit = get_pokemon_limit()
    run_pipeline(pokemon_limit=limit)

