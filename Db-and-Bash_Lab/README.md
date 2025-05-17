# AWS RDS MySQL Project

This project demonstrates how to use **AWS RDS** to create a MySQL database and build a simple API with **FastAPI** to query and interact with the data.

## 📦 Project Description

This exercise involves creating a simple MySQL database hosted on **AWS RDS** and interacting with it via a FastAPI backend. The application exposes various endpoints to fetch and analyze data from the database.

---

## 🚀 API Endpoints

The following endpoints are available in the FastAPI application:

| Endpoint                  | Description                                                   |
| ------------------------- | ------------------------------------------------------------- |
| `/top-customers`          | Returns the top customers based on order frequency or amount. |
| `/monthly-sales`          | Provides the sales data aggregated by month.                  |
| `/products-never-ordered` | Lists all products that have never been ordered.              |
| `/avg-order-country`      | Returns the average order value grouped by customer country.  |
| `/frequent-buyers`        | Shows customers who frequently place orders.                  |

You can test and interact with the API using the built-in Swagger UI available at:

🔗 [http://34.241.173.68:8000/docs](http://34.241.173.68:8000/docs)

---

## 🛠️ Setup Instructions

To get this project running locally:

1. **Clone the repository**:
   ```bash
   git clone https://github.com/Makuo67/Db-and-Bash_Lab.git
   cd Db-and-Bash_Lab
   ```

## Setup

3. Install FastAPI: `pip install -r requirements.txt`
4. Change directory: `cd api`
5. Run: `uvicorn db_api:app --reload`
6. Visit docs: `http://34.241.173.68:8000/docs`

## Screenshots

See `/screenshots` folder for proof of query execution.

## 🧰 Technologies Used

- AWS RDS – For hosting the MySQL database

- MySQL – Relational database system

- FastAPI – High-performance Python web framework

- Uvicorn – ASGI server for running FastAPI apps

- Python 3.8+
