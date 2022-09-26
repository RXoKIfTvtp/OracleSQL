
/**
 * Create sequences
**/

CREATE SEQUENCE Clients_seq
MINVALUE 10001
MAXVALUE 99999
START WITH 10001
INCREMENT BY 1
NOCACHE
NOCYCLE;

CREATE SEQUENCE Accounts_seq
MINVALUE 1000001
MAXVALUE 9999999
START WITH 1000001
INCREMENT BY 1
NOCACHE
NOCYCLE;

CREATE SEQUENCE Transactions_seq
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;


/**
 * Create all tables
**/

CREATE TABLE Clients (
	ClientNbr INTEGER NOT NULL CHECK (ClientNbr > 10000 AND ClientNbr < 100000),
	FName CHAR(255),
	LName CHAR(255),
	Street CHAR(255),
	City CHAR(255),
	Prov CHAR(255),
	PostCd CHAR(255),
	Phone CHAR(255),
	Email CHAR(255),
	PRIMARY KEY (ClientNbr)
);

CREATE TABLE Accounts (
	AccountNbr INTEGER NOT NULL CHECK (AccountNbr > 1000000 AND AccountNbr < 10000000),
	Balance DECIMAL(15, 2) DEFAULT 0.00,
	PRIMARY KEY (AccountNbr)
);

CREATE TABLE Owns (
	ClientNbr INTEGER CHECK (ClientNbr > 10000 AND ClientNbr < 100000),
	AccountNbr INTEGER CHECK (AccountNbr > 1000000 AND AccountNbr < 10000000),
	FOREIGN KEY (ClientNbr) REFERENCES Clients (ClientNbr) ON DELETE CASCADE,
	FOREIGN KEY (AccountNbr) REFERENCES Accounts (AccountNbr) ON DELETE CASCADE,
	PRIMARY KEY (ClientNbr, AccountNbr)
);

CREATE TABLE Branch (
	Nbr INTEGER NOT NULL CHECK (Nbr > 100),
	Name CHAR(255),
	PRIMARY KEY (Nbr)
);

CREATE TABLE Merchant (
	Nbr INTEGER NOT NULL CHECK (Nbr > 300),
	Name CHAR(255),
	PRIMARY KEY (Nbr)
);

CREATE TABLE TX_TYPE (
	Code CHAR(1) NOT NULL,
	Description CHAR(255),
	PRIMARY KEY (Code)
);

CREATE TABLE Transactions (
	TxNbr INTEGER NOT NULL,
	TxCode CHAR(1) CHECK (TxCode IN ('D', 'W', 'B', 'P', 'R')),
	AccountNbr INTEGER NOT NULL CHECK (AccountNbr > 1000000 AND AccountNbr < 10000000),
	Amount DECIMAL(15, 2) NOT NULL,
	TxDate DATE NOT NULL,
	TxTime CHAR(8) NOT NULL, 
	RefNbr INTEGER NOT NULL,
	Balance DECIMAL(15, 2) NOT NULL,
	FOREIGN KEY (TxCode) REFERENCES TX_TYPE (Code) ON DELETE SET NULL,
	FOREIGN KEY (AccountNbr) REFERENCES Accounts (AccountNbr) ON DELETE CASCADE,
	PRIMARY KEY (TxNbr)
);

/**
 * Create Views
**/

/* Join of Transaction to Type description */
CREATE VIEW DescribedTransactions AS
SELECT * FROM Transactions tx, TX_TYPE tt WHERE tx.TxCode = tt.Code;
/*SELECT tx.TxNbr, tx.TxCode, tx.AccountNbr, tx.Amount, tx.TxDate, tx.TxTime, tx.RefNbr, tx.Balance, tt.Description FROM Transactions tx, TX_TYPE tt WHERE tx.TxCode = tt.Code;*/

/* Join of Client to Account via the Owns table, containing the client’s number, name, the account number, and balance. */
CREATE VIEW ClientAccounts AS
SELECT c.ClientNbr, c.FName, c.LName, a.AccountNbr, a.Balance FROM Clients c, Owns o, Accounts a WHERE c.ClientNbr = o.ClientNbr AND o.AccountNbr = a.AccountNbr;

/* Join of Deposit and Withdraw transactions to Bank Branch UNION with join of Bill Payment and Debit Purchase or return transactions to merchant */
CREATE VIEW BranchTransactions AS
SELECT * FROM Transactions t, Branch b WHERE (t.TxCode = 'D' OR t.TxCode = 'W')
    UNION
SELECT t.TxNbr, t.TxCode, t.AccountNbr, t.Amount, t.TxDate, t.TxTime, t.RefNbr, t.Balance, m.Nbr, m.Name FROM Transactions t, Merchant m WHERE (t.TxCode = 'B' OR t.TxCode = 'P' OR t.TxCode = 'R')
;


/**
 * Create PL/SQL (Triggers and Procedure)
**/

--To display output from plsql
SET SERVEROUTPUT ON;

/* 
	Trigger to enforce the referential integrity for the Transaction Ref_Nbr: (3 marks) 
		> Deposit or Withdrawal transaction to Bank Branch
		> Bill Payment, Debit Purchase, or Return transaction to Merchant
 */
CREATE OR REPLACE TRIGGER
Transaction_Integrity_Trigger
BEFORE INSERT
ON Transactions
FOR EACH ROW
--Default should be enabled but just in case...
ENABLE
DECLARE
    flub INTEGER;
BEGIN
    --Check if Branch exists
    IF (:NEW.TxCode = 'D' OR :NEW.TxCode = 'W') THEN
        --Check if Branch exists
        SELECT COUNT(*) INTO flub FROM Branch b WHERE b.Nbr = :NEW.RefNbr;
        IF (flub < 1) THEN
            --Because PL/SQL is dumb the only way to prevent an insert is an application error
            RAISE_APPLICATION_ERROR(-20001, 'Branch doesn''t exist.');
        ELSE
            --DBMS_OUTPUT.PUT_LINE('Branch exists.');
            NULL;
        END IF;
    --Check if Merchant exists
    ELSIF (:NEW.TxCode = 'B' OR :NEW.TxCode = 'P' OR :NEW.TxCode = 'R') THEN
        --Check if Merchant exists
        SELECT COUNT(*) INTO flub FROM Merchant m WHERE m.Nbr = :NEW.RefNbr;
        IF (flub < 1) THEN
            --Because PL/SQL is dumb the only way to prevent an insert is an application error
            RAISE_APPLICATION_ERROR(-20002, 'Merchant doesn''t exist.');
        ELSE
            --DBMS_OUTPUT.PUT_LINE('Merchant exists.');
            NULL;
        END IF;
    --Anything else is automatically invalid
    ELSE
        --Because PL/SQL is dumb the only way to prevent an insert is an application error
        RAISE_APPLICATION_ERROR(-20003, 'Transaction code doesn''t match type.');
    END IF;
END;
--For some stupid reason PL/SQL needs a slash after a multi-line trigger
/


/* 
Trigger to update the Account balance for each new transaction entered (assume that a transaction will never be updated or deleted).
 */
CREATE OR REPLACE TRIGGER
Amount_Update_Trigger
AFTER INSERT
ON Transactions
FOR EACH ROW
--Default should be enabled but just in case...
ENABLE
DECLARE
    flub INTEGER;
BEGIN
    --DBMS_OUTPUT.PUT_LINE('Amount:'||:NEW.Amount);
    SELECT Balance INTO flub FROM Accounts a WHERE a.AccountNbr = :NEW.AccountNbr;
    --DBMS_OUTPUT.PUT_LINE('Balance'||flub);
    flub := flub + :NEW.Amount;
    --DBMS_OUTPUT.PUT_LINE('New Balance'||flub);
    UPDATE Accounts SET Balance = flub WHERE Accounts.AccountNbr = :NEW.AccountNbr;
    
    --SELECT Balance INTO flub FROM Accounts a WHERE a.AccountNbr = :NEW.AccountNbr;
    --DBMS_OUTPUT.PUT_LINE('New Balance double check'||flub);
END;
/

/* 
 A procedure that displays a nicely formatted audit statement for a given account number (as a parameter). This will show each transaction in date / time sequence along with the running balance.
 */
 CREATE OR REPLACE PROCEDURE ShowAccount(acc IN INTEGER)
 AS
    glub INTEGER;
 BEGIN
    SELECT Balance INTO glub FROM Accounts a WHERE a.AccountNbr = acc;
    DBMS_OUTPUT.PUT_LINE('Account: '||acc);
    DBMS_OUTPUT.PUT_LINE('Balance: '||glub);
    for o in (
        SELECT * FROM Transactions t WHERE t.AccountNbr = acc
    ) LOOP
        DBMS_OUTPUT.PUT_LINE(LPAD(o.TxNbr, 15)||'  '||LPAD(o.Amount, 17)||'   '||o.TxTime||'   '||o.TxDate||'   '||LPAD(o.Balance, 17));
    END LOOP;
 END;
 /


