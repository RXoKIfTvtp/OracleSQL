
/**
 * Populate all tables
**/

INSERT INTO Branch VALUES (101, 'Scranton');
INSERT INTO Branch VALUES (102, 'Akron');
INSERT INTO Branch VALUES (103, 'Albany');
INSERT INTO Branch VALUES (104, 'Nashua');
INSERT INTO Branch VALUES (105, 'New York');

INSERT INTO Merchant VALUES (301, 'Dwight Schrute');
INSERT INTO Merchant VALUES (302, 'Jim Halpert');
INSERT INTO Merchant VALUES (303, 'Pam Beesly');
INSERT INTO Merchant VALUES (304, 'Karen Filippelli');
INSERT INTO Merchant VALUES (305, 'Stanley Hudson');
INSERT INTO Merchant VALUES (306, 'Phyllis Vance');

INSERT INTO TX_TYPE VALUES ('D', 'Deposit');
INSERT INTO TX_TYPE VALUES ('W', 'Withdrawal');
INSERT INTO TX_TYPE VALUES ('B', 'Bill Payment');
INSERT INTO TX_TYPE VALUES ('P', 'Purchase');
INSERT INTO TX_TYPE VALUES ('R', 'Return');

INSERT INTO Clients VALUES (Clients_seq.NEXTVAL, 'Bruno', 'Lawrie', 'Thames House, 12 Millbank Way', 'London', 'London', 'SE12', '+44 20 7930 9007', 'bruno.lawrie@unity.gov.uk');
INSERT INTO Clients VALUES (Clients_seq.NEXTVAL, 'Otto', 'Schenker', 'Thames House, 12 Millbank Way', 'London', 'London', 'SE12', '+44 20 7930 9009', 'otto.schenker@unity.gov.uk');
INSERT INTO Clients VALUES (Clients_seq.NEXTVAL, 'Tom', 'Goodman', 'Thames House, 12 Millbank Way', 'London', 'London', 'SE12', '+44 20 7930 9008', 'tom.goodman@unity.gov.uk');
INSERT INTO Clients VALUES (Clients_seq.NEXTVAL, 'Werner', 'von Haupt', 'Thames House, 12 Millbank Way', 'London', 'London', 'SE12', '+44 20 7930 9005', 'werner.vonhaupt@unity.gov.uk');
INSERT INTO Clients VALUES (Clients_seq.NEXTVAL, 'Nigel', 'Jones', 'Thames House, 12 Millbank Way', 'London', 'London', 'SE12', '+44 20 7930 9001', 'nigel.jones@unity.gov.uk');
INSERT INTO Clients VALUES (Clients_seq.NEXTVAL, 'Roger', 'Smith', 'Thames House, 12 Millbank Way', 'London', 'London', 'SE12', '+44 20 7930 9002', 'roger.smith@unity.gov.uk');

INSERT INTO Accounts VALUES (Accounts_seq.NEXTVAL, 0);
INSERT INTO Accounts VALUES (Accounts_seq.NEXTVAL, 0);
INSERT INTO Accounts VALUES (Accounts_seq.NEXTVAL, 0);
INSERT INTO Accounts VALUES (Accounts_seq.NEXTVAL, 0);
INSERT INTO Accounts VALUES (Accounts_seq.NEXTVAL, 0);
INSERT INTO Accounts VALUES (Accounts_seq.NEXTVAL, 0);

INSERT INTO Owns VALUES (10002, 1000001);
INSERT INTO Owns VALUES (10003, 1000002);
INSERT INTO Owns VALUES (10003, 1000003);
INSERT INTO Owns VALUES (10004, 1000002);
INSERT INTO Owns VALUES (10004, 1000003);
INSERT INTO Owns VALUES (10005, 1000004);
INSERT INTO Owns VALUES (10005, 1000005);
INSERT INTO Owns VALUES (10006, 1000006);
INSERT INTO Owns VALUES (10007, 1000001); --Error join non-existing client to account
INSERT INTO Owns VALUES (10001, 1000007); --ERROR join client to non-existing account

--Dates changed to ISO format

--ERROR no such TxType
INSERT INTO Transactions VALUES (Transactions_seq.NEXTVAL, 'X', 1000001, 123.45, TO_DATE('2019-05-01', 'yyyy-mm-dd'), '12:00', 101, 0); --ERROR no such TxType

--ERROR non-existing Account
INSERT INTO Transactions VALUES (Transactions_seq.NEXTVAL, 'D', 1000000, 234.56, TO_DATE('2019-05-01', 'yyyy-mm-dd'), '12:00', 101, 0); --ERROR non-existing Account

--ERROR no such Branch
INSERT INTO Transactions VALUES (Transactions_seq.NEXTVAL, 'D', 1000001, 345.67, TO_DATE('2019-05-01', 'yyyy-mm-dd'), '12:00', 111, 0); --ERROR no such Branch

INSERT INTO Transactions VALUES (Transactions_seq.NEXTVAL, 'D', 1000001, 100.00, TO_DATE('2019-05-01', 'yyyy-mm-dd'), '10:00', 101, 100.00);
INSERT INTO Transactions VALUES (Transactions_seq.NEXTVAL, 'D', 1000001, 200.00, TO_DATE('2019-05-11', 'yyyy-mm-dd'), '11:00', 101, 300.00);
INSERT INTO Transactions VALUES (Transactions_seq.NEXTVAL, 'D', 1000001, 300.00, TO_DATE('2019-05-21', 'yyyy-mm-dd'), '12:00', 101, 600.00);
INSERT INTO Transactions VALUES (Transactions_seq.NEXTVAL, 'W', 1000001, 50.00, TO_DATE('2009-05-29', 'yyyy-mm-dd'), '10:00', 102, 550.00);
INSERT INTO Transactions VALUES (Transactions_seq.NEXTVAL, 'W', 1000001, 75.00, TO_DATE('2009-05-29', 'yyyy-mm-dd'), '11:00', 103, 475.00);
INSERT INTO Transactions VALUES (Transactions_seq.NEXTVAL, 'D', 1000001, 123.45, TO_DATE('2019-06-15', 'yyyy-mm-dd'), '13:00', 101, 598.45);
	
INSERT INTO Transactions VALUES (Transactions_seq.NEXTVAL, 'D', 1000002, 1000.00, TO_DATE('2019-05-15', 'yyyy-mm-dd'), '9:00', 104, 1000.00);
INSERT INTO Transactions VALUES (Transactions_seq.NEXTVAL, 'W', 1000002, 456.78, TO_DATE('2019-05-15', 'yyyy-mm-dd'), '9:05', 104, 543.22);
INSERT INTO Transactions VALUES (Transactions_seq.NEXTVAL, 'D', 1000003, 456.78, TO_DATE('2019-05-15', 'yyyy-mm-dd'), '9:10', 104, 456.78);
INSERT INTO Transactions VALUES (Transactions_seq.NEXTVAL, 'W', 1000003, 500.00, TO_DATE('2019-05-18', 'yyyy-mm-dd'), '14:00', 104, -43.22);
INSERT INTO Transactions VALUES (Transactions_seq.NEXTVAL, 'D', 1000003, 100.00, TO_DATE('2019-05-20', 'yyyy-mm-dd'), '13:00', 104, 56.78);
INSERT INTO Transactions VALUES (Transactions_seq.NEXTVAL, 'P', 1000003, 65.78, TO_DATE('2019-05-20', 'yyyy-mm-dd'), '14:50', 304, -9.00);
INSERT INTO Transactions VALUES (Transactions_seq.NEXTVAL, 'B', 1000002, 100.00, TO_DATE('2019-05-21', 'yyyy-mm-dd'), '9:00', 301, 443.22);
INSERT INTO Transactions VALUES (Transactions_seq.NEXTVAL, 'P', 1000002, 200.00, TO_DATE('2019-05-21', 'yyyy-mm-dd'), '10:00', 302, 243.22);
INSERT INTO Transactions VALUES (Transactions_seq.NEXTVAL, 'R', 1000002, 50.00, TO_DATE('2019-05-26', 'yyyy-mm-dd'), '12:34', 301, 293.22);

--Transaction 19 skipped in provided table
--INSERT INTO Transactions VALUES (Transactions_seq.NEXTVAL, '', NULL, NULL, '', '', NULL, NULL);
	
INSERT INTO Transactions VALUES (Transactions_seq.NEXTVAL, 'D', 1000004, 2000.00, TO_DATE('2019-06-01', 'yyyy-mm-dd'), '13:00', 101, 2000.00);
INSERT INTO Transactions VALUES (Transactions_seq.NEXTVAL, 'D', 1000005, 2000.00, TO_DATE('2019-06-01', 'yyyy-mm-dd'), '13:00', 101, 2000.00);
INSERT INTO Transactions VALUES (Transactions_seq.NEXTVAL, 'D', 1000005, 2000.00, TO_DATE('2019-06-01', 'yyyy-mm-dd'), '14:00', 102, 4000.00);
INSERT INTO Transactions VALUES (Transactions_seq.NEXTVAL, 'B', 1000005, 3456.78, TO_DATE('2019-06-10', 'yyyy-mm-dd'), '12:00', 301, 543.22);
INSERT INTO Transactions VALUES (Transactions_seq.NEXTVAL, 'B', 1000005, 432.10, TO_DATE('2019-06-15', 'yyyy-mm-dd'), '14:30', 302, 111.12);
INSERT INTO Transactions VALUES (Transactions_seq.NEXTVAL, 'B', 1000005, 100.00, TO_DATE('2019-06-20', 'yyyy-mm-dd'), '15:55', 303, 11.12);
INSERT INTO Transactions VALUES (Transactions_seq.NEXTVAL, 'B', 1000005, 80.00, TO_DATE('2019-06-25', 'yyyy-mm-dd'), '16:56', 304, -68.88);


