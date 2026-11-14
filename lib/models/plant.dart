class Plant {
  final int plantId;
  final int price;
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
  });

  //List of Plants data

  static List<Plant> plantList = [
    Plant(
      plantId: 0,
      price: 22,
      category: 'Indoor',
      plantName: 'Aloe Vera',
      size: 'Small',
      rating: 4.5,
      humidity: 34,
      temperature: '23 - 34',
      imageURL: 'assets/images/aloe-vera.png',
      isFavorated: false,
      decription: 'Aloe Vera is a hardy succulent known for its medicinal properties. It is easy to care for and thrives in bright, indirect sunlight.',
      isSelected: false,
    ),
    Plant(
      plantId: 1,
      price: 11,
      category: 'Office',
      plantName: 'Calathea Orbifolia',
      size: 'Medium',
      rating: 4.8,
      humidity: 56,
      temperature: '19 - 22',
      imageURL: 'assets/images/calathea-orbifolia.png',
      isFavorated: false,
      decription: 'Calathea Orbifolia is admired for its large, round leaves with beautiful silver-green patterns. It prefers humidity and indirect light.',
      isSelected: false,
    ),
    Plant(
      plantId: 2,
      price: 18,
      category: 'Indoor',
      plantName: 'Fiddle Leaf Fig',
      size: 'Large',
      rating: 4.7,
      humidity: 34,
      temperature: '22 - 25',
      imageURL: 'assets/images/fidel-leaf-plant.png',
      isFavorated: false,
      decription: 'The Fiddle Leaf Fig is a popular indoor plant with large, glossy leaves. It adds a beautiful tropical touch to any living space.',
      isSelected: false,
    ),
    Plant(
      plantId: 3,
      price: 30,
      category: 'Office',
      plantName: 'Jade Plant',
      size: 'Small',
      rating: 4.5,
      humidity: 35,
      temperature: '23 - 28',
      imageURL: 'assets/images/jade-plant.png',
      isFavorated: false,
      decription: 'The Jade Plant is a beautiful succulent with thick, fleshy leaves. It is low-maintenance and perfect for desks and small spaces.',
      isSelected: false,
    ),
    Plant(
      plantId: 4,
      price: 24,
      category: 'Recommended',
      plantName: 'Peace Lily',
      size: 'Large',
      rating: 4.1,
      humidity: 66,
      temperature: '12 - 16',
      imageURL: 'assets/images/peace-plant.png',
      isFavorated: false,
      decription: 'The Peace Lily is an elegant indoor plant with deep green leaves and beautiful white flowers. It grows well in low to medium light.',
      isSelected: false,
    ),
    Plant(
      plantId: 5,
      price: 24,
      category: 'Office',
      plantName: 'Rubber Plant',
      size: 'Medium',
      rating: 4.4,
      humidity: 36,
      temperature: '15 - 18',
      imageURL: 'assets/images/rubber-plant.png',
      isFavorated: false,
      decription: 'The Rubber Plant features thick, glossy leaves and a striking appearance. It is a great choice for decorating homes and offices.',
      isSelected: false,
    ),
    Plant(
      plantId: 6,
      price: 19,
      category: 'Garden',
      plantName: 'Snake Plant',
      size: 'Small',
      rating: 4.2,
      humidity: 46,
      temperature: '23 - 26',
      imageURL: 'assets/images/snake-plant.png',
      isFavorated: false,
      decription: 'The Snake Plant is a resilient indoor plant with upright, sword-shaped leaves. It requires little maintenance and tolerates low light.',
      isSelected: false,
    ),
    Plant(
      plantId: 7,
      price: 23,
      category: 'Garden',
      plantName: 'ZZ Plant',
      size: 'Medium',
      rating: 4.5,
      humidity: 34,
      temperature: '21 - 24',
      imageURL: 'assets/images/zz-plant.png',
      isFavorated: false,
      decription: 'The ZZ Plant is known for its shiny, dark green leaves. It is drought-tolerant and an excellent choice for beginners.',
      isSelected: false,
    ),
    Plant(
      plantId: 8,
      price: 46,
      category: 'Recommended',
      plantName: 'Rubber Plant',
      size: 'Medium',
      rating: 4.7,
      humidity: 46,
      temperature: '21 - 25',
      imageURL: 'assets/images/rubber-plant.png',
      isFavorated: false,
      decription: 'The Rubber Plant is a stylish decorative plant with broad, glossy leaves. It brings a fresh and modern look to any interior.',
      isSelected: false,
    ),
  ];

  //Get the favorated items
  static List<Plant> getFavoritedPlants() {
    List<Plant> travelList = Plant.plantList;
    return travelList.where((element) => element.isFavorated == true).toList();
  }

  //Get the cart items
  static List<Plant> addedToCartPlants() {
    List<Plant> selectedPlants = Plant.plantList;
    return selectedPlants
        .where((element) => element.isSelected == true)
        .toList();
  }
}
