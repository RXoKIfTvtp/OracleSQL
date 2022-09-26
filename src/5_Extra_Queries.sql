
/**
 * Only some lines need to be run at a time since these are used to test stuff.
**/

SET SERVEROUTPUT ON;

TRUNCATE TABLE Transactions;

INSERT INTO Transactions VALUES (Transactions_seq.NEXTVAL, 'B', 1000005, 80.00, TO_DATE('2019-06-25', 'yyyy-mm-dd'), '16:56', 304, -68.88);

INSERT INTO Transactions VALUES (3, 'D', 1000001, 345.67, TO_DATE('2019-05-01', 'yyyy-mm-dd'), '12:00', 111, 0);

EXECUTE ShowAccount(1000005);



/**
 * Print tables
**/

SELECT * FROM Owns;
SELECT * FROM Accounts;
SELECT * FROM Clients;
SELECT * FROM Transactions;

SELECT * FROM Branch;
SELECT * FROM Merchant;
SELECT * FROM TX_TYPE;


