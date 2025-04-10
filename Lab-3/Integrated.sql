-- constraints.sql
USE flight_booking;

-- 1. Drop constraints using version-appropriate syntax
-- For MySQL 8.0.19+ (commented out as fallback)
-- ALTER TABLE Tickets DROP CONSTRAINT IF EXISTS chk_price;
-- ALTER TABLE Flights DROP CONSTRAINT IF EXISTS uniq_flight_number;

-- For all MySQL versions (including older ones)
SET @dbname = DATABASE();
SET @tablename = 'Tickets';
SET @constraintname = 'chk_price';
SET @preparedstmt = (SELECT IF(
  EXISTS(
    SELECT 1 FROM information_schema.table_constraints
    WHERE constraint_schema = @dbname
    AND table_name = @tablename
    AND constraint_name = @constraintname
  ),
  CONCAT('ALTER TABLE ', @tablename, ' DROP CONSTRAINT ', @constraintname),
  'SELECT 1'
));
PREPARE stmt FROM @preparedstmt;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Repeat for flight number constraint
SET @tablename = 'Flights';
SET @constraintname = 'uniq_flight_number';
SET @preparedstmt = (SELECT IF(
  EXISTS(
    SELECT 1 FROM information_schema.table_constraints
    WHERE constraint_schema = @dbname
    AND table_name = @tablename
    AND constraint_name = @constraintname
  ),
  CONCAT('ALTER TABLE ', @tablename, ' DROP CONSTRAINT ', @constraintname),
  'SELECT 1'
));
PREPARE stmt FROM @preparedstmt;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- 2. Add NOT NULL constraint to passenger name
ALTER TABLE Passengers 
MODIFY name VARCHAR(100) NOT NULL;

-- 3. Add CHECK constraint for positive ticket prices
ALTER TABLE Tickets
ADD CONSTRAINT chk_price CHECK (price > 0);

-- 4. Add UNIQUE constraint to flight numbers
ALTER TABLE Flights
ADD CONSTRAINT uniq_flight_number UNIQUE (flight_number);

-- 5. Verify all constraints were added
SELECT 
    table_name, 
    constraint_name, 
    constraint_type
FROM 
    information_schema.table_constraints
WHERE 
    table_schema = 'flight_booking' AND
    table_name IN ('Passengers', 'Flights', 'Tickets')
ORDER BY 
    table_name, constraint_type;