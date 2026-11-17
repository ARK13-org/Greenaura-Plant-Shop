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
  const RootPage({super.key});

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  int bottomIndex = 0;

  final List<Widget> page = [
    const HomePage(),
    FavoritePage(),
    CartPage(),
    ProfilePage(),
  ];

  final List<IconData> icons = [
    Icons.home_rounded,
    Icons.favorite_rounded,
    Icons.shopping_bag_rounded,
    Icons.person_rounded,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constant.background,

      // MAIN CONTENT
      body: IndexedStack(index: bottomIndex, children: page),

      // CENTER SCAN BUTTON
      floatingActionButton: Container(
        height: 62,
        width: 62,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Constant.darkGreen,
          border: Border.all(color: Constant.background, width: 5),
          boxShadow: [
            BoxShadow(
              color: Constant.darkGreen.withValues(alpha: 0.25),
              blurRadius: 12,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: FloatingActionButton(
          elevation: 0,
          backgroundColor: Constant.darkGreen,
          shape: const CircleBorder(),
          onPressed: () {
            Navigator.push(
              context,
              PageTransition(
                type: PageTransitionType.bottomToTop,
                child: ScanPage(),
              ),
            );
          },
          child: Image.asset(
            'assets/images/code-scan-two.png',
            height: 27,
            color: Constant.white,
          ),
        ),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      // BOTTOM NAVIGATION
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Constant.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          boxShadow: [
            BoxShadow(
              color: Constant.darkGreen.withValues(alpha: 0.07),
              blurRadius: 15,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          child: AnimatedBottomNavigationBar(
            icons: icons,
            activeIndex: bottomIndex,
            onTap: (index) {
              setState(() {
                if (index == 1) {
                  page[1] = FavoritePage(key: UniqueKey());
                }

                bottomIndex = index;
              });
            },
            backgroundColor: Constant.white,
            activeColor: Constant.darkGreen,
            inactiveColor: Constant.gray.withValues(alpha: 0.65),
            splashColor: Constant.softGreen,
            elevation: 0,
            gapLocation: GapLocation.center,
            notchSmoothness: NotchSmoothness.smoothEdge,
            height: 65,
            iconSize: 25,
            leftCornerRadius: 24,
            rightCornerRadius: 24,
          ),
        ),
      ),
    );
  }
}
