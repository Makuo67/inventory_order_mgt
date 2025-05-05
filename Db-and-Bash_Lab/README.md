# AWS RDS MySQL Project

## SQL Scripts

- `create_tables.sql`: Drops and creates schema
- `insert_data.sql`: Populates data
- `queries.sql`: Contains all required queries

## API

- Built with FastAPI
- Endpoints:
  - `/top-customers`
  - `/monthly-sales`
  - `/products-never-ordered`
  - `/avg-order-country`
  - `/frequent-buyers`

## Setup

1. Launch AWS RDS MySQL instance
2. Run SQL scripts
3. Install FastAPI: `pip install -r requirements.txt`
4. Run: `uvicorn main:app --reload`
5. Visit docs: `http://127.0.0.1:8000/docs`

## Screenshots

See `/screenshots` folder for proof of query execution.
