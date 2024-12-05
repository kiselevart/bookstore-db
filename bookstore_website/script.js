// Cart functionality
let cartCount = 0;

// Simulate adding an item to the cart
document.querySelector(".cart-icon img").addEventListener("click", (event) => {
    cartCount++;
    document.getElementById("cartCount").textContent = cartCount;
});

// Search bar functionality
document.getElementById("searchBar").addEventListener("input", (event) => {
    const query = event.target.value.trim().toLowerCase();
    console.log(`User is searching for: ${query}`);
    // Add logic here to handle search results (e.g., filter book list)
});
