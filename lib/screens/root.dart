import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pant_app/const/constant.dart';
import 'package:pant_app/screens/cart_page.dart';
import 'package:pant_app/screens/favorite_page.dart';
import 'package:pant_app/screens/home_page.dart';
import 'package:pant_app/screens/profile_page.dart';
import 'package:pant_app/screens/scan_page.dart';

class RootPage extends StatefulWidget {
  const new({super.key});

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  int bottomIndex = 0;

  List<Widget> page = [HomePage(), FavoritePage(), CartPage(), ProfilePage()];

  List<IconData> icons = [
    Icons.home_outlined,
    Icons.favorite_outline,
    Icons.shopping_cart_outlined,
    Icons.person_2_outlined,
  ];

  List<String> appBarTitle = ['Home', 'Favorite', 'Cart', 'Profile'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Padding(
          padding: EdgeInsets.only(top: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                appBarTitle[bottomIndex],
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Icon(Icons.notifications_none, color: Constant.black, size: 28),
            ],
          ),
        ),
        backgroundColor: Constant.white,
      ),
      body: IndexedStack(index: bottomIndex, children: page),
      floatingActionButton: FloatingActionButton(
        shape: CircleBorder(),
        backgroundColor: Constant.darkGreen,
        child: Image.asset('assets/images/code-scan-two.png', height: 30),
        onPressed: () {
          Navigator.push(
            context,
            PageTransition(
              type: PageTransitionType.bottomToTop,
              child: ScanPage(),
            ),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: Container(
        color: Constant.white,
        child: AnimatedBottomNavigationBar(
          elevation: 5,
          splashColor: Constant.darkGreen,
          activeColor: Constant.darkGreen,
          backgroundColor: Constant.white,
          inactiveColor: Colors.grey.withValues(alpha: 0.7),
          gapLocation: GapLocation.center,
          notchSmoothness: NotchSmoothness.smoothEdge,
          borderColor: Constant.gray.withValues(alpha: 0.5),
          icons: icons,
          activeIndex: bottomIndex,
          onTap: (int index) {
            setState(() {
              bottomIndex = index;
            });
          },
        ),
      ),
    );
  }
}
