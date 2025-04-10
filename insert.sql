-- insert_new_data.sql
USE flight_booking;

-- Clear all existing data
SET FOREIGN_KEY_CHECKS = 0;

TRUNCATE TABLE Payments;
TRUNCATE TABLE Tickets;
TRUNCATE TABLE Passengers;
TRUNCATE TABLE Flights;

SET FOREIGN_KEY_CHECKS = 1;

-- Reset auto-increment counters
ALTER TABLE Payments AUTO_INCREMENT = 1001;
ALTER TABLE Tickets AUTO_INCREMENT = 101;
ALTER TABLE Passengers AUTO_INCREMENT = 11;
ALTER TABLE Flights AUTO_INCREMENT = 21;

-- Insert new passengers with different attributes
INSERT INTO Passengers (name, email, phone, passport_number) VALUES
('Olivia Martinez', 'olivia.m@travelmail.com', '+442071838000', 'UKP7654321'),
('James Wilson', 'james.w@businessmail.com', '+13125551234', 'USP1234987'),
('Sophia Chen', 'schen@university.edu', '+8613812345678', 'CNP9876543'),
('Liam Johnson', 'liam.j@fastmail.net', '+61412345678', 'AUSP4567890'),
('Emma Kim', 'emma.k@koreamail.co.kr', '+82212345678', 'KREP3216549');

-- Insert new flights with different routes
INSERT INTO Flights (flight_number, departure, arrival, date, capacity) VALUES
('GA701', 'Jakarta', 'Singapore', '2024-02-15 09:30:00', 180),
('SQ402', 'Sydney', 'Auckland', '2024-02-16 11:45:00', 220),
('JL605', 'Tokyo', 'Seoul', '2024-02-17 14:20:00', 160),
('EK903', 'Dubai', 'Cairo', '2024-02-18 08:15:00', 200),
('LH304', 'Frankfurt', 'Vienna', '2024-02-19 16:30:00', 150);

-- Insert new ticket assignments
INSERT INTO Tickets (passenger_id, flight_id, seat, price) VALUES
(11, 21, '12A', 425.50),
(12, 22, '08B', 680.00),
(13, 23, '03C', 550.75),
(14, 24, '15D', 720.25),
(15, 25, '09F', 380.50),
(11, 23, '05E', 575.00),  -- Olivia also flying Tokyo to Seoul
(13, 25, '11A', 395.00); -- Sophia also flying Frankfurt to Vienna

-- Insert new payment records
INSERT INTO Payments (ticket_id, amount, status) VALUES
(101, 425.50, 'Completed'),
(102, 680.00, 'Completed'),
(103, 550.75, 'Pending'),
(104, 720.25, 'Completed'),
(105, 380.50, 'Failed'),
(106, 575.00, 'Pending'),
(107, 395.00, 'Completed');

-- New verification query with additional details
SELECT 
    p.passenger_id AS PID,
    p.name AS Passenger,
    f.flight_number,
    CONCAT(f.departure, ' → ', f.arrival) AS Route,
    DATE_FORMAT(f.date, '%b %d, %Y %h:%i %p') AS Departure,
    t.seat,
    CONCAT('$', FORMAT(t.price, 2)) AS Price,
    CASE 
        WHEN py.status = 'Completed' THEN '✅ Paid'
        WHEN py.status = 'Pending' THEN '⏳ Processing'
        ELSE '❌ Failed'
    END AS Status
FROM 
    Passengers p
JOIN 
    Tickets t ON p.passenger_id = t.passenger_id
JOIN 
    Flights f ON t.flight_id = f.flight_id
JOIN 
    Payments py ON t.ticket_id = py.ticket_id
ORDER BY 
    f.date, p.name;