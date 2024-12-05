document.addEventListener("DOMContentLoaded", function () {
    console.log(localStorage.books); // Check if localStorage.books is present

    // Get the notification container and hide it initially
    const notification = document.getElementById("notification");
    const notificationMessage = document.getElementById("notificationMessage");

    // Retrieve books and cartItems from localStorage and parse them
    const books = JSON.parse(localStorage.getItem("books")) || [];
    const cartItems = JSON.parse(localStorage.getItem("cartItems")) || [];

    console.log("Books from localStorage:", books); // Log the books data to check it's correct

    // Add to Cart Button Handler
    const addToCartButtons = document.querySelectorAll(".add-to-cart-btn");
    addToCartButtons.forEach(button => {
        button.addEventListener("click", function () {
            const itemId = button.getAttribute("data-id"); // Ensure itemId is a string
            const itemName = button.getAttribute("data-name");
            const itemPrice = parseFloat(button.getAttribute("data-price"));
            const itemImg = button.getAttribute("data-img");

            // Log itemId to check what value is being passed
            console.log("itemId from button:", itemId);

            // Find the book in the inventory (from localStorage)
            const book = books.find(b => b.ISBN === itemId); // Ensure the comparison uses strings

            // Log the result of the find operation
            console.log("Found book:", book);

            if (!book) {
                // If book is not found in the inventory, exit the function
                console.error("Book not found in inventory!");
                return;
            }

            const itemStock = book.StockQuantity; // Get the current stock from the localStorage book

            // Gray out the button if the item is out of stock
            if (itemStock === 0) {
                button.classList.add("grayed-out"); // Add the grayed-out class
                button.setAttribute("disabled", "true"); // Optionally disable the button
                notificationMessage.textContent = "Item is out of stock!";
                notification.classList.remove("d-none");
                setTimeout(() => notification.classList.add("d-none"), 3000);
                return;
            } else {
                button.classList.remove("grayed-out"); // Remove the grayed-out class if in stock
                button.removeAttribute("disabled"); // Re-enable the button
            }

            // Check if item is already in the cart
            let item = cartItems.find(item => item.id === itemId);
            console.log("Item found:", item);

            if (item) {
                console.log("Current quantity:", item.quantity);
                // Check if there is enough stock to add another item
                if (item.quantity < itemStock) {
                    item.quantity += 1; // Increase quantity if there's enough stock
                    console.log("Updated quantity:", item.quantity);
                } else {
                    // Show notification for insufficient stock
                    notificationMessage.textContent = "Not enough stock available!";
                    notification.classList.remove("d-none");
                    setTimeout(() => notification.classList.add("d-none"), 3000);
                    return; // Exit if stock is insufficient
                }
            } else {
                if (itemStock > 0) {
                    // If item is new and there is stock, add it to the cart
                    cartItems.push({
                        id: itemId,
                        name: itemName,
                        price: itemPrice,
                        img: itemImg,
                        quantity: 1
                    });
                    console.log("New item added:", itemId);
                    
                    // Show notification for successful addition to cart
                    notificationMessage.textContent = `${itemName} added to cart!`;
                    notification.classList.remove("d-none");
                    setTimeout(() => notification.classList.add("d-none"), 3000);
                } else {
                    // Show notification for out-of-stock item
                    notificationMessage.textContent = "Item is out of stock!";
                    notification.classList.remove("d-none");
                    setTimeout(() => notification.classList.add("d-none"), 3000);
                    return; // Exit if out of stock
                }
            }

            // Update localStorage with the updated cart
            localStorage.setItem("cartItems", JSON.stringify(cartItems));

            // Update the inventory stock in localStorage
            const updatedBooks = books.map(book => {
                if (book.ISBN === itemId) { // Use ISBN for comparison
                    if (book.StockQuantity >= item.quantity) {
                        book.StockQuantity -= item.quantity; // Decrease stock based on quantity added to cart
                    } else {
                        console.error("Not enough stock to update");
                    }
                }
                return book;
            });

            // Save updated books inventory back to localStorage
            localStorage.setItem("books", JSON.stringify(updatedBooks));
        });
    });
});
