SELECT *
FROM survey
LIMIT 10;

SELECT question, COUNT(*) AS response_count
FROM survey
GROUP BY 1;

WITH question_responses AS (
  SELECT question, COUNT(*) AS response_count
  FROM survey
  GROUP BY 1
),
question_skips AS (
  SELECT question, COUNT(response) AS skip_count
FROM survey
WHERE response="I'm not sure. Let's skip it." OR
response="No Preference" OR response="Not Sure. Let's Skip It"
GROUP BY 1
)
SELECT question_responses.question,
	question_responses.response_count,
  question_skips.skip_count
FROM question_responses
JOIN question_skips
	ON question_responses.question=question_skips.question;

SELECT *
FROM quiz
LIMIT 5;
SELECT *
FROM home_try_on
LIMIT 5;
SELECT *
FROM purchase
LIMIT 5;

WITH hto_counts AS (
SELECT number_of_pairs, COUNT(*) AS total_count
FROM home_try_on
GROUP BY 1),
p_counts AS (
SELECT home_try_on.number_of_pairs,
  COUNT(*) AS purchase_count
FROM home_try_on
JOIN purchase
	ON home_try_on.user_id=purchase.user_id
GROUP BY 1)
SELECT hto_counts.number_of_pairs,
		hto_counts.total_count,
  	p_counts.purchase_count
FROM hto_counts
JOIN p_counts
	ON hto_counts.number_of_pairs=p_counts.number_of_pairs;

SELECT quiz.user_id,
	CASE
  	WHEN quiz.user_id=home_try_on.user_id THEN 'True'
  	ELSE 'False'
  END AS is_home_try_on,
  home_try_on.number_of_pairs,
  CASE
  	WHEN quiz.user_id=purchase.user_id THEN 'True'
  	ELSE 'False'
  END AS is_purchase
FROM quiz
LEFT JOIN home_try_on
	ON quiz.user_id=home_try_on.user_id
LEFT JOIN purchase
  ON quiz.user_id=purchase.user_id
LIMIT 10;

WITH funnel AS (
SELECT quiz.user_id,
	CASE
  	WHEN quiz.user_id=home_try_on.user_id THEN 1
  	ELSE 0
  END AS is_home_try_on,
  home_try_on.number_of_pairs,
  CASE
  	WHEN quiz.user_id=purchase.user_id THEN 1
  	ELSE 0
  END AS is_purchase
FROM quiz
LEFT JOIN home_try_on
	ON quiz.user_id=home_try_on.user_id
LEFT JOIN purchase
  ON quiz.user_id=purchase.user_id)
SELECT SUM(is_home_try_on)*1.0/COUNT(user_id) AS quiz_try_on
FROM funnel;

WITH funnel AS (
SELECT quiz.user_id,
	CASE
  	WHEN quiz.user_id=home_try_on.user_id THEN 1
  	ELSE 0
  END AS is_home_try_on,
  home_try_on.number_of_pairs,
  CASE
  	WHEN quiz.user_id=purchase.user_id THEN 1
  	ELSE 0
  END AS is_purchase
FROM quiz
LEFT JOIN home_try_on
	ON quiz.user_id=home_try_on.user_id
LEFT JOIN purchase
  ON quiz.user_id=purchase.user_id)
SELECT SUM(is_purchase)*1.0/COUNT(user_id) AS quiz_try_on
FROM funnel;

SELECT style, COUNT(style) AS count
FROM quiz
GROUP BY 1
ORDER BY 2 DESC;
SELECT fit, COUNT(fit) AS count
FROM quiz
GROUP BY 1
ORDER BY 2 DESC;
SELECT shape, COUNT(shape) AS count
FROM quiz
GROUP BY 1
ORDER BY 2 DESC;
SELECT color, COUNT(color) AS count
FROM quiz
GROUP BY 1
ORDER BY 2 DESC;

SELECT style, model_name, color, COUNT(color) AS count
FROM purchase
GROUP BY 3
ORDER BY 4 DESC;
