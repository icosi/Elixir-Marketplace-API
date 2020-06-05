CREATE DATABASE marketplace;

USE marketplace;

CREATE TABLE products (
    product_id int NOT NULL AUTO_INCREMENT,
    name VARCHAR (36),
    category VARCHAR (36),
    description VARCHAR (36),
    price int,
    PRIMARY KEY (product_id)
);

CREATE TABLE users (
    user_id INT NOT NULL AUTO_INCREMENT,
    name VARCHAR (36),
    last_name VARCHAR (36),
    PRIMARY KEY (user_id)
);

CREATE TABLE carts (
    cart_id INT NOT NULL AUTO_INCREMENT,
    user_id INT NOT NULL,
    PRIMARY KEY (cart_id),
    FOREIGN KEY (user_id) REFERENCES users (user_id)
);

CREATE TABLE cart_product_relation (
    cart_id INT NOT NULL NOT NULL,
    product_id INT NOT NULL NOT NULL,
    FOREIGN KEY (cart_id) REFERENCES carts (cart_id),
    FOREIGN KEY (product_id) REFERENCES products (product_id)
);