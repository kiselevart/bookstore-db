document.addEventListener('DOMContentLoaded', function() {
    // Retrieve payment details from localStorage
    const paymentDetails = JSON.parse(localStorage.getItem('paymentDetails'));

    if (paymentDetails) {
        const receiptContainer = document.getElementById('receiptDetails');
        
        receiptContainer.innerHTML = `
            <p><strong>Full Name:</strong> ${paymentDetails.fullName}</p>
            <p><strong>Address:</strong> ${paymentDetails.address}</p>
            <p><strong>Card Number:</strong> ${paymentDetails.cardNumber}</p>
            <p><strong>Expiry Date:</strong> ${paymentDetails.expiryDate}</p>
        `;
    } else {
        // If no payment details, redirect to the payment page
        window.location.href = "../views/payment.html";
    }
    localStorage.clear("cartItems");
});
