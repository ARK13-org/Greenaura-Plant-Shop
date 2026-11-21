import 'package:flutter/material.dart';
import 'package:pant_app/const/constant.dart';
import 'package:pant_app/models/plant.dart';
import 'package:pant_app/widgets/plant_image.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  // Shared cart items
  List<Plant> get cartItems =>
      Plant.plantList.where((plant) => plant.quantity > 0).toList();

  double get subtotal {
    return cartItems.fold<double>(
      0.0,
      (sum, plant) => sum + (plant.price * plant.quantity),
    );
  }

  final double deliveryFee = 5.0;

  double get total => subtotal + (cartItems.isEmpty ? 0 : deliveryFee);

  void increaseQuantity(Plant plant) {
    setState(() {
      plant.quantity++;
    });
  }

  void decreaseQuantity(Plant plant) {
    setState(() {
      if (plant.quantity > 1) {
        plant.quantity--;
      } else {
        plant.quantity = 0;
      }
    });
  }

  void removeItem(Plant plant) {
    setState(() {
      plant.quantity = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constant.background,
      body: SafeArea(
        child: cartItems.isEmpty
            ? _emptyCart()
            : Column(
                children: [
                  _header(),
                  Expanded(
                    child: ListView.separated(
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                      itemCount: cartItems.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 16),
                      itemBuilder: (context, index) {
                        return _cartItem(cartItems[index]);
                      },
                    ),
                  ),
                  _checkoutSection(),
                ],
              ),
      ),
    );
  }

  Widget _header() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'YOUR SELECTION',
                  style: TextStyle(
                    color: Constant.darkGreen.withValues(alpha: 0.7),
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  'My Cart',
                  style: TextStyle(
                    fontSize: 27,
                    fontWeight: FontWeight.bold,
                    color: Constant.black,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(13),
            decoration: BoxDecoration(
              color: Constant.softGreen.withValues(alpha: 0.3),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.shopping_bag_outlined,
              color: Constant.darkGreen,
              size: 25,
            ),
          ),
        ],
      ),
    );
  }

  Widget _cartItem(Plant plant) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Constant.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            width: 95,
            height: 105,
            decoration: BoxDecoration(
              color: Constant.softGreen.withValues(alpha: 0.25),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: PlantImage(imageUrl: plant.imageURL, fit: BoxFit.contain),
            ),
          ),
          const SizedBox(width: 13),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  plant.category.toUpperCase(),
                  style: TextStyle(
                    color: Constant.darkGreen.withValues(alpha: 0.7),
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  plant.plantName,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Constant.black,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '\$${plant.price.toStringAsFixed(2)}',
                  style: TextStyle(
                    color: Constant.darkGreen,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),

                Row(
                  children: [
                    _quantityButton(
                      icon: Icons.remove,
                      onTap: () => decreaseQuantity(plant),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        '${plant.quantity}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    _quantityButton(
                      icon: Icons.add,
                      onTap: () => increaseQuantity(plant),
                    ),
                  ],
                ),
              ],
            ),
          ),

          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              onPressed: () => removeItem(plant),
              icon: Icon(
                Icons.delete_outline_rounded,
                color: Colors.red.shade300,
                size: 22,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _quantityButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 27,
        height: 27,
        decoration: BoxDecoration(
          color: Constant.softGreen.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 16, color: Constant.darkGreen),
      ),
    );
  }

  Widget _checkoutSection() {
    return Container(
      padding: const EdgeInsets.fromLTRB(22, 20, 22, 22),
      decoration: BoxDecoration(
        color: Constant.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 15,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        children: [
          _priceRow('Subtotal', subtotal),
          const SizedBox(height: 12),
          _priceRow('Delivery', deliveryFee),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 15),
            child: Divider(height: 1),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
              Text(
                '\$${total.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Constant.darkGreen,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 55,
            child: ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Checkout will be available soon!'),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Constant.darkGreen,
                foregroundColor: Constant.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Proceed to Checkout',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 10),
                  Icon(Icons.arrow_forward_rounded, size: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _priceRow(String title, double price) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
        ),
        Text(
          '\$${price.toStringAsFixed(2)}',
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  Widget _emptyCart() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                color: Constant.softGreen.withValues(alpha: 0.25),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.shopping_bag_outlined,
                size: 65,
                color: Constant.darkGreen.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: 25),
            const Text(
              'Your cart is empty',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Constant.black,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Looks like you haven\'t added any plants yet.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 25),
            Text(
              'Find your favorite plants and bring nature home!',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Constant.darkGreen,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
