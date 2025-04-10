-- view_creation.sql
USE flight_booking;

-- First drop the view if it already exists to avoid errors
DROP VIEW IF EXISTS passenger_public_info;

-- Create the view with public passenger information (excluding sensitive data)
CREATE VIEW passenger_public_info AS
SELECT 
    passenger_id,
    name,
    phone,
    -- Mask part of the phone number for privacy
    CONCAT(
        SUBSTRING(phone, 1, 3),
        '****',
        SUBSTRING(phone, -4)
    ) AS masked_phone
FROM Passengers;

-- Create a second view for flight information
DROP VIEW IF EXISTS flight_schedule;

CREATE VIEW flight_schedule AS
SELECT 
    flight_id,
    flight_number,
    CONCAT(departure, ' → ', arrival) AS route,
    DATE_FORMAT(date, '%Y-%m-%d %H:%i') AS departure_time,
    capacity,
    capacity - (SELECT COUNT(*) FROM Tickets WHERE Tickets.flight_id = Flights.flight_id) AS seats_available
FROM Flights;

-- Create a third view combining passenger and flight info
DROP VIEW IF EXISTS passenger_itinerary;

CREATE VIEW passenger_itinerary AS
SELECT 
    p.passenger_id,
    p.name,
    t.ticket_id,
    f.flight_number,
    f.departure AS from_city,
    f.arrival AS to_city,
    DATE_FORMAT(f.date, '%a, %b %d %Y at %l:%i %p') AS formatted_departure,
    t.seat,
    CONCAT('$', FORMAT(t.price, 2)) AS ticket_price,
    py.status AS payment_status
FROM 
    Passengers p
JOIN 
    Tickets t ON p.passenger_id = t.passenger_id
JOIN 
    Flights f ON t.flight_id = f.flight_id
LEFT JOIN 
    Payments py ON t.ticket_id = py.ticket_id;

-- Test all views
SELECT 'Passenger Public Info View:' AS view_test;
SELECT * FROM passenger_public_info LIMIT 5;

SELECT '\nFlight Schedule View:' AS view_test;
SELECT * FROM flight_schedule LIMIT 5;

SELECT '\nPassenger Itinerary View:' AS view_test;
SELECT * FROM passenger_itinerary LIMIT 5;