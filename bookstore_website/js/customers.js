const customers = [
    { firstName: "John", lastName: "Doe", email: "john.doe@example.com", phoneNumber: "123-456-7890", address: "123 Elm St", membershipStatus: "Platinum" },
    { firstName: "Jane", lastName: "Smith", email: "jane.smith@example.com", phoneNumber: "987-654-3210", address: "456 Oak Ave", membershipStatus: "Gold" },
    { firstName: "Jim", lastName: "Brown", email: "jim.brown@example.com", phoneNumber: "555-123-4567", address: "789 Pine Rd", membershipStatus: "Silver" },
    { firstName: "Sarah", lastName: "Johnson", email: "sarah.johnson@example.com", phoneNumber: "555-765-4321", address: "101 Maple Dr", membershipStatus: "Gold" },
    { firstName: "Michael", lastName: "Williams", email: "michael.williams@example.com", phoneNumber: "555-234-5678", address: "202 Birch St", membershipStatus: "Platinum" },
    { firstName: "Emily", lastName: "Davis", email: "emily.davis@example.com", phoneNumber: "555-876-5432", address: "303 Cedar Ave", membershipStatus: "Bronze" },
    { firstName: "David", lastName: "Miller", email: "david.miller@example.com", phoneNumber: "555-678-9012", address: "404 Cherry Ln", membershipStatus: "Silver" },
    { firstName: "Laura", lastName: "Wilson", email: "laura.wilson@example.com", phoneNumber: "555-567-8901", address: "505 Willow St", membershipStatus: "Gold" },
    { firstName: "Christopher", lastName: "Moore", email: "chris.moore@example.com", phoneNumber: "555-234-8901", address: "606 Oak Dr", membershipStatus: "Silver" },
    { firstName: "Linda", lastName: "Taylor", email: "linda.taylor@example.com", phoneNumber: "555-987-6543", address: "707 Pine Ave", membershipStatus: "Bronze" },
    { firstName: "Alice", lastName: "King", email: "alice.king@example.com", phoneNumber: "555-345-6789", address: "808 Maple Rd", membershipStatus: "Gold" },
    { firstName: "Robert", lastName: "Adams", email: "robert.adams@example.com", phoneNumber: "555-765-4321", address: "909 Oak St", membershipStatus: "Platinum" },
    { firstName: "Olivia", lastName: "Lopez", email: "olivia.lopez@example.com", phoneNumber: "555-654-3210", address: "1010 Birch Ln", membershipStatus: "Silver" },
    { firstName: "Sophia", lastName: "Martinez", email: "sophia.martinez@example.com", phoneNumber: "555-543-2109", address: "1111 Cedar Ave", membershipStatus: "Bronze" },
    { firstName: "William", lastName: "Gonzalez", email: "william.gonzalez@example.com", phoneNumber: "555-432-1098", address: "1212 Pine Rd", membershipStatus: "Gold" },
    { firstName: "Liam", lastName: "Harris", email: "liam.harris@example.com", phoneNumber: "555-321-0987", address: "1313 Cherry St", membershipStatus: "Platinum" },
    { firstName: "Mia", lastName: "Clark", email: "mia.clark@example.com", phoneNumber: "555-210-9876", address: "1414 Oak Ln", membershipStatus: "Silver" },
    { firstName: "Ethan", lastName: "Rodriguez", email: "ethan.rodriguez@example.com", phoneNumber: "555-109-8765", address: "1515 Birch Dr", membershipStatus: "Gold" },
    { firstName: "Isabella", lastName: "Perez", email: "isabella.perez@example.com", phoneNumber: "555-098-7654", address: "1616 Willow Rd", membershipStatus: "Platinum" },
    { firstName: "James", lastName: "Lee", email: "james.lee@example.com", phoneNumber: "555-876-5432", address: "1717 Pine Ln", membershipStatus: "Silver" },
    { firstName: "Benjamin", lastName: "Graham", email: "benjamin.graham@example.com", phoneNumber: "555-765-4321", address: "1818 Maple St", membershipStatus: "Gold" },
    { firstName: "Charlotte", lastName: "Nelson", email: "charlotte.nelson@example.com", phoneNumber: "555-654-3210", address: "1919 Cedar Ln", membershipStatus: "Bronze" },
    { firstName: "Amelia", lastName: "Carter", email: "amelia.carter@example.com", phoneNumber: "555-543-2109", address: "2020 Oak Rd", membershipStatus: "Gold" },
    { firstName: "Jackson", lastName: "Mitchell", email: "jackson.mitchell@example.com", phoneNumber: "555-432-1098", address: "2121 Birch Ave", membershipStatus: "Silver" },
    { firstName: "Avery", lastName: "Perez", email: "avery.perez@example.com", phoneNumber: "555-321-0987", address: "2222 Pine Ave", membershipStatus: "Bronze" },
    { firstName: "Lucas", lastName: "Evans", email: "lucas.evans@example.com", phoneNumber: "555-210-9876", address: "2323 Willow Ln", membershipStatus: "Gold" },
    { firstName: "Harper", lastName: "Hughes", email: "harper.hughes@example.com", phoneNumber: "555-109-8765", address: "2424 Maple Ave", membershipStatus: "Platinum" },
    { firstName: "Mason", lastName: "Hall", email: "mason.hall@example.com", phoneNumber: "555-876-5432", address: "2525 Oak Ave", membershipStatus: "Gold" },
    { firstName: "Ella", lastName: "Young", email: "ella.young@example.com", phoneNumber: "555-765-4321", address: "2626 Cedar St", membershipStatus: "Silver" },
    { firstName: "Scarlett", lastName: "Walker", email: "scarlett.walker@example.com", phoneNumber: "555-654-3210", address: "2727 Pine St", membershipStatus: "Bronze" },
    { firstName: "Chloe", lastName: "Allen", email: "chloe.allen@example.com", phoneNumber: "555-543-2109", address: "2828 Birch Rd", membershipStatus: "Gold" },
    { firstName: "Lily", lastName: "Scott", email: "lily.scott@example.com", phoneNumber: "555-432-1098", address: "2929 Cedar Ave", membershipStatus: "Silver" },
    { firstName: "Sebastian", lastName: "Gonzalez", email: "sebastian.gonzalez@example.com", phoneNumber: "555-321-0987", address: "3030 Oak Ln", membershipStatus: "Bronze" },
    { firstName: "Zoe", lastName: "Simmons", email: "zoe.simmons@example.com", phoneNumber: "555-210-9876", address: "3131 Pine Rd", membershipStatus: "Platinum" }
];

const rowsPerPage = 10;
let currentPage = 1;
let filteredCustomers = customers; 

function loadTableData(page = 1) {
    const tableBody = document.getElementById("customerTableBody");
    tableBody.innerHTML = "";  

    const startIndex = (page - 1) * rowsPerPage;
    const paginatedCustomers = filteredCustomers.slice(startIndex, startIndex + rowsPerPage);

    paginatedCustomers.forEach(customer => {
        const row = document.createElement("tr");
        row.innerHTML = `
            <td>${customer.firstName}</td>
            <td>${customer.lastName}</td>
            <td>${customer.email}</td>
            <td>${customer.phoneNumber}</td>
            <td>${customer.address}</td>
            <td>${customer.membershipStatus}</td>
        `;
        tableBody.appendChild(row);
    });
}

function searchCustomers() {
    const searchTerm = document.getElementById("searchBar").value.toLowerCase();
    filteredCustomers = customers.filter(customer =>
        customer.firstName.toLowerCase().includes(searchTerm) ||
        customer.lastName.toLowerCase().includes(searchTerm) ||
        customer.email.toLowerCase().includes(searchTerm) ||
        customer.phoneNumber.includes(searchTerm) ||
        customer.address.toLowerCase().includes(searchTerm) ||
        customer.membershipStatus.toLowerCase().includes(searchTerm)
    );
    currentPage = 1; 
    loadTableData(currentPage);
}

function nextPage() {
    if ((currentPage * rowsPerPage) < filteredCustomers.length) {
        currentPage++;
        loadTableData(currentPage);
    }
}

function prevPage() {
    if (currentPage > 1) {
        currentPage--;
        loadTableData(currentPage);
    }
}

loadTableData();