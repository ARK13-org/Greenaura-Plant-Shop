import 'package:flutter/material.dart';
import 'package:pant_app/const/constant.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController _pageController = PageController(initialPage: 0);
  int currentIndex = 0;

  Widget _indecator(bool isActive) {
    return AnimatedContainer(
      duration: Duration(microseconds: 300),
      height: 10,
      margin: EdgeInsets.all(2),
      width: isActive ? 20 : 8,
      decoration: BoxDecoration(
        color: Constant.darkGreen,
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }

  List<Widget> _buildIndecator() {
    List<Widget> indecators = [];
    for (int i = 0; i < 3; i++) {
      if (currentIndex == i) {
        indecators.add(_indecator(true));
      } else {
        indecators.add(_indecator(false));
      }
    }
    return indecators;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constant.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: InkWell(
              onTap: () {},
              child: Text(
                'Skip',
                style: TextStyle(
                  color: Constant.gray,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: (int page) {
              setState(() {
                currentIndex = page;
              });
            },
            children: [
              CreatePage(
                image: 'assets/images/calathea-orbifolia.png',
                title: Constant.titleOne,
                description: Constant.descriptionOne,
              ),
              CreatePage(
                image: 'assets/images/rubber-plant.png',
                title: Constant.titleTwo,
                description: Constant.descriptionTwo,
              ),
              CreatePage(
                image: 'assets/images/peace-plant.png',
                title: Constant.titleThree,
                description: Constant.descriptionThree,
              ),
            ],
          ),
          Positioned(
            bottom: 80,
            left: 30,
            child: Row(children: _buildIndecator()),
          ),
          Positioned(
            bottom: 70,
            right: 30,
            child: Container(
              padding: EdgeInsets.all(3),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Constant.darkGreen,
              ),
              child: IconButton(
                onPressed: () {},
                icon: Icon(Icons.arrow_forward_ios, color: Constant.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CreatePage extends StatelessWidget {
  final String image;
  final String title;
  final String description;
  const new({
    super.key,
    required this.title,
    required this.description,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 325, width: 325, child: Image.asset(image)),
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: const Color.fromARGB(255, 18, 80, 20),
              fontSize: 35,
            ),
          ),
          Text(
            description,
            style: TextStyle(
              color: const Color.fromARGB(255, 18, 80, 20),
              fontSize: 15,
            ),
          ),
          SizedBox(height: 125),
        ],
      ),
    );
  }
}
