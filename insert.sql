INSERT INTO Passengers (name, email, phone) VALUES
('John Doe', 'john@example.com', '1234567890'),
('Jane Smith', 'jane@example.com', '0987654321'),
('Alice Brown', 'alice@example.com', '1122334455');

INSERT INTO Flights (flight_number, origin, destination, departure_time, arrival_time) VALUES
('FL123', 'New York', 'Los Angeles', '2025-04-01 08:00:00', '2025-04-01 11:00:00'),
('FL456', 'Chicago', 'Miami', '2025-04-02 09:30:00', '2025-04-02 13:00:00'),
('FL789', 'San Francisco', 'Houston', '2025-04-03 14:15:00', '2025-04-03 17:30:00');

INSERT INTO Tickets (passenger_id, flight_id, seat_number, price) VALUES
(1, 1, '12A', 299.99),
(2, 2, '7B', 199.99),
(3, 3, '3C', 249.99);

INSERT INTO Payments (ticket_id, amount, payment_status) VALUES
(1, 299.99, 'Completed'),
(2, 199.99, 'Pending'),
(3, 249.99, 'Completed');