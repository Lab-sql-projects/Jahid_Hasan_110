-- Retrieve all passengers
SELECT * FROM Passengers;

-- Retrieve all flights sorted by departure time
SELECT * FROM Flights ORDER BY departure_time;

-- Retrieve all tickets for a specific passenger
SELECT * FROM Tickets WHERE passenger_id = 1;

-- Retrieve completed payments
SELECT * FROM Payments WHERE payment_status = 'Completed';

-- Retrieve flight details for a specific ticket
SELECT Flights.* FROM Flights
JOIN Tickets ON Flights.flight_id = Tickets.flight_id
WHERE Tickets.ticket_id = 1;
