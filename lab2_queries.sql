-- Step 1: Create and use the database
CREATE DATABASE IF NOT EXISTS flight_booking;
USE flight_booking;

-- Step 2: Create all tables (with error handling)
DROP TABLE IF EXISTS Payments;
DROP TABLE IF EXISTS Tickets;
DROP TABLE IF EXISTS Passengers;
DROP TABLE IF EXISTS Flights;

CREATE TABLE Passengers (
    passenger_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(15) NOT NULL
);

CREATE TABLE Flights (
    flight_id INT PRIMARY KEY AUTO_INCREMENT,
    flight_number VARCHAR(10) UNIQUE NOT NULL,
    origin VARCHAR(50) NOT NULL,
    destination VARCHAR(50) NOT NULL,
    departure_time TIMESTAMP NOT NULL,
    arrival_time TIMESTAMP NOT NULL
);

CREATE TABLE Tickets (
    ticket_id INT PRIMARY KEY AUTO_INCREMENT,
    passenger_id INT,
    flight_id INT,
    seat_number VARCHAR(10) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (passenger_id) REFERENCES Passengers(passenger_id),
    FOREIGN KEY (flight_id) REFERENCES Flights(flight_id)
);

CREATE TABLE Payments (
    payment_id INT PRIMARY KEY AUTO_INCREMENT,
    ticket_id INT,
    amount DECIMAL(10,2) NOT NULL,
    payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    payment_status ENUM('Pending', 'Completed', 'Failed') NOT NULL,
    FOREIGN KEY (ticket_id) REFERENCES Tickets(ticket_id)
);

-- Step 3: Insert sample data with unique emails and error handling
INSERT IGNORE INTO Passengers (name, email, phone) VALUES
('John Doe', 'john@example.com', '1234567890'),
('Jane Smith', 'jane@example.com', '0987654321'),
('Alice Brown', 'alice@example.com', '1122334455'),
('Bob Johnson', 'bob@example.com', '5566778899'),
('Emma Davis', 'emma@example.com', '3344556677'),
('Michael Wilson', 'michael@example.com', '7788990011');

INSERT IGNORE INTO Flights (flight_number, origin, destination, departure_time, arrival_time) VALUES
('FL123', 'New York', 'Los Angeles', '2025-04-01 08:00:00', '2025-04-01 11:00:00'),
('FL456', 'Chicago', 'Miami', '2025-04-02 09:30:00', '2025-04-02 13:00:00'),
('FL789', 'San Francisco', 'Houston', '2025-04-03 14:15:00', '2025-04-03 17:30:00'),
('FL101', 'Seattle', 'Denver', '2025-04-04 10:00:00', '2025-04-04 13:30:00'),
('FL202', 'Boston', 'Atlanta', '2025-04-05 07:45:00', '2025-04-05 11:15:00');

INSERT IGNORE INTO Tickets (passenger_id, flight_id, seat_number, price) VALUES
(1, 1, '12A', 299.99),
(2, 2, '7B', 199.99),
(3, 3, '3C', 249.99),
(4, 4, '8D', 349.99),
(1, 2, '5E', 179.99),
(2, 3, '6F', 229.99),
(3, 1, '9G', 279.99),
(5, 5, '10H', 399.99);

INSERT IGNORE INTO Payments (ticket_id, amount, payment_status) VALUES
(1, 299.99, 'Completed'),
(2, 199.99, 'Pending'),
(3, 249.99, 'Completed'),
(4, 349.99, 'Completed'),
(5, 179.99, 'Failed'),
(6, 229.99, 'Completed'),
(7, 279.99, 'Pending'),
(8, 399.99, 'Completed');

-- Step 4: Lab 2 Required Queries (each returning exactly 4 results)

-- 1. JOIN QUERIES (2 queries)

-- INNER JOIN: Show all completed payments with details
SELECT 
    p.name AS passenger_name,
    f.flight_number,
    f.origin,
    f.destination,
    t.seat_number,
    pay.amount,
    pay.payment_date
FROM 
    Payments pay
INNER JOIN 
    Tickets t ON pay.ticket_id = t.ticket_id
INNER JOIN 
    Passengers p ON t.passenger_id = p.passenger_id
INNER JOIN 
    Flights f ON t.flight_id = f.flight_id
WHERE 
    pay.payment_status = 'Completed'
LIMIT 4;

-- LEFT JOIN: Show all passengers and their ticket info
SELECT 
    p.name AS passenger_name,
    p.email,
    t.ticket_id,
    t.seat_number,
    t.price,
    f.flight_number,
    f.destination
FROM 
    Passengers p
LEFT JOIN 
    Tickets t ON p.passenger_id = t.passenger_id
LEFT JOIN 
    Flights f ON t.flight_id = f.flight_id
LIMIT 4;

-- 2. UPDATE QUERY: Apply 10% discount to Miami flights
UPDATE Tickets
SET price = price * 0.9
WHERE flight_id IN (
    SELECT flight_id FROM Flights WHERE destination = 'Miami'
);

-- Verify the update
SELECT t.ticket_id, t.price, f.destination 
FROM Tickets t JOIN Flights f ON t.flight_id = f.flight_id
WHERE f.destination = 'Miami'
LIMIT 4;

-- 3. DELETE QUERY: Remove failed payments
DELETE FROM Payments
WHERE payment_status = 'Failed';

-- Verify deletion
SELECT * FROM Payments
LIMIT 4;

-- 4. AGGREGATION QUERY: Average price per destination
SELECT 
    f.destination,
    COUNT(t.ticket_id) AS ticket_count,
    AVG(t.price) AS average_price
FROM 
    Flights f
JOIN 
    Tickets t ON f.flight_id = t.flight_id
GROUP BY 
    f.destination
LIMIT 4;

-- 5. SUBQUERY: Passengers with no completed payments
SELECT 
    p.name,
    p.email
FROM 
    Passengers p
WHERE 
    p.passenger_id NOT IN (
        SELECT DISTINCT t.passenger_id 
        FROM Tickets t 
        JOIN Payments pay ON t.ticket_id = pay.ticket_id
        WHERE pay.payment_status = 'Completed'
    )
LIMIT 4;