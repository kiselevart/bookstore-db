

document.addEventListener("DOMContentLoaded", () => {
    // Reference to the "Reset Inventory Stock" button
    const resetStockButton = document.getElementById("resetStockBtn");

    if (resetStockButton) {
        // Add event listener for button click
        resetStockButton.addEventListener("click", resetInventoryStock);
    } else {
        console.error("Reset stock button not found!");
    }

    function resetInventoryStock() {
        const defaultInventory = [
            { Title: "To Kill a Mockingbird", Author: "Harper Lee", ISBN: "9780061120084", Genre: "Classic", Publisher: "J.B. Lippincott & Co.", Price: "$7.99", StockQuantity: 12 },
            { Title: "1984", Author: "George Orwell", ISBN: "9780451524935", Genre: "Dystopian", Publisher: "Secker & Warburg", Price: "$9.99", StockQuantity: 8 },
            { Title: "Pride and Prejudice", Author: "Jane Austen", ISBN: "9780141040349", Genre: "Romance", Publisher: "Penguin Classics", Price: "$6.50", StockQuantity: 15 },
            { Title: "The Great Gatsby", Author: "F. Scott Fitzgerald", ISBN: "9780743273565", Genre: "Classic", Publisher: "Scribner", Price: "$10.99", StockQuantity: 10 },
            { Title: "The Catcher in the Rye", Author: "J.D. Salinger", ISBN: "9780316769488", Genre: "Fiction", Publisher: "Little, Brown and Company", Price: "$8.50", StockQuantity: 7 },
            { Title: "Moby Dick", Author: "Herman Melville", ISBN: "9781503280786", Genre: "Adventure", Publisher: "Harper & Brothers", Price: "$11.20", StockQuantity: 5 },
            { Title: "The Hobbit", Author: "J.R.R. Tolkien", ISBN: "9780547928227", Genre: "Fantasy", Publisher: "Houghton Mifflin Harcourt", Price: "$12.99", StockQuantity: 18 },
            { Title: "War and Peace", Author: "Leo Tolstoy", ISBN: "9780199232765", Genre: "Historical", Publisher: "Oxford University Press", Price: "$14.00", StockQuantity: 4 },
            { Title: "Crime and Punishment", Author: "Fyodor Dostoevsky", ISBN: "9780486415871", Genre: "Psychological", Publisher: "Penguin Classics", Price: "$10.50", StockQuantity: 9 },
            { Title: "Jane Eyre", Author: "Charlotte Brontë", ISBN: "9780141441146", Genre: "Classic", Publisher: "Penguin Classics", Price: "$8.00", StockQuantity: 6 },
            { Title: "The Lord of the Rings", Author: "J.R.R. Tolkien", ISBN: "9780544003415", Genre: "Fantasy", Publisher: "Allen & Unwin", Price: "$25.00", StockQuantity: 3 },
            { Title: "The Odyssey", Author: "Homer", ISBN: "9780140268867", Genre: "Epic", Publisher: "Penguin Classics", Price: "$13.50", StockQuantity: 10 },
            { Title: "Wuthering Heights", Author: "Emily Brontë", ISBN: "9780141439556", Genre: "Classic", Publisher: "Penguin Classics", Price: "$9.99", StockQuantity: 8 },
            { Title: "The Divine Comedy", Author: "Dante Alighieri", ISBN: "9780140448955", Genre: "Epic Poetry", Publisher: "Penguin Classics", Price: "$15.00", StockQuantity: 5 },
            { Title: "Animal Farm", Author: "George Orwell", ISBN: "9780451526342", Genre: "Political Satire", Publisher: "Secker & Warburg", Price: "$7.99", StockQuantity: 20 },
            { Title: "Brave New World", Author: "Aldous Huxley", ISBN: "9780060850524", Genre: "Dystopian", Publisher: "Chatto & Windus", Price: "$10.00", StockQuantity: 13 },
            { Title: "Les Misérables", Author: "Victor Hugo", ISBN: "9780140444308", Genre: "Historical", Publisher: "Penguin Classics", Price: "$12.99", StockQuantity: 9 },
            { Title: "Frankenstein", Author: "Mary Shelley", ISBN: "9780141439471", Genre: "Science Fiction", Publisher: "Lackington, Hughes, Harding, Mavor & Jones", Price: "$8.99", StockQuantity: 7 },
            { Title: "Dracula", Author: "Bram Stoker", ISBN: "9780141439846", Genre: "Horror", Publisher: "Archibald Constable and Company", Price: "$9.50", StockQuantity: 11 },
            { Title: "Don Quixote", Author: "Miguel de Cervantes", ISBN: "9780060934347", Genre: "Adventure", Publisher: "Francisco de Robles", Price: "$14.50", StockQuantity: 5 },
            { Title: "The Brothers Karamazov", Author: "Fyodor Dostoevsky", ISBN: "9780374528379", Genre: "Philosophical", Publisher: "The Russian Messenger", Price: "$13.50", StockQuantity: 7 },
            { Title: "Ulysses", Author: "James Joyce", ISBN: "9780679722762", Genre: "Modernist", Publisher: "Shakespeare and Company", Price: "$16.00", StockQuantity: 4 },
            { Title: "The Iliad", Author: "Homer", ISBN: "9780140275360", Genre: "Epic", Publisher: "Penguin Classics", Price: "$12.00", StockQuantity: 8 },
            { Title: "Great Expectations", Author: "Charles Dickens", ISBN: "9780141439563", Genre: "Classic", Publisher: "Chapman & Hall", Price: "$9.50", StockQuantity: 10 },
            { Title: "Anna Karenina", Author: "Leo Tolstoy", ISBN: "9780143035008", Genre: "Romance", Publisher: "The Russian Messenger", Price: "$11.00", StockQuantity: 6 },
            { Title: "Fahrenheit 451", Author: "Ray Bradbury", ISBN: "9781451673319", Genre: "Dystopian", Publisher: "Ballantine Books", Price: "$8.99", StockQuantity: 14 },
            { Title: "A Tale of Two Cities", Author: "Charles Dickens", ISBN: "9780141439600", Genre: "Historical", Publisher: "Chapman & Hall", Price: "$9.99", StockQuantity: 12 },
            { Title: "Heart of Darkness", Author: "Joseph Conrad", ISBN: "9780141441672", Genre: "Adventure", Publisher: "Blackwood's Magazine", Price: "$7.50", StockQuantity: 8 },
            { Title: "Madame Bovary", Author: "Gustave Flaubert", ISBN: "9780140449129", Genre: "Tragedy", Publisher: "Penguin Classics", Price: "$10.00", StockQuantity: 10 },
            { Title: "The Stranger", Author: "Albert Camus", ISBN: "9780679720201", Genre: "Philosophical", Publisher: "Librairie Gallimard", Price: "$8.99", StockQuantity: 5 },
        ];

        // Save the default inventory back to localStorage
        localStorage.setItem("books", JSON.stringify(defaultInventory));

        // Optionally, you can log the updated inventory to confirm
        console.log("Inventory reset to default values:", defaultInventory);

        // Retrieve and use the books from localStorage after setting them
        const storedBooks = JSON.parse(localStorage.getItem("books"));
        if (storedBooks && storedBooks.length > 0) {
            console.log("Books successfully loaded from localStorage:", storedBooks);
        } else {
            console.error("No books found in localStorage.");
        }
    }
});