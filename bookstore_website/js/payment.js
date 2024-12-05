document.addEventListener('DOMContentLoaded', function() {
    const cartItems = JSON.parse(localStorage.getItem("cartItems"));

    if (cartItems && cartItems.length > 0) {
        const orderSummaryContainer = document.getElementById("orderSummary");
        let totalPrice = 0;

        // Loop through the cart items and create order summary
        cartItems.forEach(item => {
            const itemRow = document.createElement("tr");

            // Populate item details in the order summary
            itemRow.innerHTML = `
            <td>${item.name}</td>
            <td>${item.quantity}</td>
            <td>$${(item.price * item.quantity).toFixed(2)}</td>
            `;
            orderSummaryContainer.appendChild(itemRow);


            // Update the total price
            totalPrice += item.price * item.quantity;
        });

        // Display total price
        const totalPriceElement = document.getElementById("totalPrice");
        totalPriceElement.textContent = totalPrice.toFixed(2);
    } else {
        // If no items, redirect to cart page or show a message
        window.location.href = "cart.html";
    }

    
    // Handle form submission
    document.getElementById('paymentForm').addEventListener('submit', function(e) {
        e.preventDefault();

        // Collect payment details
        const fullName = document.getElementById('fullName').value.trim();
        const address = document.getElementById('address').value.trim();
        const cardNumber = document.getElementById('cardNumber').value.trim();
        const expiryDate = document.getElementById('expiryDate').value.trim();

        // Create the order object
        const order = {
            fullName: fullName,
            address: address,
            cardNumber: cardNumber,
            expiryDate: expiryDate,
            books: cartItems.map(item => ({
                title: item.title || item.name, // Support both title and name
                quantity: item.quantity
            })),
            orderDate: new Date().toISOString().split('T')[0]
        };

        // Get existing order history from localStorage or initialize as an empty array
        let orderHistory = JSON.parse(localStorage.getItem("orderHistory")) || [];

        // Add the new order to the order history
        orderHistory.push(order);

        // Save updated order history to localStorage
        localStorage.setItem("orderHistory", JSON.stringify(orderHistory));

        // Optionally, clear the cart
        localStorage.removeItem("cartItems");

        // Redirect to order confirmation page
        window.location.href = "orders.html";
    });
});

