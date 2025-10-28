import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'cart_screen.dart'; // 👈 Import your CartScreen file

class ItemDetail extends StatefulWidget {
  final String itemName;
  final String description;
  final double price;
  final double offerPrice;
  final String imagePath;

  const ItemDetail({
    super.key,
    required this.itemName,
    required this.description,
    required this.price,
    required this.offerPrice,
    required this.imagePath,
  });

  @override
  State<ItemDetail> createState() => _ItemDetailState();
}

class _ItemDetailState extends State<ItemDetail> {
  int quantity = 1;
  bool isFavorite = false;

  void _increment() {
    setState(() => quantity++);
  }

  void _decrement() {
    if (quantity > 1) setState(() => quantity--);
  }

  void _toggleFavorite() {
    setState(() => isFavorite = !isFavorite);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isFavorite
              ? '${widget.itemName} added to favorites ❤️'
              : '${widget.itemName} removed from favorites 💔',
          style: GoogleFonts.poppins(),
        ),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _goToCart() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CartScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.itemName,
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product image
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  widget.imagePath,
                  height: 250,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Title
            Text(
              widget.itemName,
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 8),

            // Price and offer
            Row(
              children: [
                Text(
                  "Rs.${widget.price.toStringAsFixed(0)}",
                  style: GoogleFonts.poppins(
                    color: Colors.grey,
                    fontSize: 16,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  "Rs.${widget.offerPrice.toStringAsFixed(0)}",
                  style: GoogleFonts.poppins(
                    color: Colors.green[700],
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Description
            Text(
              widget.description,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.grey[700],
                height: 1.5,
              ),
            ),

            const SizedBox(height: 24),

            // Quantity selector
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "Quantity:",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade400),
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: _decrement,
                        icon: const Icon(Icons.remove),
                        splashRadius: 20,
                      ),
                      Text(
                        quantity.toString(),
                        style: GoogleFonts.poppins(fontSize: 16),
                      ),
                      IconButton(
                        onPressed: _increment,
                        icon: const Icon(Icons.add),
                        splashRadius: 20,
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Buttons Row
            Row(
              children: [
                // Favorite Button
                IconButton(
                  onPressed: _toggleFavorite,
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite ? Colors.redAccent : Colors.grey,
                    size: 30,
                  ),
                ),
                const SizedBox(width: 8),

                // Add to Cart
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _goToCart, // 👈 Navigate to CartScreen
                    icon: const Icon(
                      Icons.add_shopping_cart,
                      color: Colors.black,
                    ),
                    label: Text(
                      "Add to Cart",
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        color: Colors.black,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: const BorderSide(color: Colors.black, width: 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 0,
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                // Buy Now
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            "Buying ${widget.itemName} (x$quantity)",
                            style: GoogleFonts.poppins(),
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orangeAccent,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: Text(
                      "Buy Now",
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
