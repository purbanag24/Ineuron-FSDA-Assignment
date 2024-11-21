/* SQL PROJECT from HIRING ABC COMPANY FOR IENURON.AI FSDA 2.0 course*/
/* Date last updated and ran in SNOWFLAKE: 08-07-2023 */
/* Author: Roopmathi Gunna */

USE ASSIGNMENTS;
CREATE TABLE shopping_history(
product varchar(20) NOT NULL,
quantity integer NOT NULL,
unit_price integer NOT NULL
);

INSERT INTO shopping_history (product, quantity, unit_price) VALUES
    ('Milk', 2, 6),
    ('Bread', 1, 4),
    ('Eggs', 1, 3),
    ('Bananas', 5, 8),
    ('Chicken', 2, 12),
    ('Tomatoes', 3, 5),
    ('Potatoes', 4, 7),
    ('Cereal', 1, 9),
    ('Orange Juice', 1, 6),
    ('Cheese', 3, 10);

    INSERT INTO shopping_history (product, quantity, unit_price) VALUES
    ('Milk', 1, 5), -- Additional entry for Milk with a different price
    ('Bread', 3, 3), -- Additional entry for Bread with a different price
    ('Eggs', 2, 4), -- Additional entry for Eggs with a different price
    ('Bananas', 2, 9), -- Additional entry for Bananas with a different price
    ('Chicken', 1, 15); -- Additional entry for Chicken with a different price

    INSERT INTO shopping_history (product, quantity, unit_price)
VALUES
    ('Milk', 3, 7), -- Additional entry for Milk with a different price
    ('Bread', 2, 5), -- Additional entry for Bread with a different price
    ('Eggs', 2, 4), -- Additional entry for Eggs with a different price
    ('Cheese', 2, 8), -- Additional entry for Cheese with a different price
    ('Orange Juice', 3, 4); -- Additional entry for Orange Juice with a different price

    
SELECT * from shopping_history; -- validate values are loaded into the table 

/* TASK 1 Write an SQL  query that, for each "product", returns the total amount of money spent on it. 
Rows should be ordered in descending alphabetical order by "product". */

SELECT product,
       SUM(quantity*unit_price) as total_money_spent
FROM shopping_history
GROUP BY product
ORDER BY product DESC;

/*TASK 2 SETTING UP THE TABLES REQUIRED*/

CREATE TABLE phones (
    name varchar(20) NOT NULL UNIQUE,
    phone_number INTEGER NOT NULL UNIQUE
    );

    INSERT INTO phones (name, phone_number) VALUES
    ('Jack', 1234),
    ('Lena', 3333),
    ('Mark', 9999),
    ('Anna', 7582);
    
SELECT * FROM phones; -- validate insertion 

 CREATE TABLE calls (
    id INTEGER NOT NULL,
    caller INTEGER NOT NULL,
    callee INTEGER NOT NULL,
    duration INTEGER NOT NULL,
    UNIQUE (id)
);

INSERT INTO calls (id, caller, callee, duration)
VALUES
    (25, 1234, 7582, 8),
    (7, 9999, 7582, 1),
    (18, 9999, 3333, 4),
    (2, 7582, 3333, 3),
    (3, 3333, 1234, 1),
    (21, 3333, 1234, 1);

    SELECT * FROM calls;
 
/* TASK 2: Write a SQL query that finds all clients who talked for at least 10 minutes in total. */
WITH call_duration
AS (
	SELECT caller AS phone_number,
		   sum(duration) AS duration
	FROM calls
	GROUP BY CALLER
	
	UNION ALL
	
	SELECT callee AS phone_number,
		sum(duration) AS duration
	FROM calls
	GROUP BY callee
	)
SELECT name
FROM phones p
JOIN call_duration cd ON cd.phone_number = p.phone_number
GROUP BY name
HAVING SUM(duration) >= 10
ORDER BY name
 
--  Result: Anna and Jack are the most talkative :-) 

/* TASK 3 - Bank Balance case */

CREATE TABLE transactions(
amount integer not null,
transaction_date date not null
);

select * from transactions;
INSERT INTO transactions (amount, transaction_date) VALUES (1000,'2020-01-06');
INSERT INTO transactions (amount, transaction_date) VALUES (5000, '2020-01-14');
INSERT INTO transactions (amount, transaction_date) VALUES (-1500, '2020-01-16');
INSERT INTO transactions (amount, transaction_date) VALUES (3000, '2020-01-25');
INSERT INTO transactions (amount, transaction_date) VALUES (-800, '2020-02-03');
INSERT INTO transactions (amount, transaction_date) VALUES (2500, '2020-02-15');
INSERT INTO transactions (amount, transaction_date) VALUES (-1200, '2020-02-28');
INSERT INTO transactions (amount, transaction_date) VALUES (4000, '2020-03-10');
INSERT INTO transactions (amount, transaction_date) VALUES (-1000, '2020-03-22');
INSERT INTO transactions (amount, transaction_date) VALUES (3500, '2020-04-05');
INSERT INTO transactions (amount, transaction_date) VALUES (-900, '2020-04-18'); 
INSERT INTO transactions (amount, transaction_date) VALUES (4500, '2020-04-30');
INSERT INTO transactions (amount, transaction_date) VALUES (-700, '2020-05-04'); 
INSERT INTO transactions (amount, transaction_date) VALUES (3000, '2020-05-08');
INSERT INTO transactions (amount, transaction_date) VALUES (-600, '2020-05-12');
INSERT INTO transactions (amount, transaction_date) VALUES (2000, '2020-05-20');
INSERT INTO transactions (amount, transaction_date) VALUES (-500, '2020-05-28');
INSERT INTO transactions (amount, transaction_date) VALUES (-800, '2020-06-03');
INSERT INTO transactions (amount, transaction_date) VALUES (4000, '2020-06-10');
INSERT INTO transactions (amount, transaction_date) VALUES (-900, '2020-06-15');
INSERT INTO transactions (amount, transaction_date) VALUES (2500, '2020-06-22');
INSERT INTO transactions (amount, transaction_date) VALUES (-1000, '2020-06-30');

--Main Task: Write an SQL query that returns a table containing one column, balance.*/

-- Common Table Expression (CTE) to calculate the incoming transfer and credit card payments for each month
WITH MonthlyBalance AS (
  SELECT
    EXTRACT(MONTH FROM transaction_date) AS month,
    SUM(CASE WHEN AMOUNT >= 0 THEN AMOUNT ELSE 0 END) AS incoming_transfer,
    SUM(CASE WHEN AMOUNT < 0 THEN AMOUNT ELSE 0 END) AS cc_payment
  FROM transactions
  GROUP BY EXTRACT(MONTH FROM transaction_date)
),
-- Common Table Expression (CTE) to calculate the credit card fees for each month
MonthlyCreditCardFees AS (
  SELECT month,
    CASE
        WHEN COUNT(*) >= 3 AND SUM(ABS(cc_payment)) >= 100 THEN 0
        ELSE 5
    END AS credit_card_fee
  FROM MonthlyBalance
  GROUP BY month
)
-- Main query to calculate the balance at the end of the year
SELECT
-- Calculate the total balance for the year by subtracting credit card payments, credit card fees, and incoming transfers
  SUM(incoming_transfer - cc_payment - credit_card_fee) AS balance
FROM MonthlyBalance
JOIN MonthlyCreditCardFees USING (month);

/* here is the result set 
Balance 
44,870
*/



