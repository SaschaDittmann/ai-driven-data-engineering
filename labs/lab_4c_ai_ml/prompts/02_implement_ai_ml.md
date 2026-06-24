# Prompt: Implement BQML and Gemini Queries

Copy the prompt below into your AI coding assistant.

~~~
Use skill: implement-tasks

Read the AI/ML tasks in docs/tasks/ and implement BQML and Gemini features.

BQML CLASSIFICATION MODEL

Create SQL files for the following steps:

1. Training (ml/train_type_classifier.sql)

CREATE OR REPLACE MODEL <project>.<dataset>.pokemon_type_classifier
OPTIONS (
  model_type='LOGISTIC_REG',
  input_label_cols=['primary_type']
) AS
SELECT
  hp, attack, defense, sp_attack, sp_defense, speed,
  primary_type
FROM <project>.<dataset>.fct_pokemon_stats
WHERE primary_type IS NOT NULL;

2. Evaluation (ml/evaluate_model.sql)
- Use ML.EVALUATE to check accuracy, precision, recall
- Display a confusion matrix if possible

3. Prediction (ml/predict_types.sql)
- Use ML.PREDICT on a subset of Pokemon
- Show predicted type vs. actual type

GEMINI SCOUTING REPORTS

Create a SQL query (ml/scouting_report.sql) that uses ML.GENERATE_TEXT:

- Join fct_pokemon_stats with fct_competitive_moves to build a context prompt
- For each Pokemon, generate a prompt like:
  "Analyze this Pokemon for competitive play: [name], Type: [type], Stats: HP=[hp], ATK=[atk], DEF=[def], SpA=[spa], SpD=[spd], Spe=[spe]. Top moves: [move_list]. Provide a scouting report covering strengths, weaknesses, and recommended competitive role."
- Use ML.GENERATE_TEXT with the Gemini model to generate the report
- Return: pokemon_name, primary_type, bst, scouting_report

NOTES

- Replace <project> and <dataset> with actual values from the Terraform outputs or environment
- The Gemini remote model connection may need to be created first — check with the instructor
- These can be implemented as standalone SQL files or as dbt models in transform/models/ml/
~~~
