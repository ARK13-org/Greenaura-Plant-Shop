class Plant {
  final int plantId;
  final double price;
  final String size;
  final double rating;
  final int humidity;
  final String temperature;
  final String category;
  final String plantName;
  final String imageURL;
  bool isFavorated;
  final String decription;
  bool isSelected;
  int quantity;

  Plant({
    required this.plantId,
    required this.price,
    required this.category,
    required this.plantName,
    required this.size,
    required this.rating,
    required this.humidity,
    required this.temperature,
    required this.imageURL,
    required this.isFavorated,
    required this.decription,
    required this.isSelected,
    this.quantity = 0,
  });

  static List<Plant> plantList = [];
  static Set<int> favoritePlantIds = {};

  factory Plant.fromJson(Map<String, dynamic> json, {required String baseUrl}) {
    final categoryJson = json['category'];
    final categoryName = categoryJson is Map
        ? (categoryJson['name']?.toString() ?? 'Uncategorized')
        : 'Uncategorized';
    final rawImage = json['image_url']?.toString() ?? '';
    final resolvedImage =
        rawImage.startsWith('http://') || rawImage.startsWith('https://')
        ? rawImage
        : '$baseUrl/${rawImage.replaceFirst(RegExp(r'^/+'), '')}';

    final id = (json['id'] as num).toInt();
    final previousMatches = plantList.where((item) => item.plantId == id);
    final previous = previousMatches.isEmpty ? null : previousMatches.first;

    return Plant(
      plantId: id,
      price: (json['price'] as num).toDouble(),
      category: categoryName,
      plantName: json['plant_name']?.toString() ?? '',
      size: json['size']?.toString() ?? 'Not specified',
      rating: (json['rating'] as num?)?.toDouble() ?? 0,
      humidity: (json['humidity'] as num?)?.toInt() ?? 0,
      temperature: json['temperature']?.toString() ?? 'Not specified',
      imageURL: resolvedImage,
      isFavorated:
          favoritePlantIds.contains(id) || (previous?.isFavorated ?? false),
      decription: json['description']?.toString() ?? '',
      isSelected: previous?.isSelected ?? false,
      quantity: previous?.quantity ?? 0,
    );
  }

  static List<Plant> getFavoritedPlants() =>
      plantList.where((plant) => plant.isFavorated).toList();

  static List<Plant> addedToCartPlants() =>
      plantList.where((plant) => plant.quantity > 0).toList();
}
