# Snowpark Tutorial

This notebook demonstrates Snowpark Python on Snowflake:

1. **DataFrames** — Query, filter, join, aggregate (like PySpark)
2. **Python UDF** — CUSTOMER_VALUE_SCORE (scores customers as PLATINUM/GOLD/SILVER/BRONZE)
3. **Stored Procedure** — DATA_QUALITY_CHECK (checks nulls, orphans, negative prices)

## Run in Snowflake

Open this as a Snowflake Notebook in Snowsight:
- Projects → Workspaces → Create Notebook
- Copy the cells from snowpark_tutorial.ipynb

## Key Concepts

```python
from snowflake.snowpark.context import get_active_session
session = get_active_session()

# DataFrame operations (runs on Snowflake compute)
df = session.table('SALES_DW.STAGING.STG_CUSTOMERS')
df.filter(F.col('SEGMENT') == 'PREMIUM').show()

# Create permanent UDF (callable from SQL)
@F.udf(name='CUSTOMER_VALUE_SCORE', is_permanent=True, ...)
def customer_value_score(total_spent, total_orders):
    ...

# Register stored procedure
session.sproc.register(func=data_quality_check, name='DATA_QUALITY_CHECK', ...)
```
