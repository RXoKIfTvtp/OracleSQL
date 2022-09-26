
/**
 * Queries
**/

/* List of only the Accounts that have multiple Clients associated */
SELECT a.AccountNbr, a.Balance FROM Accounts a JOIN (
    SELECT AccountNbr, COUNT(*) AS cnt
    FROM Owns
    GROUP BY AccountNbr
    HAVING COUNT(*) > 1
    ORDER BY AccountNbr
) t ON a.AccountNbr = t.AccountNbr ORDER BY AccountNbr
;

/*
Provide an alphabetic list by last name of all Clients showing their full name (e.g., Bob Barlow),
with the number of Accounts they hold
and the total balance of those Accounts */
SELECT DISTINCT TRIM(BOTH ' ' FROM x.FName) || ' ' || TRIM(BOTH ' ' FROM x.LName), y.cnt, y.bal, x.ClientNbr
FROM (
    SELECT c.ClientNbr, a.Balance, c.FName, c.LName FROM Accounts a, Clients c, Owns o WHERE o.ClientNbr = c.ClientNbr AND o.AccountNbr = a.AccountNbr
) x JOIN (
    SELECT t.ClientNbr, SUM(Balance) AS bal, COUNT(*) AS cnt
    FROM (
        SELECT c.ClientNbr, a.Balance, c.FName, c.LName FROM Accounts a, Clients c, Owns o WHERE o.ClientNbr = c.ClientNbr AND o.AccountNbr = a.AccountNbr
    ) t
    GROUP BY t.ClientNbr
    ORDER BY ClientNbr
) y ON x.ClientNbr = y.ClientNbr
ORDER BY ClientNbr
;

/* Provide a count and total amount of Transactions for each Type description */
SELECT y.cnt, y.bal, x.Description FROM TX_TYPE x JOIN (
    SELECT t.TxCode, SUM(Amount) AS bal, COUNT(*) AS cnt
        FROM Transactions t
        GROUP BY t.TxCode
        ORDER BY TxCode
) y ON x.Code = y.TxCode;


