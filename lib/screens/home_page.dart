import 'package:flutter/material.dart';
import 'package:pant_app/const/constant.dart';
import 'package:pant_app/models/plant.dart';
import 'package:pant_app/screens/detail_page.dart';

class HomePage extends StatefulWidget {
  const new({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;

  bool toggleFavorite(bool isFavorite) {
    return isFavorite = !isFavorite;
  }

  final List<String> _plantTypes = [
    '| Recommended |',
    '| Indoor Plants |',
    '| Office Plants |',
    '| Garden Plants |',
    '| Toxic Plants |',
  ];

  final List<Plant> _plantList = Plant.plantList;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Constant.white,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            //Search Box
            Padding(
              padding: const EdgeInsets.only(top: 15),
              child: Center(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  width: size.width * 0.9,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: Constant.gray.withValues(alpha: 0.1),
                  ),
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.search),
                      Expanded(
                        child: TextField(
                          showCursor: true,
                          cursorColor: Constant.black.withValues(alpha: 0.5),
                          decoration: InputDecoration(
                            hint: Text(
                              'Search Plant...',
                              style: TextStyle(
                                color: Constant.black.withValues(alpha: 0.5),
                              ),
                            ),
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                          ),
                        ),
                      ),
                      Icon(Icons.mic),
                    ],
                  ),
                ),
              ),
            ),
            //Categoty
            Container(
              padding: EdgeInsets.only(left: 18, right: 18, top: 18),
              width: size.width,
              height: 70,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _plantTypes.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedIndex = index;
                        });
                      },
                      child: Text(
                        _plantTypes[index],
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: selectedIndex == index
                              ? FontWeight.bold
                              : FontWeight.normal,
                          color: selectedIndex == index
                              ? Constant.darkGreen
                              : Constant.gray,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            // Product 1
            SizedBox(
              height: size.height * 0.3,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _plantList.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) =>
                                DetailPage(plantId: _plantList[index].plantId),
                          ),
                        );
                      },
                      child: Container(
                        width: 150,
                        decoration: BoxDecoration(
                          color: Constant.softGreen.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            width: 1,
                            color: Constant.gray.withValues(alpha: 0.5),
                          ),
                        ),
                        child: Stack(
                          children: <Widget>[
                            Positioned(
                              top: 10,
                              left: 10,
                              child: Container(
                                alignment: Alignment.center,
                                height: 35,
                                width: 35,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Constant.white,
                                ),
                                child: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _plantList[index].isFavorated =
                                          !_plantList[index].isFavorated;
                                    });
                                  },
                                  icon: Icon(
                                    _plantList[index].isFavorated
                                        ? Icons.favorite
                                        : Icons.favorite_outline,
                                    size: 20,
                                    color: _plantList[index].isFavorated
                                        ? Constant.darkGreen.withValues(
                                            alpha: 0.7,
                                          )
                                        : Constant.gray,
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 30,
                              right: 25,
                              child: SizedBox(
                                height: 150,
                                width: 100,
                                child: Container(
                                  decoration: BoxDecoration(
                                    boxShadow: <BoxShadow>[
                                      BoxShadow(
                                        color: Colors.black.withValues(
                                          alpha: 0.1,
                                        ),
                                        blurRadius: 17,
                                        spreadRadius: 1,
                                        offset: const Offset(0, -10),
                                      ),
                                    ],
                                  ),
                                  child: Image.asset(
                                    _plantList[index].imageURL,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 10,
                              left: 9,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    _plantList[index].category,
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.black.withValues(
                                        alpha: 0.7,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    _plantList[index].plantName,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Positioned(
                              bottom: 10,
                              right: 9,
                              child: Text(
                                r'$' + _plantList[index].price.toString(),
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            // New Plants - Text
            Container(
              padding: const EdgeInsets.all(12),
              alignment: Alignment.centerLeft,
              child: Text(
                'New Plants',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black.withValues(alpha: 0.7),
                ),
              ),
            ),
            // New Plants - Product 2
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 1),
              height: size.height * 0.3,
              child: ListView.builder(
                itemCount: _plantList.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) =>
                              DetailPage(plantId: _plantList[index].plantId),
                        ),
                      );
                    },
                    child: Container(
                      height: 80,
                      width: size.width,
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: Constant.softGreen.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(
                          width: 1,
                          color: Constant.gray.withValues(alpha: 0.5),
                        ),
                      ),
                      child: Row(
                        children: <Widget>[
                          SizedBox(
                            width: 75,
                            height: 70,
                            child: Stack(
                              alignment: Alignment.center,
                              children: <Widget>[
                                Container(
                                  width: 65,
                                  height: 65,
                                  decoration: const BoxDecoration(
                                    color: Constant.white,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: Image.asset(
                                    _plantList[index].imageURL,
                                    width: 65,
                                    height: 65,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 5),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  _plantList[index].category,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.black.withValues(alpha: 0.7),
                                  ),
                                ),
                                Text(
                                  _plantList[index].plantName,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Constant.white,
                            ),
                            child: Text(
                              '\$${_plantList[index].price}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Constant.darkGreen,
                              ),
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
}
