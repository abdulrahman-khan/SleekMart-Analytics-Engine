SELECT 
    CustomerID,
    FirstName,
    LastName,
    Email,
    Phone,
    Address,
    City,
    State,
    ZipCode,
    Updated_at,
    CONCAT(FIRSTNAME, ' ', LASTNAME) as CustomerName
FROM
    {{ source('landing', 'customers') }}