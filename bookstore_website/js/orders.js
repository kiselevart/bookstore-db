document.addEventListener('DOMContentLoaded', function () {
    // Get the order history container
    const orderHistoryTableBody = document.getElementById('orderHistoryTableBody');

    // Retrieve order history from localStorage
    const orderHistory = JSON.parse(localStorage.getItem('orderHistory')) || [];

    if (orderHistory.length > 0) {
        // Iterate through each order and populate the table
        orderHistory.sort((a, b) => new Date(b.orderDate) - new Date(a.orderDate));
        
        orderHistory.forEach(order => {
            const row = document.createElement('tr');

            // Format book titles with quantities
            const booksFormatted = order.books
                .map(book => `${book.title} x ${book.quantity}`)
                .join('<br>'); // Join with line breaks for better readability

            // Populate the table row
            row.innerHTML = `
                <td>${order.fullName}</td>
                <td>${order.address}</td>
                <td>${maskCardNumber(order.cardNumber)}</td>
                <td>${order.expiryDate}</td>
                <td>${booksFormatted}</td>
                <td>${order.orderDate || 'N/A'}</td>
            `;

            orderHistoryTableBody.appendChild(row);
        });
    } else {
        // If no orders, display a message
        const noOrdersRow = document.createElement('tr');
        noOrdersRow.innerHTML = `
            <td colspan="6" class="text-center">No orders found in your history.</td>
        `;
        orderHistoryTableBody.appendChild(noOrdersRow);
    }
});

/**
 * Masks the card number except the last 4 digits.
 * Example: 1234 5678 9012 3456 -> **** **** **** 3456
 */
function maskCardNumber(cardNumber) {
    try {
        // Check if cardNumber is null, undefined, or not valid
        if (cardNumber == null || cardNumber === "") {
            throw new Error("Invalid card number provided");
        }

        // Convert cardNumber to a string if it's not already
        const normalizedCardNumber = String(cardNumber).replace(/\D/g, '');

        // Apply masking to all but the last 4 digits
        const maskedCardNumber = normalizedCardNumber.replace(/\d(?=\d{4})/g, '*');

        // Add spaces for readability
        return maskedCardNumber.replace(/(.{4})/g, '$1 ').trim();
    } catch (error) {
        console.error("Error in maskCardNumber:", error.message);
        return "Invalid Card Number";
    }
}
