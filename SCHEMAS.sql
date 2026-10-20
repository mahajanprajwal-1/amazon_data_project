-- Amazon database schema 


CREATE TABLE customers (
    customer_id   INT PRIMARY KEY,
    f_name        VARCHAR(50)  NOT NULL,
    l_name        VARCHAR(50)  NOT NULL,
    state         VARCHAR(50),
    address       VARCHAR(200)
);

CREATE TABLE category (
    category_id   INT PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL
);

CREATE TABLE sellers (
    seller_id     INT PRIMARY KEY,
    seller_name   VARCHAR(100) NOT NULL,
    brand_type    VARCHAR(30)            

CREATE TABLE products (
    product_id    INT PRIMARY KEY,
    product_name  VARCHAR(150) NOT NULL,
    price         DECIMAL(12,2) NOT NULL,
    cogs          DECIMAL(12,2) NOT NULL,
    category_id   INT NOT NULL,
    seller_id     INT NOT NULL,
    FOREIGN KEY (category_id) REFERENCES category(category_id),
    FOREIGN KEY (seller_id)   REFERENCES sellers(seller_id)
);

CREATE TABLE inventory (
    inventory_id    INT PRIMARY KEY,
    product_id      INT NOT NULL,
    stock_remaining INT NOT NULL,
    ware_house_id   INT NOT NULL,
    restock_date    DATE,
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

CREATE TABLE orders (
    order_id      INT PRIMARY KEY,
    order_date    DATE NOT NULL,
    customer_id   INT NOT NULL,
    order_status  VARCHAR(20) NOT NULL,  
    product_id    INT NOT NULL,
    seller_id     INT NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (product_id)  REFERENCES products(product_id),
    FOREIGN KEY (seller_id)   REFERENCES sellers(seller_id)
);

CREATE TABLE order_items (
    order_item_id  INT PRIMARY KEY,
    order_id       INT NOT NULL,
    product_id     INT NOT NULL,
    quantity       INT NOT NULL,
    price_per_unit DECIMAL(12,2) NOT NULL,
    total_price    DECIMAL(14,2) NOT NULL,
    FOREIGN KEY (order_id)   REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

CREATE TABLE shipping (
    shipping_id     INT PRIMARY KEY,
    order_id        INT NOT NULL,
    delivery_status VARCHAR(20),        
    shipping_date   DATE,
    return_date     DATE,
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
);

CREATE TABLE payments (
    payment_id     INT PRIMARY KEY,
    payment_date   DATE NOT NULL,
    payment_mode   VARCHAR(30),
    payment_status VARCHAR(20),         
    order_id       INT NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
);

-- Helpful indexes for analysis queries
CREATE INDEX idx_orders_customer ON orders(customer_id);
CREATE INDEX idx_orders_date     ON orders(order_date);
CREATE INDEX idx_items_order     ON order_items(order_id);
CREATE INDEX idx_ship_order      ON shipping(order_id);
CREATE INDEX idx_pay_order       ON payments(order_id);

