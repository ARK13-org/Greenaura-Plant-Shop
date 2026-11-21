import 'package:flutter/material.dart';
import 'package:pant_app/const/constant.dart';
import 'package:pant_app/models/plant.dart';
import 'package:pant_app/screens/cart_page.dart';
import 'package:pant_app/services/plant_api.dart';
import 'package:pant_app/widgets/plant_image.dart';

class DetailPage extends StatefulWidget {
  final int plantId;

  const DetailPage({super.key, required this.plantId});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  Plant? _serverPlant;
  bool _favoriteBusy = false;

  @override
  void initState() {
    super.initState();
    _loadPlantDetails();
  }

  Future<void> _loadPlantDetails() async {
    try {
      final result = await PlantApi.fetchPlantById(widget.plantId);

      if (!mounted) return;

      final matches = Plant.plantList.where(
        (item) => item.plantId == widget.plantId,
      );

      final existing = matches.isEmpty ? null : matches.first;

      if (existing != null) {
        result.isFavorated = existing.isFavorated;
        result.quantity = existing.quantity;
      }

      setState(() => _serverPlant = result);
    } catch (_) {
      // Keep the catalogue item usable if the detail refresh fails.
    }
  }

  Future<void> _toggleFavorite(Plant plant) async {
    if (_favoriteBusy) return;

    final next = !plant.isFavorated;
    final messenger = ScaffoldMessenger.of(context);

    setState(() => _favoriteBusy = true);

    try {
      await PlantApi.setFavorite(plant.plantId, next);

      if (!mounted) return;

      setState(() {
        plant.isFavorated = next;
        _favoriteBusy = false;
      });
    } catch (error) {
      if (!mounted) return;

      setState(() => _favoriteBusy = false);

      messenger.showSnackBar(SnackBar(content: Text(error.toString())));
    }
  }

  void _addToCart(Plant plant) {
    setState(() {
      plant.quantity++;
    });

    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Plant added to cart!')));

    _openCart();
  }

  void _openCart() {
    Navigator.push(context, MaterialPageRoute(builder: (_) => CartPage()));
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    final Plant plant =
        _serverPlant ??
        Plant.plantList.firstWhere(
          (item) => item.plantId == widget.plantId,
          orElse: () => throw StateError(
            'Plant ${widget.plantId} is no longer available.',
          ),
        );

    return Scaffold(
      backgroundColor: Constant.background,
      body: SafeArea(
        child: Column(
          children: [
            // TOP BAR
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _circleButton(
                    icon: Icons.arrow_back,
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Text(
                    'Plant Details',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Constant.darkGreen,
                    ),
                  ),
                  _circleButton(
                    icon: plant.isFavorated
                        ? Icons.favorite
                        : Icons.favorite_outline,
                    iconColor: plant.isFavorated
                        ? Colors.red
                        : Constant.darkGreen,
                    onPressed: _favoriteBusy
                        ? () {}
                        : () => _toggleFavorite(plant),
                  ),
                ],
              ),
            ),

            // PLANT IMAGE
            Expanded(
              flex: 5,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: size.width * 0.7,
                      height: size.width * 0.7,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Constant.softGreen.withValues(alpha: 0.4),
                      ),
                    ),
                    PlantImage(
                      imageUrl: plant.imageURL,
                      width: size.width * 0.8,
                      height: size.height * 0.38,
                      fit: BoxFit.contain,
                    ),
                  ],
                ),
              ),
            ),

            // PLANT INFORMATION
            Expanded(
              flex: 6,
              child: Container(
                width: size.width,
                padding: const EdgeInsets.fromLTRB(22, 25, 22, 15),
                decoration: BoxDecoration(
                  color: Constant.white,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(32),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.06),
                      blurRadius: 15,
                      offset: const Offset(0, -4),
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // NAME, PRICE AND RATING
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  plant.category,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Constant.gray,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  plant.plantName,
                                  style: const TextStyle(
                                    fontSize: 23,
                                    fontWeight: FontWeight.bold,
                                    color: Constant.darkGreen,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.star,
                                    color: Constant.rating,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    plant.rating.toString(),
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 7),
                              Text(
                                '\$${plant.price.toStringAsFixed(0)}',
                                style: const TextStyle(
                                  fontSize: 23,
                                  fontWeight: FontWeight.bold,
                                  color: Constant.darkGreen,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      const Text(
                        'Plant Information',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),

                      Row(
                        children: [
                          Expanded(
                            child: _detailCard(
                              icon: Icons.height,
                              title: 'Plant Size',
                              value: plant.size,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _detailCard(
                              icon: Icons.water_drop_outlined,
                              title: 'Humidity',
                              value: plant.humidity.toString(),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _detailCard(
                              icon: Icons.thermostat,
                              title: 'Temperature',
                              value: plant.temperature,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 22),

                      const Text(
                        'About Plant',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),

                      Text(
                        plant.decription,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 14,
                          height: 1.6,
                          color: Constant.black.withValues(alpha: 0.7),
                        ),
                      ),

                      const SizedBox(height: 25),

                      // CART BUTTONS
                      Row(
                        children: [
                          _circleButton(
                            icon: Icons.shopping_cart_outlined,
                            backgroundColor: Constant.darkGreen,
                            iconColor: Constant.white,
                            onPressed: _openCart,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: SizedBox(
                              height: 50,
                              child: ElevatedButton(
                                onPressed: () => _addToCart(plant),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Constant.darkGreen,
                                  foregroundColor: Constant.white,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                                child: const Text(
                                  'Add To Cart',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // CIRCULAR BUTTON
  Widget _circleButton({
    required IconData icon,
    required VoidCallback onPressed,
    Color? backgroundColor,
    Color? iconColor,
  }) {
    return Container(
      height: 45,
      width: 45,
      decoration: BoxDecoration(
        color: backgroundColor ?? Constant.softGreen.withValues(alpha: 0.4),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon, color: iconColor ?? Constant.darkGreen, size: 21),
      ),
    );
  }

  // PLANT DETAIL CARD
  Widget _detailCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      height: 100,
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
      decoration: BoxDecoration(
        color: Constant.softGreen.withValues(alpha: 0.25),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Constant.darkGreen, size: 22),
          const SizedBox(height: 7),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 11, color: Constant.gray),
          ),
          const SizedBox(height: 3),
          Text(
            value,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Constant.darkGreen,
            ),
          ),
        ],
      ),
    );
  }
}
