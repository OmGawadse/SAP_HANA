# SAP HANA Sales & Customer Analytics

## Project Overview

An end-to-end database-driven analytics project developed using SAP HANA Cloud, SQL, SQLScript and SAP Business Application Studio (BAS).

The project focuses on transforming raw sales, customer and product data into meaningful business insights through relational database design, reusable business logic and graphical calculation views.

## Project Objectives

- Design and develop a structured relational database.
- Generate and import realistic business datasets using Python.
- Maintain data accuracy, consistency and referential integrity.
- Perform sales, customer and product analytics using SQL.
- Implement reusable business logic using SQLScript.
- Develop graphical calculation views for multidimensional analytics.
- Perform end-to-end testing and validation.

## Technologies & Tools

| Technology | Purpose |
|---|---|
| SAP HANA Cloud | Database management and analytics |
| SQL | Data retrieval, manipulation and analysis |
| SQLScript | Functions, procedures and business logic |
| Python | Realistic dataset generation |
| SAP Business Application Studio | Calculation view development |
| SAP HANA Database Explorer | Query execution and database management |
| HDI Container | Database artifact deployment |
| Git & GitHub | Version control and project documentation |

## Database Architecture

The project uses a relational database schema named **MAIN_PROJECT**, consisting of six interconnected column-store tables.

| Table | Records |
|---|---:|
| CUSTOMER | 500 |
| PRODUCT | 100 |
| SALES | 5,000 |
| SALES_ITEMS | 8,495 |
| REGION | 5 |
| CATEGORY | 5 |
| **Total** | **14,105** |

Primary keys, foreign keys and database constraints are implemented to maintain data integrity.

## Project Implementation

### 1. Dataset Generation

Realistic customer, product, sales and sales item datasets were generated using Python and imported into SAP HANA Cloud.

### 2. Database Development

Created the relational database schema, column-store tables, primary keys, foreign keys and necessary constraints.

### 3. Data Validation & Verification

Performed validation checks to ensure data accuracy, valid relationships and consistency across database tables.

### 4. Sales Analytics & Business Insights

Developed SQL queries for:

- Total discounted sales revenue
- Monthly and yearly sales analysis
- City-wise and region-wise revenue analysis
- Category-wise sales analysis
- Top 10 customers by revenue
- Top-selling products
- Average order value
- Revenue consistency verification

### 5. Advanced SQLScript & Business Analytics

Developed reusable functions and stored procedures to implement business logic.

| Object Name | Object Type |
|---|---|
| CALCULATE_NET_PRICE | Scalar Function |
| GET_CUSTOMER_SALES | Table Function |
| GET_YEARLY_REVENUE | Stored Procedure |
| GET_CUSTOMER_PURCHASE_HISTORY | Stored Procedure |
| GET_PRODUCT_PERFORMANCE_BY_CATEGORY | Stored Procedure |
| CLASSIFY_CUSTOMER_SPENDING | Stored Procedure |

Implemented input parameters, local variables, conditional logic and Common Table Expressions (CTEs).

### 6. HDI Container Integration

Established connectivity between the MAIN_PROJECT schema and the HDI container using database synonyms and appropriate database privileges.

Created six synonyms to access existing source tables without duplicating data.

### 7. Graphical Calculation Views

Developed and deployed five graphical calculation views using SAP Business Application Studio.

| Calculation View | Business Purpose |
|---|---|
| CV_SALES_REVENUE | Sales quantity and discounted revenue analysis |
| CV_PRODUCT_CATEGORY_ANALYTICS | Product category performance analysis |
| CV_CUSTOMER_REGION_ANALYTICS | Customer and regional performance analysis |
| CV_TIME_BASED_ANALYTICS | Time-based sales and revenue analysis |
| CV_PAYMENT_ORDER_ANALYTICS | Payment method and order status analysis |

### 8. Testing & Validation

Performed end-to-end testing to ensure the accuracy and consistency of database operations and analytical results.

- Database integrity testing
- SQLScript function and procedure testing
- Calculation view validation
- Source-to-calculation-view consistency checks
- Business KPI verification
- SQL execution plan generation

## Key Business Insights

| Business Metric | Result |
|---|---:|
| Total Customers | 500 |
| Total Products | 100 |
| Total Sales Orders | 5,000 |
| Total Sales Items | 8,495 |
| Total Recorded Quantity | 14,098 |
| Total Discounted Sales Value | ₹3.50 Crore (Approx.) |

The discounted sales value includes all recorded order statuses.

## Key Skills Demonstrated

- Relational Database Design
- SAP HANA Column-Store Tables
- Advanced SQL and SQLScript
- Data Generation and Validation
- Stored Procedures and User-Defined Functions
- Graphical Calculation Views
- Data Modeling
- HDI Container Integration
- Database Privileges and Synonyms
- Business Analytics and Reporting
- Technical Documentation

## Future Enhancements

- Power BI dashboard integration
- Interactive business reporting
- Advanced customer segmentation
- Sales forecasting
- Query performance analysis and optimization

## Project Outcome

Successfully developed an end-to-end SAP HANA analytics solution that integrates database development, data validation, reusable business logic and multidimensional data modeling to generate meaningful business insights.

## Author:
**Om Gawadse**
