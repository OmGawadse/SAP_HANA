# Database Foundation

This folder contains the SQL source code used to establish the database foundation for the **SAP HANA Sales & Customer Analytics** project.
- In Schema creation (`MAIN_PROJECT`)

### Database Tables and Columns

| Table Name | Column Names |
|---|---|
| CUSTOMER | CUSTOMER_ID, NAME, CITY, EMAIL, PHN_NO, REG_DATE, REGION_ID |
| REGION | REGION_ID, REGION_NAME, COUNTRY |
| PRODUCT | PRODUCT_ID, PRODUCT_NAME, CATEGORY_ID, UNIT_PRICE, STOCK_QUANTITY |
| CATEGORY | CATEGORY_ID, CATEGORY_NAME, DESCRIPTION |
| SALES | SALES_ID, CUSTOMER_ID, PURCHASE_DATE, PAYMENT_METHOD, ORDER_STATUS |
| SALES_ITEMS | SALES_ITEM_ID, SALES_ID, PRODUCT_ID, QUANTITY, UNIT_PRICE, DISCOUNT_PERCENT |

The database was developed using SQL in SAP HANA Cloud and serves as the foundation for SQLScript development, calculation views and business analytics.
