import 'package:flutter/material.dart';
import 'package:pant_app/const/constant.dart';
import 'package:pant_app/models/plant.dart';
import 'package:pant_app/screens/detail_page.dart';
import 'package:pant_app/widgets/plant_image.dart';
import 'package:pant_app/services/plant_api.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    if (!PlantApi.isAuthenticated) return;
    setState(() => _loading = true);
    try {
      await PlantApi.refreshFavorites();
    } catch (error) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error.toString())));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  List<Plant> get favoritePlants {
    return Plant.plantList.where((plant) => plant.isFavorated).toList();
  }

  void _openDetails(Plant plant) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailPage(plantId: plant.plantId),
      ),
    ).then((_) {
      if (mounted) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final favorites = favoritePlants;

    return Scaffold(
      backgroundColor: Constant.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // HEADER
            Padding(
              padding: const EdgeInsets.fromLTRB(22, 22, 22, 8),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'YOUR COLLECTION',
                          style: TextStyle(
                            color: Constant.gray,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'My Favorites',
                          style: TextStyle(
                            color: Constant.darkGreen,
                            fontSize: 27,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 48,
                    width: 48,
                    decoration: BoxDecoration(
                      color: Constant.softGreen.withValues(alpha: 0.35),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(
                      Icons.favorite_rounded,
                      color: Constant.darkGreen,
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),

            // FAVORITE COUNT
            Padding(
              padding: const EdgeInsets.fromLTRB(22, 12, 22, 20),
              child: Text(
                '${favorites.length} ${favorites.length == 1 ? 'plant' : 'plants'} saved for later',
                style: TextStyle(color: Constant.gray, fontSize: 13),
              ),
            ),

            // FAVORITE GRID OR EMPTY STATE
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : favorites.isEmpty
                  ? _emptyState()
                  : GridView.builder(
                      padding: const EdgeInsets.fromLTRB(18, 0, 18, 20),
                      physics: const BouncingScrollPhysics(),
                      itemCount: favorites.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 14,
                            childAspectRatio: 0.68,
                          ),
                      itemBuilder: (context, index) {
                        final plant = favorites[index];

                        return GestureDetector(
                          onTap: () => _openDetails(plant),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Constant.white,
                              borderRadius: BorderRadius.circular(22),
                              border: Border.all(
                                color: Constant.gray.withValues(alpha: 0.12),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Constant.darkGreen.withValues(
                                    alpha: 0.04,
                                  ),
                                  blurRadius: 12,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // IMAGE
                                Expanded(
                                  child: Stack(
                                    children: [
                                      Container(
                                        width: double.infinity,
                                        margin: const EdgeInsets.all(9),
                                        decoration: BoxDecoration(
                                          color: Constant.softGreen.withValues(
                                            alpha: 0.25,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            17,
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(9),
                                          child: PlantImage(
                                            imageUrl: plant.imageURL,
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                      ),

                                      // REMOVE FROM FAVORITES
                                      Positioned(
                                        top: 14,
                                        right: 14,
                                        child: Container(
                                          height: 34,
                                          width: 34,
                                          decoration: BoxDecoration(
                                            color: Constant.white,
                                            shape: BoxShape.circle,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withValues(
                                                  alpha: 0.06,
                                                ),
                                                blurRadius: 8,
                                              ),
                                            ],
                                          ),
                                          child: IconButton(
                                            padding: EdgeInsets.zero,
                                            onPressed: () async {
                                              try {
                                                await PlantApi.setFavorite(plant.plantId, false);
                                                if (mounted) setState(() {});
                                              } catch (error) {
                                                if (mounted) ScaffoldMessenger.of(context).showSnackBar(
                                                  SnackBar(content: Text(error.toString())),
                                                );
                                              }
                                            },
                                            icon: const Icon(
                                              Icons.favorite_rounded,
                                              color: Colors.redAccent,
                                              size: 18,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // PLANT INFORMATION
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                    13,
                                    2,
                                    13,
                                    13,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        plant.category,
                                        style: TextStyle(
                                          color: Constant.gray,
                                          fontSize: 10,
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        plant.plantName,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: Constant.darkGreen,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            '\$${plant.price.toStringAsFixed(0)}',
                                            style: TextStyle(
                                              color: Constant.darkGreen,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15,
                                            ),
                                          ),
                                          Icon(
                                            Icons.arrow_forward_rounded,
                                            color: Constant.darkGreen,
                                            size: 18,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  // EMPTY FAVORITES
  Widget _emptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 35),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 125,
              width: 125,
              decoration: BoxDecoration(
                color: Constant.softGreen.withValues(alpha: 0.3),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.favorite_border_rounded,
                size: 58,
                color: Constant.darkGreen,
              ),
            ),
            const SizedBox(height: 25),
            Text(
              'No favorites yet!',
              style: TextStyle(
                color: Constant.darkGreen,
                fontSize: 21,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              PlantApi.isAuthenticated
                  ? 'Your favorite plants will appear here. Explore our collection and save the ones you love!'
                  : 'Sign in from your Profile tab to save favorites to your account and sync them across sessions.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Constant.gray, fontSize: 13, height: 1.6),
            ),
            const SizedBox(height: 22),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 11),
              decoration: BoxDecoration(
                color: Constant.softGreen.withValues(alpha: 0.35),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Text(
                'Find your green beauty 🌱',
                style: TextStyle(
                  color: Constant.darkGreen,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
