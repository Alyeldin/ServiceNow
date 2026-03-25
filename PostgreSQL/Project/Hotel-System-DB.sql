-- Step 1 (Setting up tables that will be used in creating the database):
-- =>users
-- =>airlines
-- =>hotels
-- =>rooms
-- =>flights
-- =>seats
-- =>hotel_bookings
-- =>flight_bookings
-- =>flight_booking_passengers
-- =>payments
-- =>reviews

-- Step 2 (Defining the attributes of these tables - First Schema):
-- =>users:                    (user_id(PK), first_name, last_name, email, phone_number, address, password, role, created_at)
-- =>airlines:                 (airline_id(PK), airline_name, country_code, phone, website, have_flights)
-- =>hotels:                   (hotel_id(PK), hotel_name, hotel_city, hotel_location, rating, description, fully_booked, created_at)
-- =>rooms:                    (room_id(PK), hotel_id(FK), room_type, price, is_available, created_at)
-- =>flights:                  (flight_id(PK), airline_id(FK), departure_city, arrival_city, departure_time, arrival_time, price, total_seats, available_seats, status, created_at)
-- =>seats:                    (seat_id(PK), flight_id(FK), seat_number, seat_class, is_available, created_at)
-- =>hotel_bookings:           (booking_id(PK), user_id(FK), room_id(FK), check_in_date, check_out_date, number_of_guests, bill, booking_status, is_completed, created_at)
-- =>flight_bookings:          (booking_id(PK), user_id(FK), number_of_passengers, bill, booking_status, is_completed, created_at)
-- =>flight_booking_passengers:(passenger_id(PK), flight_booking_id(FK), seat_id(FK), passenger_name, passenger_email, created_at)
-- =>payments:                 (payment_id(PK), hotel_booking_id(FK-UNIQUE), flight_booking_id(FK-UNIQUE), amount, payment_method, payment_status, payment_date)
-- =>reviews:                  (review_id(PK), user_id(FK), hotel_id(FK), flight_id(FK), rating, review_description, created_at)


-- Step 3 (Adding Relations Between Tables):
-- rel1:   users → hotel_bookings                           (1-M) One user can have multiple hotel bookings
-- rel2:   users → flight_bookings                          (1-M) One user can have multiple flight bookings
-- rel3:   hotels → rooms                                   (1-M) One hotel has multiple rooms
-- rel4:   rooms → hotel_bookings                           (1-M) One room can be booked multiple times (different dates)
-- rel5:   airlines → flights                               (1-M) One airline operates multiple flights
-- rel6:   flights → seats                                  (1-M) One flight has multiple seats
-- rel7:   flights → flight_bookings                        (1-M) One flight can have multiple bookings (through passengers)
-- rel8:   flight_bookings → flight_booking_passengers      (1-M) One flight booking has multiple passengers
-- rel9:   seats → flight_booking_passengers                (1-M) One seat is assigned to one passenger per booking
-- rel10:  hotel_bookings → payments                        (1-1) One hotel booking has exactly one payment
-- rel11:  flight_bookings → payments                       (1-1) One flight booking has exactly one payment
-- rel12:  users → reviews                                  (1-M) One user can write multiple reviews
-- rel13:  hotels → reviews                                 (1-M) One hotel can have multiple reviews
-- rel14:  flights → reviews                                (1-M) One flight can have multiple reviews



--Users
CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    phone_number VARCHAR(20),
    address TEXT,
    password VARCHAR(255) NOT NULL,
    role VARCHAR(50) NOT NULL CHECK (role IN ('employee', 'admin', 'customer'))
);

-- 1. INSERT USERS
INSERT INTO users (first_name, last_name, email, phone_number, address, password, role)
VALUES
('Ahmed', 'Ali', 'ahmed.ali@email.com', '01001234567', '123 Cairo Street, Cairo', 'pass123', 'customer'),
('Fatima', 'Mohamed', 'fatima.m@email.com', '01011234567', '456 Giza Avenue, Giza', 'pass123', 'customer'),
('Hassan', 'Hassan', 'hassan.h@email.com', '01021234567', '789 Alex Road, Alexandria', 'pass123', 'customer'),
('Sara', 'Ahmed', 'sara.ahmed@email.com', '01031234567', '321 Aswan Street, Aswan', 'pass123', 'admin'),
('Omar', 'Ibrahim', 'omar.ibrahim@email.com', '01041234567', '654 Hurghada Lane, Hurghada', 'pass123', 'employee'),
('Layla', 'Hassan', 'layla.hassan@email.com', '01051234567', '987 Sharm El-Sheikh, Sharm', 'pass123', 'customer'),
('Karim', 'Khalil', 'karim.khalil@email.com', '01061234567', '111 Port Said, Port Said', 'pass123', 'customer'),
('Noor', 'Nabil', 'noor.nabil@email.com', '01071234567', '222 Suez City, Suez', 'pass123', 'customer');

select * from users;


-- Airlines
CREATE TABLE airlines (
    airline_id SERIAL PRIMARY KEY,
    airline_name VARCHAR(255) NOT NULL,
    country_code VARCHAR(2) NOT NULL,
    phone VARCHAR(15),
    website VARCHAR(255),
    have_flights BOOLEAN DEFAULT TRUE
);

-- 2. INSERT AIRLINES
INSERT INTO airlines (airline_name, country_code, phone, website, have_flights)
VALUES
('Egypt Air', 'EG', '02033460000', 'www.egyptair.com', TRUE),
('Air Cairo', 'EG', '02033460100', 'www.aircairo.com', TRUE),
('Emirates', 'AE', '04433310000', 'www.emirates.com', TRUE),
('Turkish Airlines', 'TR', '02166636363', 'www.turkishairlines.com', TRUE),
('Gulf Air', 'BH', '02243066000', 'www.gulfairco.com', TRUE);

INSERT INTO airlines (airline_name, country_code, phone, website, have_flights)
VALUES
('Nile Air', 'EG', '02033460000', 'www.nileair.com', FALSE)

select * from airlines;

-- Hotels
CREATE TABLE hotels (
    hotel_id SERIAL PRIMARY KEY,
    hotel_name VARCHAR(255) NOT NULL,
    hotel_city VARCHAR(100) NOT NULL,
    hotel_location VARCHAR(255),
    rating DECIMAL(2,1),
    description TEXT,
    fully_booked BOOLEAN DEFAULT FALSE
);  


-- 3. INSERT HOTELS
INSERT INTO hotels (hotel_name, hotel_city, hotel_location, rating, description, fully_booked)
VALUES
('Nile Hilton', 'Cairo', 'Downtown Cairo, Nile Corniche', 5.0, 'Luxury 5-star hotel with stunning Nile views', FALSE),
('Pyramids Plaza', 'Giza', 'Giza Plateau, Near Pyramids', 4.5, '4-star hotel near the Great Pyramids', FALSE),
('Red Sea Resort', 'Hurghada', 'Hurghada Beach Front', 4.8, 'Beach resort with water sports facilities', FALSE),
('Sinai Paradise', 'Sharm El-Sheikh', 'Sharm Beach, Red Sea', 4.2, 'Family-friendly beach hotel', FALSE),
('Alexandria Grandeur', 'Alexandria', 'Alexandria Corniche', 4.0, 'Historic hotel with Mediterranean views', FALSE),
('Aswan Felucca', 'Aswan', 'Aswan Corniche, Nile River', 4.3, 'Traditional Nile-side hotel', TRUE);

select * from hotels;


-- Rooms
CREATE TABLE rooms (
    room_id SERIAL PRIMARY KEY,
    hotel_id INT NOT NULL,
    room_type VARCHAR(50) NOT NULL,  -- 'single', 'double', 'suite'
    price DECIMAL(10,2) NOT NULL,
    is_available BOOLEAN DEFAULT TRUE,

    FOREIGN KEY (hotel_id) REFERENCES hotels(hotel_id),
    CHECK (price > 0)
);

-- 4. INSERT ROOMS (depends on hotels)
INSERT INTO rooms (hotel_id, room_type, price, is_available)
VALUES
(1, 'single', 150.00, TRUE),
(1, 'double', 250.00, TRUE),
(1, 'suite', 450.00, FALSE),
(2, 'single', 100.00, TRUE),
(2, 'double', 180.00, TRUE),
(3, 'double', 200.00, TRUE),
(3, 'suite', 380.00, TRUE),
(4, 'single', 80.00, FALSE),
(4, 'double', 160.00, TRUE),
(5, 'double', 140.00, TRUE);

INSERT INTO rooms (hotel_id, room_type, price, is_available)
VALUES (1, 'single', 200.00, TRUE);

INSERT INTO rooms (hotel_id, room_type, price, is_available) VALUES
(1, 'single', 180.00, TRUE),
(1, 'double', 260.00, TRUE),
(1, 'suite', 500.00, TRUE),
(1, 'single', 170.00, TRUE);

select * from rooms;


-- Flights
CREATE TABLE flights (
    flight_id SERIAL PRIMARY KEY,
    airline_id INT NOT NULL,
    departure_city VARCHAR(100) NOT NULL,
    arrival_city VARCHAR(100) NOT NULL,
    departure_time TIMESTAMP NOT NULL,
    arrival_time TIMESTAMP NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    total_seats INT NOT NULL, 
    available_seats INT NOT NULL,
    status VARCHAR(50) DEFAULT 'scheduled',

    FOREIGN KEY (airline_id) REFERENCES airlines(airline_id),
    CHECK (available_seats >= 0 AND available_seats <= total_seats),
    CHECK (departure_time < arrival_time),
    CHECK (price > 0)
);

-- 5. INSERT FLIGHTS (depends on airlines)
INSERT INTO flights (airline_id, departure_city, arrival_city, departure_time, arrival_time, price, total_seats, available_seats, status)
VALUES
(1, 'Cairo', 'London', '2026-04-10 08:00:00', '2026-04-10 14:30:00', 500.00, 180, 45, 'scheduled'),
(1, 'Cairo', 'Paris', '2026-04-11 10:00:00', '2026-04-11 16:00:00', 480.00, 180, 80, 'scheduled'),
(2, 'Cairo', 'Dubai', '2026-04-12 06:00:00', '2026-04-12 10:30:00', 350.00, 150, 30, 'scheduled'),
(3, 'Cairo', 'Abu Dhabi', '2026-04-13 09:00:00', '2026-04-13 11:00:00', 320.00, 200, 120, 'scheduled'),
(4, 'Cairo', 'Istanbul', '2026-04-14 07:00:00', '2026-04-14 12:00:00', 420.00, 160, 60, 'scheduled'),
(5, 'Cairo', 'Doha', '2026-04-15 11:00:00', '2026-04-15 13:30:00', 280.00, 140, 85, 'scheduled'),
(1, 'Alexandria', 'London', '2026-04-16 09:30:00', '2026-04-16 16:00:00', 520.00, 180, 50, 'scheduled'),
(2, 'Hurghada', 'Frankfurt', '2026-04-17 08:00:00', '2026-04-17 15:00:00', 450.00, 150, 40, 'scheduled');

INSERT INTO flights (airline_id, departure_city, arrival_city, departure_time, arrival_time, price, total_seats, available_seats)
VALUES
(1, 'Cairo', 'London', '2026-04-18 08:00:00', '2026-04-18 14:00:00', 450.00, 180, 100),
(2, 'Cairo', 'London', '2026-04-19 09:00:00', '2026-04-19 15:00:00', 550.00, 150, 20);

select * from flights;


-- Seats
CREATE TABLE seats (
    seat_id SERIAL PRIMARY KEY,
    flight_id INT NOT NULL,
    seat_number VARCHAR(10) NOT NULL,
    seat_class VARCHAR(20) NOT NULL,
    is_available BOOLEAN DEFAULT TRUE,

    FOREIGN KEY (flight_id) REFERENCES flights(flight_id),
    UNIQUE(flight_id, seat_number)
);

-- 6. INSERT SEATS (depends on flights)
INSERT INTO seats (flight_id, seat_number, seat_class, is_available)
VALUES
-- Flight 1 (Cairo-London)
(1, '1A', 'economy', TRUE),
(1, '1B', 'economy', TRUE),
(1, '1C', 'economy', FALSE),
(1, '2A', 'business', TRUE),
(1, '2B', 'business', FALSE),
-- Flight 2 (Cairo-Paris)
(2, '1A', 'economy', TRUE),
(2, '1B', 'economy', TRUE),
(2, '2A', 'business', TRUE),
(2, '2B', 'business', TRUE),
-- Flight 3 (Cairo-Dubai)
(3, '1A', 'economy', TRUE),
(3, '1B', 'economy', FALSE),
(3, '2A', 'business', TRUE),
-- Flight 4 (Cairo-Abu Dhabi)
(4, '1A', 'economy', TRUE),
(4, '1B', 'economy', TRUE),
(4, '2A', 'business', FALSE),
-- Flight 5 (Cairo-Istanbul)
(5, '1A', 'economy', TRUE),
(5, '1B', 'economy', TRUE),
(5, '2A', 'business', TRUE),
-- Flight 6 (Cairo-Doha)
(6, '1A', 'economy', TRUE),
(6, '1B', 'economy', TRUE),
-- Flight 7 (Alexandria-London)
(7, '1A', 'economy', TRUE),
(7, '2A', 'business', TRUE),
-- Flight 8 (Hurghada-Frankfurt)
(8, '1A', 'economy', TRUE),
(8, '2A', 'business', TRUE);

INSERT INTO seats (flight_id, seat_number, seat_class, is_available)
VALUES
(9, '1A', 'economy', TRUE),
(9, '1B', 'economy', FALSE),
(10, '1A', 'economy', TRUE),
(10, '2A', 'business', TRUE);

select * from seats;


-- Hotel Bookings
CREATE TABLE hotel_bookings (
    booking_id SERIAL PRIMARY KEY,
    user_id INT NOT NULL,
    room_id INT NOT NULL,
    check_in_date DATE NOT NULL,
    check_out_date DATE NOT NULL,
    number_of_guests INT NOT NULL,
    bill DECIMAL(10,2) NOT NULL,
    booking_status VARCHAR(50) DEFAULT 'pending',
    is_completed BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (room_id) REFERENCES rooms(room_id),
    CHECK (check_in_date < check_out_date),
    CHECK (number_of_guests > 0),
    CHECK (bill >= 0)

);

-- 7. INSERT HOTEL BOOKINGS
INSERT INTO hotel_bookings (user_id, room_id, check_in_date, check_out_date, number_of_guests, bill, booking_status, is_completed)
VALUES
(1, 1, '2026-04-15', '2026-04-17', 1, 300.00, 'confirmed', FALSE),
(2, 2, '2026-04-18', '2026-04-21', 2, 750.00, 'confirmed', FALSE),
(3, 4, '2026-04-10', '2026-04-12', 1, 200.00, 'pending', FALSE),
(4, 6, '2026-04-20', '2026-04-23', 2, 600.00, 'confirmed', FALSE),
(5, 7, '2026-04-12', '2026-04-14', 2, 760.00, 'confirmed', FALSE),
(6, 9, '2026-04-25', '2026-04-27', 2, 320.00, 'pending', FALSE),
(7, 10, '2026-04-18', '2026-04-20', 1, 140.00, 'cancelled', FALSE),
(8, 2, '2026-04-22', '2026-04-25', 2, 750.00, 'confirmed', FALSE);

INSERT INTO hotel_bookings (user_id, room_id, check_in_date, check_out_date, number_of_guests, bill, booking_status)
VALUES
(1, 11, '2026-04-10', '2026-04-12', 1, 360.00, 'confirmed'),
(2, 12, '2026-04-11', '2026-04-13', 2, 520.00, 'cancelled'),
(3, 13, '2026-04-12', '2026-04-15', 2, 1000.00, 'confirmed');

select * from hotel_bookings;


--Flight Booking
CREATE TABLE flight_bookings (
    booking_id SERIAL PRIMARY KEY,
    user_id INT NOT NULL,
    number_of_passengers INT NOT NULL,
    bill DECIMAL(10,2) NOT NULL,
    booking_status VARCHAR(50) DEFAULT 'pending',
    is_completed BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (user_id) REFERENCES users(user_id),
    CHECK (number_of_passengers > 0),
    CHECK (bill >= 0) 
);


-- 8. INSERT FLIGHT BOOKINGS
INSERT INTO flight_bookings (user_id, number_of_passengers, bill, booking_status, is_completed)
VALUES
(1, 1, 500.00, 'confirmed', FALSE),
(2, 2, 1000.00, 'confirmed', FALSE),
(3, 1, 350.00, 'pending', FALSE),
(4, 3, 960.00, 'confirmed', FALSE),
(5, 2, 840.00, 'confirmed', FALSE),
(6, 1, 280.00, 'pending', FALSE),
(7, 2, 1040.00, 'confirmed', FALSE),
(8, 1, 450.00, 'cancelled', FALSE);

select * from flight_bookings;


-- Payments
CREATE TABLE payments (
    payment_id SERIAL PRIMARY KEY,
    hotel_booking_id INT,
    flight_booking_id INT,
    amount DECIMAL(10,2) NOT NULL,
    payment_method VARCHAR(50),
    payment_status VARCHAR(50) DEFAULT 'pending',
    payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (hotel_booking_id) REFERENCES hotel_bookings(booking_id),
    FOREIGN KEY (flight_booking_id) REFERENCES flight_bookings(booking_id),
    CHECK (hotel_booking_id IS NOT NULL OR flight_booking_id IS NOT NULL),
    CHECK (amount > 0)
);


-- 10. INSERT PAYMENTS
INSERT INTO payments (hotel_booking_id, flight_booking_id, amount, payment_method, payment_status, payment_date)
VALUES
(1, NULL, 300.00, 'credit_card', 'completed', '2026-04-14 10:30:00'),
(2, NULL, 750.00, 'debit_card', 'completed', '2026-04-17 14:15:00'),
(3, NULL, 200.00, 'online_transfer', 'pending', '2026-04-09 16:45:00'),
(4, NULL, 600.00, 'credit_card', 'completed', '2026-04-19 11:20:00'),
(5, NULL, 760.00, 'debit_card', 'completed', '2026-04-11 09:00:00'),
(6, NULL, 320.00, 'credit_card', 'pending', '2026-04-24 15:30:00'),
(7, NULL, 140.00, 'credit_card', 'cancelled', '2026-04-17 12:00:00'),
(8, NULL, 750.00, 'online_transfer', 'completed', '2026-04-21 13:45:00'),
(NULL, 1, 500.00, 'credit_card', 'completed', '2026-04-09 08:30:00'),
(NULL, 2, 1000.00, 'debit_card', 'completed', '2026-04-10 10:15:00'),
(NULL, 3, 350.00, 'credit_card', 'pending', '2026-04-11 14:20:00'),
(NULL, 4, 960.00, 'online_transfer', 'completed', '2026-04-12 16:45:00'),
(NULL, 5, 840.00, 'credit_card', 'completed', '2026-04-13 09:30:00'),
(NULL, 6, 280.00, 'debit_card', 'pending', '2026-04-14 11:00:00'),
(NULL, 7, 1040.00, 'credit_card', 'completed', '2026-04-15 12:15:00'),
(NULL, 8, 450.00, 'online_transfer', 'cancelled', '2026-04-16 14:30:00');

INSERT INTO payments (hotel_booking_id, amount, payment_method, payment_status)
VALUES
(9, 360.00, 'credit_card', 'completed'),
(10, 520.00, 'debit_card', 'cancelled'),
(11, 1000.00, 'credit_card', 'completed');

select * from payments;


-- Reviews
CREATE TABLE reviews (
    review_id SERIAL PRIMARY KEY,
    user_id INT NOT NULL,
    hotel_id INT,
    flight_id INT,
    rating INT NOT NULL CHECK (rating BETWEEN 1 AND 5),
    review_description TEXT,

    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (hotel_id) REFERENCES hotels(hotel_id),
    FOREIGN KEY (flight_id) REFERENCES flights(flight_id),
    CHECK (hotel_id IS NOT NULL OR flight_id IS NOT NULL)
);

-- 11. INSERT REVIEWS
INSERT INTO reviews (user_id, hotel_id, flight_id, rating, review_description)
VALUES
(1, 1, NULL, 5, 'Excellent service and great location! The staff was very friendly.'),
(2, 2, NULL, 4, 'Good hotel near the pyramids. Rooms were clean and comfortable.'),
(3, 3, NULL, 5, 'Amazing beach resort! Perfect for relaxation and water sports.'),
(4, 4, NULL, 3, 'Nice hotel but rooms need renovation. Food was average.'),
(5, 5, NULL, 4, 'Historic hotel with character. Mediterranean views are stunning.'),
(1, NULL, 1, 5, 'Great flight experience. On-time arrival and friendly crew.'),
(2, NULL, 2, 4, 'Good service but seats were a bit cramped.'),
(3, NULL, 3, 5, 'Excellent service and smooth flight. Highly recommend!'),
(4, NULL, 4, 4, 'Professional crew and comfortable seating.'),
(6, NULL, 5, 4, 'Good value for money. Flight was smooth.'),
(7, 2, NULL, 3, 'Decent hotel. Could use better Wi-Fi.'),
(8, 1, NULL, 5, 'Loved every moment at Nile Hilton! Perfect for my stay.');

select * from reviews;


-- Flight Booking Passengers
CREATE TABLE flight_booking_passengers (
    passenger_id SERIAL PRIMARY KEY,
    flight_booking_id INT NOT NULL,
    seat_id INT NOT NULL,
    passenger_name VARCHAR(100) NOT NULL,
    passenger_email VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (flight_booking_id) REFERENCES flight_bookings(booking_id),
    FOREIGN KEY (seat_id) REFERENCES seats(seat_id),
    UNIQUE(seat_id)
);

-- 9. INSERT FLIGHT BOOKING PASSENGERS
INSERT INTO flight_booking_passengers (flight_booking_id, seat_id, passenger_name, passenger_email)
VALUES
(1, 1, 'Ahmed Ali', 'ahmed.ali@email.com'),
(2, 2, 'Fatima Mohamed', 'fatima.m@email.com'),
(2, 4, 'Hassan Hassan', 'hassan.h@email.com'),
(3, 10, 'Sara Ahmed', 'sara.ahmed@email.com'),
(4, 13, 'Omar Ibrahim', 'omar.ibrahim@email.com'),
(4, 14, 'Layla Hassan', 'layla.hassan@email.com'),
(4, 15, 'Karim Khalil', 'karim.khalil@email.com'),
(5, 16, 'Noor Nabil', 'noor.nabil@email.com'),
(5, 17, 'Ahmed Ali', 'ahmed.ali@email.com'),
(6, 19, 'Fatima Mohamed', 'fatima.m@email.com'),
(7, 21, 'Hassan Hassan', 'hassan.h@email.com'),
(7, 22, 'Sara Ahmed', 'sara.ahmed@email.com'),
(8, 24, 'Omar Ibrahim', 'omar.ibrahim@email.com');

INSERT INTO flight_booking_passengers (flight_booking_id, seat_id, passenger_name)
VALUES
(1, 25, 'New Passenger');

select * from flight_booking_passengers;


-- show hotels by location (City = 'Cairo')
SELECT hotel_id, hotel_name, hotel_city, hotel_location, rating, description
FROM hotels
WHERE hotel_city = 'Cairo'
  AND NOT fully_booked
ORDER BY rating DESC, hotel_name;

--show all the available rooms in the hotel in previous select
SELECT  h.hotel_name, h.hotel_city, r.room_id, r.room_type, r.price AS price_per_night
FROM hotels h
JOIN rooms r ON h.hotel_id = r.hotel_id
WHERE h.hotel_city = 'Cairo' AND NOT h.fully_booked AND r.is_available = TRUE
AND NOT EXISTS (SELECT 1 FROM hotel_bookings hb WHERE hb.room_id = r.room_id AND hb.booking_status != 'cancelled')
ORDER BY h.rating DESC, h.hotel_name;


-- if customer wants to go on a summer vacation in Hurghada and need to find the rooms available on specific date
-- Hurghada, April 15-17
SELECT  h.hotel_name, h.hotel_city, r.room_id, r.room_type, r.price as Price_Per_night
FROM hotels h JOIN rooms r ON h.hotel_id = r.hotel_id
LEFT JOIN hotel_bookings hb ON r.room_id = hb.room_id AND hb.booking_status != 'cancelled' 
AND NOT (hb.check_out_date <= '2026-04-15' OR hb.check_in_date >= '2026-04-17')
WHERE h.hotel_city = 'Hurghada' AND r.is_available = TRUE 
GROUP BY h.hotel_id, h.hotel_name, h.hotel_city, r.room_id, r.room_type, r.price
HAVING COUNT(CASE WHEN hb.booking_id IS NULL THEN 1 END) > 0
ORDER BY r.price ASC;

-- Hurghada, April 20-23
SELECT  h.hotel_name, h.hotel_city, r.room_id, r.room_type, r.price as Price_Per_night
FROM hotels h JOIN rooms r ON h.hotel_id = r.hotel_id
LEFT JOIN hotel_bookings hb ON r.room_id = hb.room_id AND hb.booking_status != 'cancelled' 
AND NOT (hb.check_out_date <= '2026-04-20' OR hb.check_in_date >= '2026-04-23')
WHERE h.hotel_city = 'Hurghada' AND r.is_available = TRUE 
GROUP BY h.hotel_id, h.hotel_name, h.hotel_city, r.room_id, r.room_type, r.price
HAVING COUNT(CASE WHEN hb.booking_id IS NULL THEN 1 END) > 0
ORDER BY r.price ASC;



--show the best hotels in a certain city that are not fully booked
SELECT hotel_name, hotel_city, rating
FROM hotels
WHERE hotel_city = 'Cairo' AND NOT fully_booked
ORDER BY rating DESC;


--show the available rooms in case 1 hotels 
SELECT h.hotel_name, r.room_id, r.room_type, r.price
FROM hotels h
JOIN rooms r ON h.hotel_id = r.hotel_id
WHERE h.hotel_city = 'Cairo' AND r.is_available = TRUE
AND NOT EXISTS (SELECT 1 FROM hotel_bookings hb WHERE hb.room_id = r.room_id AND hb.booking_status != 'cancelled');


--show total revenue per hotel like which hotel make more money ()
SELECT h.hotel_name, SUM(p.amount) AS revenue
FROM hotels h
JOIN rooms r ON h.hotel_id = r.hotel_id
JOIN hotel_bookings hb ON r.room_id = hb.room_id
JOIN payments p ON hb.booking_id = p.hotel_booking_id
WHERE p.payment_status = 'completed'
GROUP BY h.hotel_name
ORDER BY revenue DESC;

--show available flights from cairo to london 
SELECT f.flight_id, a.airline_name, f.departure_city, f.arrival_city, f.price
FROM flights f
JOIN airlines a ON f.airline_id = a.airline_id
WHERE f.departure_city = 'Cairo' AND f.arrival_city = 'London' AND f.available_seats > 0
ORDER BY f.price ;

--show all booking history of flights and hotels (booking report)
SELECT u.first_name, 'Hotel' AS type, hb.booking_id, hb.bill, hb.booking_status
FROM users u
JOIN hotel_bookings hb ON u.user_id = hb.user_id
UNION ALL
SELECT u.first_name, 'Flight' AS type, fb.booking_id, fb.bill, fb.booking_status
FROM users u
JOIN flight_bookings fb ON u.user_id = fb.user_id;

--show all users who have booked hotels 
SELECT u.user_id, u.first_name, u.last_name, 'Hotel' AS type, hb.booking_id, hb.bill, hb.booking_status
FROM users u JOIN hotel_bookings hb ON u.user_id = hb.user_id;

--show all users who have booked flights 
SELECT u.user_id, u.first_name, u.last_name, 'Flight' AS type, fb.booking_id, fb.bill, fb.booking_status
FROM users u JOIN flight_bookings fb ON u.user_id = fb.user_id;

--show all users who have booked both hotels and flights
SELECT u.user_id, u.first_name, u.last_name
FROM users u 
JOIN hotel_bookings hb ON u.user_id = hb.user_id
INTERSECT
SELECT u.user_id, u.first_name, u.last_name
FROM users u 
JOIN flight_bookings fb ON u.user_id = fb.user_id;

--calculate all the bills or money that we need to collect (Collect Money Report) 
SELECT hb.booking_id,(hb.check_out_date - hb.check_in_date) * r.price AS calculated_bill
FROM hotel_bookings hb
JOIN rooms r ON hb.room_id = r.room_id;

--show all hotels that have no bookings
SELECT h.hotel_name ,h.hotel_city FROM hotels h
WHERE NOT EXISTS (
    SELECT 1 FROM rooms r
    JOIN hotel_bookings hb ON r.room_id = hb.room_id
    WHERE r.hotel_id = h.hotel_id
);

--show the most expensive luxariues rooms available in our hotels
SELECT h.hotel_name, r.room_id, r.room_type, r.price
FROM rooms r
JOIN hotels h ON r.hotel_id = h.hotel_id
WHERE r.is_available = TRUE AND r.price = (
    SELECT MAX(price)
    FROM rooms r2
    WHERE r2.hotel_id = r.hotel_id)
ORDER BY r.price DESC;

--user book a room in an hotel
BEGIN;

INSERT INTO hotel_bookings (user_id, room_id, check_in_date, check_out_date, number_of_guests, bill, booking_status)
VALUES (1, 11, '2026-05-01', '2026-05-03', 2, 400, 'confirmed');

UPDATE rooms SET is_available = FALSE WHERE room_id = 11;

COMMIT;

--users who booked a flight for his family
SELECT u.first_name, fb.booking_id, COUNT(p.passenger_id) AS passengers,fb.booking_status
FROM flight_bookings fb
JOIN flight_booking_passengers p ON fb.booking_id = p.flight_booking_id
JOIN users u ON u.user_id= fb.user_id
GROUP BY u.first_name,fb.booking_id;

--show all flights that have no passengers (Empty Flight Report)
SELECT a.airline_name, f.flight_id
FROM flights f
JOIN airlines a ON a.airline_id=f.airline_id
WHERE NOT EXISTS (
    SELECT 1 FROM seats s
    JOIN flight_booking_passengers p ON s.seat_id = p.seat_id
    WHERE s.flight_id = f.flight_id
);

--compare revenue of both hotels and flights (Descision making)
SELECT 'Hotel' AS Type, SUM(amount)
FROM payments
WHERE hotel_booking_id IS NOT NULL
UNION ALL
SELECT 'Flight', SUM(amount)
FROM payments
WHERE flight_booking_id IS NOT NULL;

--show reviews of hotels 
SELECT h.hotel_name, COUNT(r.review_id) as num_of_reviews, ROUND(AVG(r.rating),2) as  Average_Rate
FROM hotels h
JOIN reviews r ON h.hotel_id = r.hotel_id
GROUP BY h.hotel_name
ORDER BY Average_Rate;

--show all payment status for admin (Financial Report)
SELECT p.payment_id, u.first_name || ' ' || u.last_name AS customer_name, p.amount, p.payment_method,
p.payment_status, p.payment_date, CASE WHEN p.payment_status = 'completed' THEN p.amount ELSE 0 END AS revenue
FROM payments p
LEFT JOIN hotel_bookings hb ON p.hotel_booking_id = hb.booking_id
LEFT JOIN flight_bookings fb ON p.flight_booking_id = fb.booking_id
LEFT JOIN users u ON COALESCE(hb.user_id, fb.user_id) = u.user_id
ORDER BY p.payment_date DESC;

--COMPLETE HOTEL BOOKING
---------------------------------------
BEGIN TRANSACTION;

--check room is valid
SELECT room_id FROM rooms 
WHERE room_id = 5 
AND is_available = TRUE
FOR UPDATE;

-- creation of hotel booking
INSERT INTO hotel_bookings (user_id, room_id, check_in_date, check_out_date, number_of_guests, bill, booking_status)
VALUES (1, 5, '2026-05-15', '2026-05-18', 2, 600.00, 'pending');

-- save customer payment
INSERT INTO payments (hotel_booking_id, amount, payment_method, payment_status)
VALUES (CURRVAL('hotel_bookings_booking_id_seq'), 600.00, 'credit_card', 'completed');

COMMIT;
ROLLBACK;
---------------------------------------

--COMPLETE FLIGHT BOOKING 
---------------------------------------
BEGIN TRANSACTION;
 
-- creation of flight booking for 3 passengers
INSERT INTO flight_bookings (user_id, number_of_passengers, bill, booking_status)
VALUES (2, 3, 1500.00, 'pending');
 
-- Assign seat 1 to passenger 1
INSERT INTO flight_booking_passengers (flight_booking_id, seat_id, passenger_name, passenger_email)
VALUES (1, 1, 'Ahmed Ali', 'ahmed@email.com');
 
-- Assign seat 2 to passenger 2
INSERT INTO flight_booking_passengers (flight_booking_id, seat_id, passenger_name, passenger_email)
VALUES (1, 2, 'Fatima Mohamed', 'fatima@email.com');
 
-- Assign seat 3 to passenger 3
INSERT INTO flight_booking_passengers (flight_booking_id, seat_id, passenger_name, passenger_email)
VALUES (1, 4, 'Hassan Hassan', 'hassan@email.com');
 
-- Record payment ONLY if all passengers assigned
INSERT INTO payments (flight_booking_id, amount, payment_method, payment_status)
VALUES (1, 1500.00, 'credit_card', 'completed');
 
-- Update flight available seats
UPDATE flights 
SET available_seats = available_seats - 3
WHERE flight_id = 1;
 
-- Update seats as booked
UPDATE seats 
SET is_available = FALSE
WHERE seat_id IN (1, 2, 4);
 
COMMIT;
ROLLBACK;
---------------------------------------

--update a room someone just checked in
UPDATE hotel_bookings SET booking_status = 'checked_in', is_completed = FALSE
WHERE booking_id = 1 AND check_in_date = CURRENT_DATE
AND booking_status = 'confirmed';

--apply some offers on rooms prices
UPDATE rooms SET price = CASE 
WHEN room_type = 'suite' THEN price * 0.75  -- 25% offer for suites
WHEN room_type = 'double' THEN price * 0.85 -- 15% offer for doubles
WHEN room_type = 'single' THEN price * 0.90 -- 10% offer for singles
END
WHERE hotel_id = 1
AND room_type IN ('single', 'double', 'suite');