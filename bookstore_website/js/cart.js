document.addEventListener("DOMContentLoaded", function () {
    const cartItems = [
        { id: 1, name: "The Great Gatsby", price: 10.99, quantity: 1 },
        { id: 2, name: "To Kill a Mockingbird", price: 12.99, quantity: 2 },
        { id: 3, name: "1984", price: 8.99, quantity: 1 },
        { id: 4, name: "Moby Dick", price: 15.99, quantity: 1 },
        { id: 5, name: "War and Peace", price: 20.99, quantity: 1 }
    ];

    const cartItemsContainer = document.getElementById("cartItems");
    const totalPriceElement = document.getElementById("totalPrice");
    const orderNowButton = document.getElementById("orderNowButton");

    function displayCartItems(items) {
        cartItemsContainer.innerHTML = "";
        let totalPrice = 0;

        if (items.length === 0) {
            cartItemsContainer.innerHTML = `
                <tr>
                    <td colspan="5" class="text-center">No items found in your cart.</td>
                </tr>`;
            totalPriceElement.textContent = "0.00";
            return;
        }

        items.forEach((item) => {
            const itemRow = document.createElement("tr");
            totalPrice += item.price * item.quantity;

            itemRow.innerHTML = `
                <td>${item.name}</td>
                <td>
                    <input type="number" min="1" value="${item.quantity}" 
                           data-id="${item.id}" class="form-control quantity-input">
                </td>
                <td>$${item.price.toFixed(2)}</td>
                <td class="item-total">$${(item.price * item.quantity).toFixed(2)}</td>
                <td>
                    <button class="btn btn-danger btn-sm remove-btn" data-id="${item.id}">Remove</button>
                </td>
            `;
            cartItemsContainer.appendChild(itemRow);
        });

        totalPriceElement.textContent = totalPrice.toFixed(2);
        attachEventListeners();
    }

    function attachEventListeners() {
        const quantityInputs = document.querySelectorAll(".quantity-input");
        const removeButtons = document.querySelectorAll(".remove-btn");

        quantityInputs.forEach((input) => {
            input.addEventListener("change", updateQuantity);
        });

        removeButtons.forEach((button) => {
            button.addEventListener("click", removeItem);
        });
    }

    function updateQuantity(event) {
        const itemId = parseInt(event.target.getAttribute("data-id"));
        const newQuantity = parseInt(event.target.value);

        if (newQuantity < 1) return;

        const item = cartItems.find((item) => item.id === itemId);
        if (item) {
            item.quantity = newQuantity;
        }

        displayCartItems(cartItems);
    }

    function removeItem(event) {
        const itemId = parseInt(event.target.getAttribute("data-id"));

        const itemIndex = cartItems.findIndex((item) => item.id === itemId);
        if (itemIndex !== -1) {
            cartItems.splice(itemIndex, 1);
        }

        displayCartItems(cartItems);
    }

    displayCartItems(cartItems);

    orderNowButton.addEventListener("click", function () {
        if (cartItems.length === 0) {
            alert("Your cart is empty.");
            return;
        }

        alert("Redirecting to payment...");
        window.location.href = "payment.html";
    });
});
