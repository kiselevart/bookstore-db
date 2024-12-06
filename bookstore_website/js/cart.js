document.addEventListener("DOMContentLoaded", function () {
    console.log(localStorage.books);
    let cartItems = JSON.parse(localStorage.getItem("cartItems")) || [];
    // const cartItems = [
    //     { id: 1, name: "The Great Gatsby", price: 10.99, quantity: 1, img: "../icons/the-great-gatsby.jfif" },
    //     { id: 2, name: "To Kill a Mockingbird", price: 12.99, quantity: 2, img: "../icons/to-kill-a-mockingbird.jfif" },
    //     { id: 3, name: "1984", price: 8.99, quantity: 1, img: "../icons/1984.jfif" },
    //     { id: 4, name: "Moby Dick", price: 15.99, quantity: 1, img: "../icons/moby-dick.jfif" },
    //     { id: 5, name: "War and Peace", price: 20.99, quantity: 1, img: "../icons/war-and-peace.jfif" }
    // ];

    let cartItemsContainer = document.getElementById("cartItems");
    const totalPriceElement = document.getElementById("totalPrice");
    const orderNowButton = document.getElementById("orderNowButton");

    function displayCartItems(items) {
        cartItemsContainer.innerHTML = ""; // Clear existing rows
    
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
                <td><img src="${item.img}" alt="${item.name}" style="width: 75px; height: 100px; object-fit: cover;"></td>
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
        attachEventListeners(); // Ensure event listeners are added to the updated DOM
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
        // Get the itemId from the input field
        const itemId = event.target.getAttribute("data-id");
        const newQuantity = parseInt(event.target.value);
        
        // Ensure the quantity is valid
        if (newQuantity <= 0 || isNaN(newQuantity)) {
            return; // Ignore invalid input
        }
    
        // Get the cartItems array from localStorage
        let cartItems = JSON.parse(localStorage.getItem("cartItems")) || [];
        const itemIndex = cartItems.findIndex(item => item.id === itemId);
        
        if (itemIndex !== -1) {
            // Update the quantity of the item
            cartItems[itemIndex].quantity = newQuantity;
            
            // Update the localStorage with the new cartItems array
            localStorage.setItem("cartItems", JSON.stringify(cartItems));
    
            // Immediately reflect the updated cart in the display by calling displayCartItems
            displayCartItems(cartItems);
        } else {
            console.error("Item not found in cart");
        }
    }
    

    function removeItem(event) {
        // Log the cartItems from localStorage before starting the removal
        console.log("Cart items from localStorage:", localStorage.getItem("cartItems"));
    
        // Retrieve cartItems from localStorage (in case the user has updated the cart in another part of the code)
        let cartItems = JSON.parse(localStorage.getItem("cartItems")) || [];
    
        // Get the itemId from the button or link that triggered the event
        const itemId = event.target.getAttribute("data-id");
    
        // Find the index of the item to remove
        const itemIndex = cartItems.findIndex((item) => item.id === itemId);
    
        if (itemIndex !== -1) {
            // Remove the item from the array
            cartItems.splice(itemIndex, 1);
    
            // Log the updated cartItems
            console.log("Updated cartItems:", cartItems);
    
            // Update the localStorage with the new cartItems array
            localStorage.setItem("cartItems", JSON.stringify(cartItems));
    
            // Update the display of cart items
            displayCartItems(cartItems);
    
            // Show a notification for successful removal
            notification.classList.remove("d-none", "alert-success");
            notification.classList.add("alert-danger");
    
            // Hide the notification after 3 seconds
            setTimeout(() => {
                notification.classList.add("d-none");
            }, 3000);
        } else {
            // Log if the item wasn't found (optional debugging)
            console.error("Item not found in cart");
        }
    }    

    displayCartItems(cartItems);
    console.log("cart is fully updated.");

    document.getElementById("orderNow").addEventListener("click", function () {
        if (cartItems.length === 0) {
            alert("Your cart is empty.");
            return;
        }

        // Save cart items to localStorage
        localStorage.setItem("cartItems", JSON.stringify(cartItems));
            
        console.log("Cart data saved to localStorage:", localStorage.getItem("cartItems"));
 
        // alert("Redirecting to payment...");
        window.location.href = "payment.html";
    });

    // // Clear the cart data after successful payment
    // localStorage.removeItem('cartItems');
});
