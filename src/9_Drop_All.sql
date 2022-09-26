
/**
 * Drop all tables
**/

DROP TABLE Owns;
DROP TABLE Transactions;
DROP TABLE Clients;
DROP TABLE Accounts;

DROP TABLE Branch;
DROP TABLE Merchant;
DROP TABLE TX_TYPE;


/**
 * Drop all sequences
**/

DROP SEQUENCE Clients_seq;
DROP SEQUENCE Accounts_seq;
DROP SEQUENCE Transactions_seq;


/**
 * Drop all views
**/

DROP VIEW DescribedTransactions;
DROP VIEW ClientAccounts;
DROP VIEW BranchTransactions;


/**
 * Drop all triggers
**/

DROP TRIGGER Transaction_Integrity_Trigger;
DROP TRIGGER Amount_Update_Trigger;


/**
 * Drop all procedures
**/

DROP PROCEDURE ShowAccount;


