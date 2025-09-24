# SleekMart Analytics Engine

<div align="center">

![dbt](https://img.shields.io/badge/dbt-FF694B?style=for-the-badge&logo=dbt&logoColor=white)
![Snowflake](https://img.shields.io/badge/Snowflake-29B5E8?style=for-the-badge&logo=snowflake&logoColor=white)

</div>

*SleekMart Analytics Engine is a dbt (data build tool) project that transforms raw order management system data into analytics-ready datasets. Built on Snowflake's cloud platform, it demonstrates enterprise-grade data modeling, automated testing, and scalable ELT (Extract, Load, Transform) patterns.*

![SleekMart Snowflake Warehouse](https://github.com/user-attachments/assets/ff4b8ea1-140a-4627-8438-fa885fe8a2c8)

## Architecture

### Data Flow

```
Raw Data Sources (L1_LANDING)
    ↓
Staging Models (L2_PROCESSING)
    ↓
Consumption Models (L3_CONSUMPTION)
    ↓
Business Intelligence & Reporting
```

### Snowflake Integration

The project leverages Snowflake's capabilities through:

- **Database**: `SLEEKMART_OMS`
- **Schemas**:
  - `L1_LANDING` - Raw source data ingestion layer
  - `L2_PROCESSING` - Staged and cleaned datasets
  - `L3_CONSUMPTION` - Business-ready consumption layer
  - `TRAINING` - Sandbox environment for development


## Core Models

Staging Layer (`L2_PROCESSING` schema)
  - **customers_stg** - Customer master data with name concatenation
  - **orders_stg** - Order header information with data quality constraints
  - **orderitems_stg** - Order line items with referential integrity
  - **employees_stg** - Employee master data for sales attribution

Fact Layer (`L2_PROCESSING` schema)
  - **orders_fact** - Aggregated order metrics

Consumption Layer (`L3_CONSUMPTION` schema)
  - **CUSTOMERORDER** - Customer order analytics
  - **CUSTOMERREVENUE** - Customer revenue metrics
  - **ORDERITEMS_UNIQ** - Unique order items view
  - **SALESTARGET** - Sales performance tracking

Development Layer (`TRAINING` schema)
  - **profit_us** - Development sandbox model


### Key Commands

```bash
# Basic workflow
dbt run                    # Run all models
dbt test                   # Run all tests
dbt run --models staging  # Run staging models only

# Development
dbt compile              # Check syntax
dbt run --full-refresh   # Rebuild all tables

# Documentation
dbt docs generate        # Generate documentation
dbt docs serve          # Serve docs locally

# Quality assurance
dbt source freshness     # Check data freshness
dbt snapshot            # Create SCD snapshots
```

