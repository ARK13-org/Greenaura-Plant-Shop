import 'package:flutter/material.dart';
import 'package:pant_app/const/constant.dart';
import 'package:pant_app/models/plant.dart';
import 'package:pant_app/screens/detail_page.dart';
import 'package:pant_app/services/plant_api.dart';
import 'package:pant_app/widgets/plant_image.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;
  String searchQuery = '';
  bool _isLoading = true;
  String? _loadError;

  final TextEditingController _searchController = TextEditingController();

  List<String> _plantTypes = ['All'];

  List<Plant> get _plantList => Plant.plantList;

  @override
  void initState() {
    super.initState();
    _loadCatalog();
  }

  Future<void> _loadCatalog() async {
    if (mounted) {
      setState(() {
        _isLoading = true;
        _loadError = null;
      });
    }

    try {
      final results = await Future.wait([
        PlantApi.fetchPlants(),
        PlantApi.fetchCategories(),
      ]);
      final plants = results[0] as List<Plant>;
      final categories = results[1] as List<Map<String, dynamic>>;

      Plant.plantList = plants;
      if (!mounted) return;
      setState(() {
        _plantTypes = [
          'All',
          ...categories
              .map((category) => category['name']?.toString() ?? '')
              .where((name) => name.isNotEmpty),
        ];
        selectedIndex = 0;
        _isLoading = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _loadError = error.toString();
        _isLoading = false;
      });
    }
  }

  List<Plant> get filteredPlants {
    return _plantList.where((plant) {
      final matchesCategory =
          selectedIndex == 0 ||
          plant.category.toLowerCase().contains(
            _plantTypes[selectedIndex].toLowerCase(),
          );

      final matchesSearch =
          plant.plantName.toLowerCase().contains(searchQuery.toLowerCase()) ||
          plant.category.toLowerCase().contains(searchQuery.toLowerCase());

      return matchesCategory && matchesSearch;
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openDetails(Plant plant) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailPage(plantId: plant.plantId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading && Plant.plantList.isEmpty) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_loadError != null && Plant.plantList.isEmpty) {
      return Scaffold(
        backgroundColor: Constant.background,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.cloud_off_rounded, size: 48),
                const SizedBox(height: 12),
                const Text('Could not connect to GreenAura API',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text(_loadError!, textAlign: TextAlign.center),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: _loadCatalog,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Try again'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final plants = filteredPlants;

    return Scaffold(
      backgroundColor: Constant.background,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // HEADER
                Padding(
                  padding: const EdgeInsets.fromLTRB(22, 18, 22, 20),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Hello, Plant Lover',
                              style: TextStyle(
                                fontSize: 13,
                                color: Constant.gray,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              'Find your green beauty.',
                              style: TextStyle(
                                fontSize: 23,
                                fontWeight: FontWeight.w800,
                                color: Constant.darkGreen,
                                letterSpacing: -0.6,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // SEARCH BAR
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 22),
                  child: Container(
                    height: 55,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Constant.white,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: Constant.gray.withValues(alpha: 0.12),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Constant.darkGreen.withValues(alpha: 0.04),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.search_rounded,
                          color: Constant.darkGreen,
                          size: 23,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            onChanged: (value) {
                              setState(() {
                                searchQuery = value;
                              });
                            },
                            decoration: InputDecoration(
                              hintText: 'Search for plants...',
                              hintStyle: TextStyle(
                                color: Constant.gray.withValues(alpha: 0.8),
                                fontSize: 14,
                              ),
                              border: InputBorder.none,
                              isDense: true,
                            ),
                          ),
                        ),
                        if (searchQuery.isNotEmpty)
                          IconButton(
                            onPressed: () {
                              _searchController.clear();
                              setState(() {
                                searchQuery = '';
                              });
                            },
                            icon: Icon(
                              Icons.close_rounded,
                              color: Constant.gray,
                              size: 20,
                            ),
                          )
                        else
                          Icon(
                            Icons.tune_rounded,
                            color: Constant.darkGreen,
                            size: 21,
                          ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 27),

                // FEATURE BANNER

                // FEATURE BANNER
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 22),
                  child: Container(
                    height: 165,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Constant.darkGreen,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          right: -10,
                          bottom: -20,
                          child: Icon(
                            Icons.spa_rounded,
                            size: 170,
                            color: Constant.white.withValues(alpha: 0.07),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 15, 10, 15),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 6,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'MAKE YOUR HOME',
                                      style: TextStyle(
                                        color: Constant.white.withValues(
                                          alpha: 0.75,
                                        ),
                                        fontSize: 10,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 1.5,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    const Text(
                                      'A little greener,\na lot happier.',
                                      style: TextStyle(
                                        color: Constant.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        height: 1.15,
                                      ),
                                    ),
                                    const SizedBox(height: 7),
                                    Row(
                                      children: [
                                        Text(
                                          'Explore plants',
                                          style: TextStyle(
                                            color: Constant.white.withValues(
                                              alpha: 0.9,
                                            ),
                                            fontSize: 11,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(width: 5),
                                        const Icon(
                                          Icons.arrow_forward_rounded,
                                          color: Constant.white,
                                          size: 15,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 5,
                                child: Image.asset(
                                  'assets/images/peace-plant.png',
                                  fit: BoxFit.contain,
                                  height: 140,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // CATEGORY SECTION
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 22),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Categories',
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                          color: Constant.darkGreen,
                        ),
                      ),
                      Text(
                        'Explore all',
                        style: TextStyle(
                          fontSize: 12,
                          color: Constant.gray,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 15),

                SizedBox(
                  height: 43,
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    scrollDirection: Axis.horizontal,
                    itemCount: _plantTypes.length,
                    itemBuilder: (context, index) {
                      final isSelected = selectedIndex == index;

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedIndex = index;
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 19,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Constant.darkGreen
                                : Constant.white,
                            borderRadius: BorderRadius.circular(25),
                            border: Border.all(
                              color: isSelected
                                  ? Constant.darkGreen
                                  : Constant.gray.withValues(alpha: 0.2),
                            ),
                          ),
                          child: Text(
                            _plantTypes[index],
                            style: TextStyle(
                              color: isSelected
                                  ? Constant.white
                                  : Constant.gray,
                              fontSize: 12,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.w500,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 27),

                // FEATURED PLANTS TITLE
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 22),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Popular Plants',
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                          color: Constant.darkGreen,
                        ),
                      ),
                      Text(
                        '${plants.length} plants',
                        style: TextStyle(color: Constant.gray, fontSize: 12),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 15),

                // HORIZONTAL PRODUCT CARDS
                SizedBox(
                  height: 245,
                  child: plants.isEmpty
                      ? _emptyMessage()
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 18),
                          scrollDirection: Axis.horizontal,
                          itemCount: plants.length,
                          itemBuilder: (context, index) {
                            final plant = plants[index];

                            return GestureDetector(
                              onTap: () => _openDetails(plant),
                              child: Container(
                                width: 165,
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 5,
                                ),
                                decoration: BoxDecoration(
                                  color: Constant.white,
                                  borderRadius: BorderRadius.circular(22),
                                  border: Border.all(
                                    color: Constant.gray.withValues(
                                      alpha: 0.12,
                                    ),
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
                                    // IMAGE AND FAVORITE
                                    Expanded(
                                      child: Stack(
                                        children: [
                                          Container(
                                            width: double.infinity,
                                            margin: const EdgeInsets.all(9),
                                            decoration: BoxDecoration(
                                              color: Constant.softGreen
                                                  .withValues(alpha: 0.25),
                                              borderRadius:
                                                  BorderRadius.circular(17),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(8),
                                              child: PlantImage(
                                                imageUrl: plant.imageURL,
                                                fit: BoxFit.contain,
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            top: 15,
                                            right: 15,
                                            child: Container(
                                              height: 34,
                                              width: 34,
                                              decoration: BoxDecoration(
                                                color: Constant.white,
                                                shape: BoxShape.circle,
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black
                                                        .withValues(
                                                          alpha: 0.06,
                                                        ),
                                                    blurRadius: 8,
                                                  ),
                                                ],
                                              ),
                                              child: IconButton(
                                                padding: EdgeInsets.zero,
                                                onPressed: () {
                                                  setState(() {
                                                    plant.isFavorated =
                                                        !plant.isFavorated;
                                                  });
                                                },
                                                icon: Icon(
                                                  plant.isFavorated
                                                      ? Icons.favorite_rounded
                                                      : Icons
                                                            .favorite_border_rounded,
                                                  color: plant.isFavorated
                                                      ? Colors.redAccent
                                                      : Constant.gray,
                                                  size: 18,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    // PRODUCT INFORMATION
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
                                              fontSize: 10,
                                              color: Constant.gray,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            plant.plantName,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold,
                                              color: Constant.darkGreen,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                '\$${plant.price.toStringAsFixed(0)}',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  color: Constant.darkGreen,
                                                ),
                                              ),
                                              Icon(
                                                Icons.arrow_forward_rounded,
                                                size: 17,
                                                color: Constant.darkGreen,
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

                const SizedBox(height: 28),

                // NEW ARRIVALS TITLE
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 22),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'New Arrivals',
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                          color: Constant.darkGreen,
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_rounded,
                        color: Constant.darkGreen,
                        size: 20,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 15),

                // VERTICAL PRODUCT LIST
                if (plants.isEmpty)
                  _emptyMessage()
                else
                  ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 22),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: plants.length,
                    itemBuilder: (context, index) {
                      final plant = plants[index];

                      return GestureDetector(
                        onTap: () => _openDetails(plant),
                        child: Container(
                          height: 100,
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Constant.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Constant.gray.withValues(alpha: 0.12),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Constant.darkGreen.withValues(
                                  alpha: 0.035,
                                ),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              // PRODUCT IMAGE
                              Container(
                                width: 78,
                                height: 78,
                                decoration: BoxDecoration(
                                  color: Constant.softGreen.withValues(
                                    alpha: 0.3,
                                  ),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: PlantImage(
                                    imageUrl: plant.imageURL,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),

                              const SizedBox(width: 13),

                              // PRODUCT NAME
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      plant.category,
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: Constant.gray,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      plant.plantName,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Constant.darkGreen,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      'Bring nature home',
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: Constant.gray,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // PRICE AND FAVORITE
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        plant.isFavorated = !plant.isFavorated;
                                      });
                                    },
                                    child: Icon(
                                      plant.isFavorated
                                          ? Icons.favorite_rounded
                                          : Icons.favorite_border_rounded,
                                      color: plant.isFavorated
                                          ? Colors.redAccent
                                          : Constant.gray,
                                      size: 19,
                                    ),
                                  ),
                                  Text(
                                    '\$${plant.price.toStringAsFixed(0)}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Constant.darkGreen,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _emptyMessage() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 25),
      child: Center(
        child: Column(
          children: [
            Icon(Icons.spa_outlined, size: 45, color: Constant.gray),
            const SizedBox(height: 10),
            Text(
              'No plants found',
              style: TextStyle(
                color: Constant.darkGreen,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              'Try another search or category.',
              style: TextStyle(color: Constant.gray, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
