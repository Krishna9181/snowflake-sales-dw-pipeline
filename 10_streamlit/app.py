import streamlit as st
from snowflake.snowpark.context import get_active_session

session = get_active_session()

st.set_page_config(page_title="Sales Analytics", layout="wide")
st.title("Sales Analytics Dashboard")

col1, col2, col3, col4 = st.columns(4)

metrics = session.sql("""
    SELECT
        COUNT(DISTINCT CUSTOMER_ID) AS CUSTOMERS,
        COUNT(DISTINCT ORDER_ID) AS ORDERS,
        ROUND(SUM(TOTAL_AMOUNT), 2) AS REVENUE,
        ROUND(AVG(TOTAL_AMOUNT), 2) AS AVG_ORDER
    FROM SALES_DW.STAGING.STG_ORDERS
""").to_pandas()

col1.metric("Customers", f"{metrics['CUSTOMERS'][0]}")
col2.metric("Orders", f"{metrics['ORDERS'][0]}")
col3.metric("Revenue", f"${metrics['REVENUE'][0]:,.2f}")
col4.metric("Avg Order", f"${metrics['AVG_ORDER'][0]:,.2f}")

st.divider()

left, right = st.columns(2)

with left:
    st.subheader("Revenue by Segment")
    segment_data = session.sql("""
        SELECT c.SEGMENT, ROUND(SUM(o.TOTAL_AMOUNT), 2) AS REVENUE
        FROM SALES_DW.STAGING.STG_CUSTOMERS c
        JOIN SALES_DW.STAGING.STG_ORDERS o ON c.CUSTOMER_ID = o.CUSTOMER_ID
        GROUP BY c.SEGMENT ORDER BY REVENUE DESC
    """).to_pandas()
    st.bar_chart(segment_data.set_index("SEGMENT"))

with right:
    st.subheader("Top 10 Products by Revenue")
    product_data = session.sql("""
        SELECT p.PRODUCT_NAME, ROUND(SUM(oi.LINE_TOTAL), 2) AS REVENUE
        FROM SALES_DW.STAGING.STG_ORDER_ITEMS oi
        JOIN SALES_DW.STAGING.STG_PRODUCTS p ON oi.PRODUCT_ID = p.PRODUCT_ID
        GROUP BY p.PRODUCT_NAME ORDER BY REVENUE DESC LIMIT 10
    """).to_pandas()
    st.bar_chart(product_data.set_index("PRODUCT_NAME"))

st.divider()

left2, right2 = st.columns(2)

with left2:
    st.subheader("Orders by Status")
    status_data = session.sql("""
        SELECT STATUS, COUNT(*) AS ORDER_COUNT
        FROM SALES_DW.STAGING.STG_ORDERS
        GROUP BY STATUS ORDER BY ORDER_COUNT DESC
    """).to_pandas()
    st.dataframe(status_data, use_container_width=True)

with right2:
    st.subheader("Revenue by Country")
    country_data = session.sql("""
        SELECT c.COUNTRY, ROUND(SUM(o.TOTAL_AMOUNT), 2) AS REVENUE,
               COUNT(DISTINCT o.ORDER_ID) AS ORDERS
        FROM SALES_DW.STAGING.STG_CUSTOMERS c
        JOIN SALES_DW.STAGING.STG_ORDERS o ON c.CUSTOMER_ID = o.CUSTOMER_ID
        GROUP BY c.COUNTRY ORDER BY REVENUE DESC
    """).to_pandas()
    st.dataframe(country_data, use_container_width=True)

st.divider()
st.subheader("Order Details")

status_filter = st.selectbox("Filter by Status", ["ALL", "COMPLETED", "SHIPPED", "PENDING"])

query = """
    SELECT o.ORDER_ID, c.CUSTOMER_NAME, c.SEGMENT, c.COUNTRY,
           o.ORDER_DATE, o.STATUS, o.TOTAL_AMOUNT
    FROM SALES_DW.STAGING.STG_ORDERS o
    JOIN SALES_DW.STAGING.STG_CUSTOMERS c ON o.CUSTOMER_ID = c.CUSTOMER_ID
"""
if status_filter != "ALL":
    query += f" WHERE o.STATUS = '{status_filter}'"
query += " ORDER BY o.ORDER_DATE DESC"

orders = session.sql(query).to_pandas()
st.dataframe(orders, use_container_width=True)
