document.addEventListener("DOMContentLoaded", function () {
    // This ensures that the DOM is fully loaded before you manipulate it
    console.log("DOM fully loaded and parsed!");

    // You can safely access DOM elements now
    const searchBar = document.getElementById("searchBar");
    if (searchBar) {
        searchBar.addEventListener("input", filterTable);
    } else {
        console.error("Search bar element not found!");
    }
});


// Retrieve books from localStorage
const storedBooks = JSON.parse(localStorage.getItem("books"));
console.log("Books loaded from localStorage:", storedBooks);
let filteredInventory = storedBooks; // Default to show all books

const rowsPerPage = 10;
let currentPage = 1;

function loadTableData(page = 1) {
    console.log("Loading data from filteredInventory...");
    const tableBody = document.getElementById("tableBody");
    tableBody.innerHTML = ""; // Clear existing rows

    const startIndex = (page - 1) * rowsPerPage;
    const endIndex = startIndex + rowsPerPage;
    const paginatedItems = filteredInventory.slice(startIndex, endIndex);

    if (paginatedItems.length === 0) {
        const noDataRow = document.createElement("tr");
        const noDataCell = document.createElement("td");
        noDataCell.colSpan = 7;
        noDataCell.className = "text-center";
        noDataCell.textContent = "No books found.";
        noDataRow.appendChild(noDataCell);
        tableBody.appendChild(noDataRow);
        return;
    }

    paginatedItems.forEach(item => {
        const row = document.createElement("tr");
        for (const key in item) {
            const cell = document.createElement("td");
            cell.textContent = item[key];
            row.appendChild(cell);
        }
        tableBody.appendChild(row);
    });

    updatePagination();
}

function updatePagination() {
    console.log("Updating pagination...");
    const pagination = document.getElementById("pagination");
    pagination.innerHTML = ""; // Clear pagination

    const totalPages = Math.ceil(filteredInventory.length / rowsPerPage);

    for (let i = 1; i <= totalPages; i++) {
        const button = document.createElement("button");
        button.textContent = i;
        button.className = i === currentPage ? "btn btn-primary mx-1 active" : "btn btn-secondary mx-1";
        button.onclick = () => {
            currentPage = i;
            loadTableData(currentPage); // Reload table
        };
        pagination.appendChild(button);
    }
}

function filterTable() {
    // console.log("filterTable called");
    const searchValue = document.getElementById("searchBar").value.toLowerCase().trim();
    console.log("Search Value:", searchValue);

    filteredInventory = books.filter(item =>
        Object.values(item).some(value =>
            value.toString().toLowerCase().includes(searchValue)
        )
    );

    console.log("Filtered Inventory:", filteredInventory);
    currentPage = 1; // Reset to the first page
    loadTableData(currentPage); // Reload the table
}

document.addEventListener("DOMContentLoaded", () => {
    loadTableData(currentPage); // Initial load
});