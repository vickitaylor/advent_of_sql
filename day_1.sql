
WITH wish AS(
  SELECT DISTINCT 
    child_id,
    json_extract_path_text(wishes, 'colors') AS colors,
    json_extract_path_text(wishes, 'first_choice') AS first_choice,
    json_extract_path_text(wishes, 'second_choice') AS second_choice
  FROM wish_lists
), 
wish2 AS (
  SELECT 
    child_id,
    colors,
    (colors::json->>0) AS fav_color,
    json_array_length(colors :: json) AS color_count,
    first_choice,
    second_choice
  FROM wish
)

SELECT 
  a.name,
  b.first_choice AS primary_wish, 
  b.second_choice AS backup_wish, 
  b.fav_color AS favorite_color,
  b.color_count, 
  CASE
    WHEN c.difficulty_to_make = 1 THEN 'Simple Gift'
    WHEN c.difficulty_to_make = 2 THEN 'Moderate Gift'
    WHEN c.difficulty_to_make >= 3 THEN 'Complex Gift'
  END AS gift_complexity,
  CASE
    WHEN c.category = 'outdoor' THEN 'Outside Workshop'
    WHEN c.category = 'educational' THEN 'Learning Workshop'
    ELSE 'General Workshop'
  END AS workshop_assignment
FROM children AS a
LEFT JOIN wish2 AS b
  ON a.child_id = b.child_id
LEFT JOIN toy_catalogue AS c
  ON b.first_choice = c.toy_name
ORDER BY 1
LIMIT 5
