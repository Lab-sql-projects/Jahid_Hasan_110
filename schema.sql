-- Drop the database if it already exists (use with caution as this will delete all data)
DROP DATABASE IF EXISTS flight_booking;

-- Create the database
CREATE DATABASE flight_booking;

-- Use the database
USE flight_booking;

-- Passengers table
CREATE TABLE Passengers (
    passenger_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(20),
    passport_number VARCHAR(50) UNIQUE
);

-- Flights table
CREATE TABLE Flights (
    flight_id INT AUTO_INCREMENT PRIMARY KEY,
    flight_number VARCHAR(20) NOT NULL,
    departure VARCHAR(100) NOT NULL,
    arrival VARCHAR(100) NOT NULL,
    date TIMESTAMP NOT NULL,
    capacity INT NOT NULL
);

-- Tickets table
CREATE TABLE Tickets (
    ticket_id INT AUTO_INCREMENT PRIMARY KEY,
    passenger_id INT,
    flight_id INT,
    seat VARCHAR(10) NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (passenger_id) REFERENCES Passengers(passenger_id),
    FOREIGN KEY (flight_id) REFERENCES Flights(flight_id)
);

-- Payments table
CREATE TABLE Payments (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    ticket_id INT,
    amount DECIMAL(10, 2) NOT NULL,
    payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status ENUM('Pending', 'Completed', 'Failed') NOT NULL,
    FOREIGN KEY (ticket_id) REFERENCES Tickets(ticket_id)
);

-- Optional: Add some sample data
INSERT INTO Passengers (name, email, phone, passport_number) VALUES 
('John Doe', 'john.doe@example.com', '1234567890', 'P12345678'),
('Jane Smith', 'jane.smith@example.com', '9876543210', 'P87654321');

INSERT INTO Flights (flight_number, departure, arrival, date, capacity) VALUES 
('FL100', 'New York', 'London', '2023-12-15 08:00:00', 200),
('FL200', 'London', 'Paris', '2023-12-16 10:30:00', 150);

INSERT INTO Tickets (passenger_id, flight_id, seat, price) VALUES 
(1, 1, '12A', 499.99),
(2, 2, '7B', 299.99);

INSERT INTO Payments (ticket_id, amount, status) VALUES 
(1, 499.99, 'Completed'),
(2, 299.99, 'Completed');