# Cortex AI Tutorial

This notebook demonstrates Snowflake Cortex AI functions — LLMs callable from SQL:

| Function | What it does |
|----------|-------------|
| AI_COMPLETE | Ask LLMs anything (product ideas, business insights) |
| AI_CLASSIFY | Auto-categorize text into labels |
| AI_SENTIMENT | Score text positive/negative |
| AI_EXTRACT | Pull structured fields from unstructured text |
| AI_TRANSLATE | Multi-language translation |
| AI_FILTER | Natural language WHERE clause |
| AI_REDACT | Mask PII automatically |

## Run in Snowflake

Open as a Snowflake Notebook in Snowsight.

## Key Examples

```sql
-- Sentiment analysis
SELECT AI_SENTIMENT('Amazing product! Best purchase ever.') AS score;

-- Classify countries into regions
SELECT AI_CLASSIFY(COUNTRY, ['North America', 'Europe', 'Asia']):label FROM customers;

-- Extract entities from text
SELECT AI_EXTRACT(message, ['customer_name', 'order_number', 'issue_type']) FROM tickets;

-- Natural language filter
SELECT * FROM products WHERE AI_FILTER(PROMPT('Is this fitness-related? {0}', PRODUCT_NAME));

-- Translate
SELECT AI_TRANSLATE('Hello world', 'en', 'es') AS spanish;
```

All functions run inside Snowflake — data never leaves your account.
