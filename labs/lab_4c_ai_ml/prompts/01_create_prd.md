# Prompt: Create PRD for AI/ML Features

Copy the prompt below into your AI coding assistant.

~~~
Act as a Senior Analytics Engineer. Create a Product Requirements Document (PRD) for AI/ML features on the Pokemon data platform.

Use skill: create-prd

FEATURE SCOPE

Add machine learning and generative AI capabilities using BigQuery ML (BQML) and Gemini, operating directly on the mart-layer data already in BigQuery.

FEATURE 1: BQML Classification Model

- Goal: Predict a Pokemon's primary type based on its base stats
- Model type: Logistic regression or boosted tree classifier (CREATE MODEL)
- Training data: fct_pokemon_stats mart (features: hp, attack, defense, sp_attack, sp_defense, speed; label: primary_type)
- Evaluation: Use ML.EVALUATE to measure accuracy, precision, recall
- Prediction: Use ML.PREDICT to classify Pokemon with unknown/new types
- Location: SQL files in transform/models/ml/ or standalone SQL scripts in ml/

FEATURE 2: Gemini Scouting Reports

- Goal: Generate natural-language competitive scouting reports from structured data
- Function: Use ML.GENERATE_TEXT with a Gemini model
- Input: Pokemon name, stats, types, top moves (from fct_competitive_moves)
- Output: A text paragraph analyzing the Pokemon's competitive strengths, weaknesses, and recommended role
- Location: SQL query or dbt model

TECHNICAL CONSTRAINTS

- All ML operations happen in BigQuery SQL — no external ML infrastructure
- BQML model should be created in the pokedex_marts dataset
- Gemini requires a remote model connection in BigQuery (may need instructor help to set up)
~~~
