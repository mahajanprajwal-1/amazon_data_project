# Amazon E-Commerce Relational Database (Synthetic Dataset)

A synthetic, Amazon-style e-commerce database with **126,620 rows across 9 related tables**, built for SQL practice, data analysis, dashboards, and portfolio projects. The data is generated to behave like real order data: seasonal demand, repeat customers, popular products, returns, cancellations, and varied payment modes.

> **Note:** All data is synthetic. Names, addresses, and sellers are generated and do not represent real people or businesses.

## Schema

| Table | Rows | Description |
|---|---|---|
| `customers` | 750 | Customer name, state, address |
| `category` | 10 | Product categories |
| `sellers` | 60 | Seller name and brand type |
| `products` | 600 | Price, cost of goods sold (cogs), category, seller |
| `inventory` | 1,200 | Stock remaining, warehouse, restock date |
| `orders` | 31,000 | Order date, status, customer, product, seller |
| `order_items` | 31,000 | Quantity, price per unit, total price |
| `shipping` | 31,000 | Delivery status, shipping and return dates |
| `payments` | 31,000 | Payment date, mode, and status |

### Relationships

```
category ──< products >── sellers
                 │
                 ├──< inventory
                 │
customers ──< orders >── products / sellers
                 │
                 ├──< order_items
                 ├──< shipping
                 └──< payments
```

## Data Characteristics

- **Time range:** Jan 2024 to Oct 2026, with growth over time and festive-season peaks (Oct–Nov)
- **Skewed activity:** a small share of customers and products drive most orders
- **Order statuses:** Pending, Processing, Shipped, Delivered, Cancelled, Returned
- **Payment modes:** UPI, Credit Card, Debit Card, Net Banking, Cash on Delivery, Wallet
- **Consistent states:** shipping and payment values follow the order status (e.g. returned orders have a return date and a refunded payment)
- **Referential integrity:** every foreign key points to an existing row

## Repository Contents

```
├── schema.sql            # CREATE TABLE statements with PKs, FKs, indexes
├── data/                 # CSV files (one per table)
│   ├── customers.csv
│   ├── category.csv
│   ├── sellers.csv
│   ├── products.csv
│   ├── inventory.csv
│   ├── orders.csv
│   ├── order_items.csv
│   ├── shipping.csv
│   └── payments.csv
└── amazon_database.xlsx  # All tables as sheets in one workbook
```

## Getting Started

1. Create the tables:
   ```sql
   \i schema.sql
   ```
2. Load the CSVs **parents first** so foreign keys are satisfied:
   `category → sellers → customers → products → inventory → orders → order_items → shipping → payments`

   PostgreSQL:
   ```sql
   \copy customers FROM 'data/customers.csv' CSV HEADER
   ```
   MySQL:
   ```sql
   LOAD DATA LOCAL INFILE 'data/customers.csv' INTO TABLE customers
   FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' IGNORE 1 LINES;
   ```

## Example Queries

```sql
-- Monthly revenue
SELECT DATE_TRUNC('month', o.order_date) AS month, SUM(oi.total_price) AS revenue
FROM orders o JOIN order_items oi ON oi.order_id = o.order_id
WHERE o.order_status = 'Delivered'
GROUP BY 1 ORDER BY 1;

-- Top 10 customers by spend
SELECT c.customer_id, c.f_name, c.l_name, SUM(oi.total_price) AS total_spent
FROM customers c
JOIN orders o ON o.customer_id = c.customer_id
JOIN order_items oi ON oi.order_id = o.order_id
GROUP BY c.customer_id, c.f_name, c.l_name
ORDER BY total_spent DESC LIMIT 10;

-- Profit by category
SELECT cat.category_name, SUM(oi.quantity * (p.price - p.cogs)) AS profit
FROM order_items oi
JOIN products p ON p.product_id = oi.product_id
JOIN category cat ON cat.category_id = p.category_id
GROUP BY cat.category_name ORDER BY profit DESC;
```

## Suggested Use Cases

- SQL joins, aggregations, window functions, and CTE practice
- Power BI / Tableau / Excel dashboards (sales, returns, inventory, seller performance)
- Python (pandas) EDA and forecasting projects
- Data modeling and ER-diagram exercises

## License

Free to use for learning and portfolio work.
