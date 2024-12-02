CREATE TABLE Suppliers (
    SupplierID SERIAL PRIMARY KEY,
    Name VARCHAR(255) NOT NULL,
    ContactInfo VARCHAR(255),
    Address TEXT
);

-- Relationship: SupplierBooks
CREATE TABLE SupplierBooks (
    SupplierID INT REFERENCES Suppliers(SupplierID),
    BookID SERIAL REFERENCES Books(BookID),
    SupplyPrice DECIMAL(10, 2),
    PRIMARY KEY (SupplierID, BookID)
);