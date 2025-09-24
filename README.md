# SleekMart Analytics Engine

<div align="center">

![dbt](https://img.shields.io/badge/dbt-FF694B?style=for-the-badge&logo=dbt&logoColor=white)
![Snowflake](https://img.shields.io/badge/Snowflake-29B5E8?style=for-the-badge&logo=snowflake&logoColor=white)


</div>



SleekMart Analytics Engine is a comprehensive dbt (data build tool) project that transforms raw order management system data into analytics-ready datasets. Built on Snowflake's cloud data platform, this project demonstrates enterprise-grade data modeling practices, automated testing, and scalable ELT (Extract, Load, Transform) patterns.

## Architecture

### Data Flow

```
Raw Data Sources (L1_LANDING)
    ↓
Staging Models (L2_PROCESSING)
    ↓
Fact Tables & Analytics Views
    ↓
Business Intelligence & Reporting
```

### Snowflake Integration

The project leverages Snowflake's capabilities through:

- **Database**: `SLEEKMART_OMS`
- **Schemas**:
  - `L1_LANDING` - Raw source data ingestion layer
  - `L2_PROCESSING` - Staged and cleaned datasets
  - `TRAINING` - Sandbox environment for development

- **Materialization Strategies**:
  - Views for staging models (fast, always fresh)
  - Tables for fact models (performance-optimized for analytics)
  - Transient tables disabled for cost optimization

## Project Structure

```
oms_dbt_proj/
├── models/                    # Data transformation logic
│   ├── staging/              # Clean, standardized source data
│   ├── marts/                # Business logic and fact tables
│   └── *.yml                 # Model documentation and tests
├── macros/                   # Reusable SQL functions
├── tests/                    # Custom data quality tests
├── seeds/                    # Reference data (CSV files)
├── snapshots/               # Type 2 SCD tracking
└── dbt_project.yml          # Project configuration
```

## Core Models

### Staging Layer (`L2_PROCESSING` schema)

**customers_stg** - Customer master data with name concatenation
```sql
-- Transforms raw customer data with computed full names
CONCAT(FIRSTNAME, ' ', LASTNAME) as CustomerName
```

**orders_stg** - Order header information with data quality constraints
- Primary key validation on OrderID
- Freshness monitoring (warn: 1 day, error: 3 days)

**orderitems_stg** - Order line items with referential integrity
- Foreign key relationship validation to orders_stg

**employees_stg** - Employee master data for sales attribution

### Fact Layer

**orders_fact** - Aggregated order metrics
- Revenue calculations by joining orders and order items
- Order count aggregations
- Materialized as table for query performance

**customerrevenue** - Customer-level revenue analysis
- Customer lifetime value calculations
- Order frequency metrics

## dbt Features Demonstrated

### 1. Sources and Freshness
```yaml
sources:
  - name: landing
    loaded_at_field: Updated_at
    config:
      freshness:
        warn_after: {count: 1, period: day}
        error_after: {count: 3, period: day}
```

### 2. Model References and Dependencies
```sql
FROM {{ ref('orders_stg') }} O
JOIN {{ ref('orderitems_stg') }} OI ON O.OrderID = OI.OrderID
```

### 3. Custom Macros
- `to_celsius()` - Temperature conversion utility
- `generate_profit_model()` - Dynamic profit calculation template

### 4. Advanced Testing with dbt-expectations
```yaml
tests:
  - dbt_expectations.expect_table_row_count_to_equal_other_table:
      compare_model: ref("orders_stg")
```

### 5. Schema Configuration
```yaml
models:
  oms_dbt_proj:
    customers_stg:
      +schema: L2_PROCESSING
    orders_fact:
      +materialized: table
```

## Data Quality Framework

### Built-in Tests
- **Uniqueness**: Primary key constraints on OrderID
- **Not Null**: Critical field validation
- **Relationships**: Foreign key integrity between tables
- **String Validation**: Email and address field quality

### Custom Tests
- `orders_fact_negative_revenue_check.sql` - Business logic validation
- `records_count_check.sql` - Data volume monitoring
- Source freshness monitoring with automated alerts

## Dependencies

```yaml
packages:
  - package: dbt-labs/dbt_utils
    version: 1.1.1
  - git: "https://github.com/calogica/dbt-expectations.git"
    revision: 0.10.4
```

## Getting Started

### Prerequisites
- dbt Core installed
- Snowflake account with appropriate permissions
- Access to SLEEKMART_OMS database

### Setup
1. Clone the repository
2. Configure your `profiles.yml` for Snowflake connection
3. Install dependencies:
   ```bash
   dbt deps
   ```
4. Test connection:
   ```bash
   dbt debug
   ```

### Execution

#### Basic Commands
```bash
# Install/update dependencies
dbt deps

# Compile models (check for syntax errors)
dbt compile

# Run all models
dbt run

# Run specific models
dbt run --models customers_stg+
dbt run --models tag:staging

# Run tests
dbt test

# Run specific tests
dbt test --models customers_stg
```

#### Source Management
```bash
# Test source freshness
dbt source freshness

# Snapshot source data (Type 2 SCD)
dbt snapshot

# Load seed files
dbt seed

# Refresh seed data
dbt seed --full-refresh
```

#### Development Workflow
```bash
# Clean build artifacts
dbt clean

# Full refresh (rebuild all tables)
dbt run --full-refresh

# Run in development target
dbt run --target dev

# Run with variable override
dbt run --vars '{start_date: 2024-01-01}'
```

#### Documentation & Analysis
```bash
# Generate documentation
dbt docs generate

# Serve documentation locally
dbt docs serve

# Show model lineage
dbt ls --models +orders_fact+

# Show compiled SQL
dbt show --models orders_fact
```

#### State-based Execution
```bash
# Run only changed models
dbt run --defer --state target/

# Test only changed models
dbt test --defer --state target/

# Run downstream of changed models
dbt run --select state:modified+
```

## Best Practices Implemented

1. **Modular Design**: Separate staging and mart layers
2. **Documentation**: Comprehensive model and column descriptions
3. **Testing**: Multi-layered data quality validation
4. **Version Control**: All transformations tracked in SQL
5. **Incremental Processing**: Optimized for large-scale data processing
6. **Schema Management**: Logical separation of data layers

## Performance Optimization

- Materialized tables for frequently-queried fact models
- Staging views for real-time data access
- Snowflake's columnar storage leveraged through proper data types
- Query optimization through strategic JOIN patterns

---

*This project showcases modern analytics engineering practices using dbt's transformation capabilities on Snowflake's cloud data platform.*