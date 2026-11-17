import 'package:flutter/material.dart';
import 'package:pant_app/const/constant.dart';
import 'package:pant_app/screens/root.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final PageController _pageController = PageController();

  int currentIndex = 0;

  final List<Map<String, String>> pages = [
    {
      'image': 'assets/images/calathea-orbifolia.png',
      'title': Constant.titleOne,
      'description': Constant.descriptionOne,
      'tag': 'LIVE BEAUTIFULLY',
    },
    {
      'image': 'assets/images/rubber-plant.png',
      'title': Constant.titleTwo,
      'description': Constant.descriptionTwo,
      'tag': 'GROW WITH NATURE',
    },
    {
      'image': 'assets/images/peace-plant.png',
      'title': Constant.titleThree,
      'description': Constant.descriptionThree,
      'tag': 'MAKE ROOM FOR GREEN',
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (currentIndex < pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 550),
        curve: Curves.easeInOutCubic,
      );
    } else {
      _goToHome();
    }
  }

  void _goToHome() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => RootPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constant.background,
      body: SafeArea(
        child: Column(
          children: [
            // TOP HEADER
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 8),
              child: Row(
                children: [
                  // BRAND LOGO
                  Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      color: Constant.darkGreen,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.spa_rounded,
                      color: Constant.white,
                      size: 23,
                    ),
                  ),

                  const SizedBox(width: 10),

                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'GreenAura',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Constant.darkGreen,
                          letterSpacing: 0.3,
                        ),
                      ),
                      Text(
                        'BRING NATURE HOME',
                        style: TextStyle(
                          fontSize: 8,
                          letterSpacing: 1.2,
                          color: Constant.gray,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),

                  const Spacer(),

                  TextButton(
                    onPressed: _goToHome,
                    child: Text(
                      'Skip',
                      style: TextStyle(
                        color: Constant.darkGreen.withValues(alpha: 0.75),
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ONBOARDING PAGES
            Expanded(
              child: Stack(
                children: [
                  PageView.builder(
                    controller: _pageController,
                    itemCount: pages.length,
                    onPageChanged: (index) {
                      setState(() {
                        currentIndex = index;
                      });
                    },
                    itemBuilder: (context, index) {
                      return CreatePage(
                        image: pages[index]['image']!,
                        title: pages[index]['title']!,
                        description: pages[index]['description']!,
                        tag: pages[index]['tag']!,
                      );
                    },
                  ),

                  // BOTTOM NAVIGATION
                  Positioned(
                    bottom: 25,
                    left: 25,
                    right: 25,
                    child: Row(
                      children: [
                        // PAGE INDICATORS
                        Row(
                          children: List.generate(pages.length, (index) {
                            final active = currentIndex == index;

                            return AnimatedContainer(
                              duration: const Duration(milliseconds: 350),
                              curve: Curves.easeInOut,
                              margin: const EdgeInsets.only(right: 6),
                              height: 7,
                              width: active ? 27 : 7,
                              decoration: BoxDecoration(
                                color: active
                                    ? Constant.darkGreen
                                    : Constant.darkGreen.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(20),
                              ),
                            );
                          }),
                        ),

                        const Spacer(),

                        // NEXT BUTTON
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          height: 54,
                          width: currentIndex == pages.length - 1 ? 155 : 54,
                          decoration: BoxDecoration(
                            color: Constant.darkGreen,
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                color: Constant.darkGreen.withValues(
                                  alpha: 0.2,
                                ),
                                blurRadius: 15,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(30),
                              onTap: _nextPage,
                              child: Center(
                                // OVERFLOW FIX
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: currentIndex == pages.length - 1
                                      ? const Row(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Get Started',
                                              style: TextStyle(
                                                color: Constant.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                              ),
                                            ),
                                            SizedBox(width: 7),
                                            Icon(
                                              Icons.arrow_forward_rounded,
                                              color: Constant.white,
                                              size: 19,
                                            ),
                                          ],
                                        )
                                      : const Icon(
                                          Icons.arrow_forward_rounded,
                                          color: Constant.white,
                                          size: 24,
                                        ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ONBOARDING CONTENT

class CreatePage extends StatelessWidget {
  final String image;
  final String title;
  final String description;
  final String tag;

  const CreatePage({
    super.key,
    required this.image,
    required this.title,
    required this.description,
    required this.tag,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22),
      child: Column(
        children: [
          // PLANT DISPLAY
          Expanded(
            flex: 7,
            child: Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.none,
              children: [
                // BACKGROUND GRADIENT CIRCLE
                Container(
                  width: size.width * 0.79,
                  height: size.width * 0.79,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        Constant.softGreen.withValues(alpha: 0.65),
                        Constant.background.withValues(alpha: 0.1),
                      ],
                    ),
                  ),
                ),

                // OUTER CIRCLE
                Container(
                  width: size.width * 0.91,
                  height: size.width * 0.91,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Constant.darkGreen.withValues(alpha: 0.09),
                      width: 1.2,
                    ),
                  ),
                ),

                // DECORATIVE SMALL CIRCLES
                Positioned(
                  top: size.height * 0.10,
                  left: 15,
                  child: _decorationCircle(13),
                ),

                Positioned(
                  top: size.height * 0.18,
                  right: 12,
                  child: _decorationCircle(8),
                ),

                Positioned(
                  bottom: size.height * 0.12,
                  left: 25,
                  child: _decorationCircle(9),
                ),

                // DECORATIVE LEAVES
                Positioned(
                  top: size.height * 0.14,
                  left: 12,
                  child: Transform.rotate(
                    angle: -0.6,
                    child: Icon(
                      Icons.eco_rounded,
                      size: 43,
                      color: Constant.darkGreen.withValues(alpha: 0.35),
                    ),
                  ),
                ),

                Positioned(
                  bottom: size.height * 0.18,
                  right: 8,
                  child: Transform.rotate(
                    angle: 0.7,
                    child: Icon(
                      Icons.spa_rounded,
                      size: 35,
                      color: Constant.darkGreen.withValues(alpha: 0.35),
                    ),
                  ),
                ),

                // MAIN PLANT IMAGE
                Image.asset(
                  image,
                  width: size.width * 0.86,
                  height: size.height * 0.46,
                  fit: BoxFit.contain,
                  filterQuality: FilterQuality.high,
                ),

                // TOP FLOATING LABEL
                Positioned(
                  top: size.height * 0.09,
                  right: 5,
                  child: _floatingLabel(
                    icon: Icons.verified_rounded,
                    text: 'NATURAL BEAUTY',
                  ),
                ),

                // BOTTOM FLOATING CARD
                Positioned(
                  bottom: size.height * 0.10,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 11,
                    ),
                    decoration: BoxDecoration(
                      color: Constant.white,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: Constant.darkGreen.withValues(alpha: 0.10),
                          blurRadius: 18,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          height: 34,
                          width: 34,
                          decoration: BoxDecoration(
                            color: Constant.softGreen.withValues(alpha: 0.5),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.favorite_rounded,
                            color: Constant.darkGreen,
                            size: 18,
                          ),
                        ),
                        const SizedBox(width: 9),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Love Nature',
                              style: TextStyle(
                                color: Constant.darkGreen,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              'Live a greener life',
                              style: TextStyle(
                                color: Constant.gray,
                                fontSize: 9,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                // SMALL LEFT BADGE
                Positioned(
                  bottom: size.height * 0.20,
                  left: 0,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Constant.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.08),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.wb_sunny_outlined,
                      color: Constant.darkGreen,
                      size: 22,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // DECORATIVE TITLE LINE
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _line(),
              const SizedBox(width: 9),
              Icon(Icons.spa_rounded, color: Constant.darkGreen, size: 18),
              const SizedBox(width: 9),
              _line(),
            ],
          ),

          const SizedBox(height: 16),

          // TITLE
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: size.width > 380 ? 30 : 26,
              fontWeight: FontWeight.w800,
              color: Constant.darkGreen,
              letterSpacing: -0.7,
            ),
          ),

          const SizedBox(height: 12),

          // DESCRIPTION
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              description,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                height: 1.7,
                color: Constant.darkGreen.withValues(alpha: 0.75),
              ),
            ),
          ),

          const SizedBox(height: 18),

          // PAGE TAG
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
            decoration: BoxDecoration(
              color: Constant.softGreen.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              tag,
              style: TextStyle(
                fontSize: 9,
                letterSpacing: 1.5,
                fontWeight: FontWeight.bold,
                color: Constant.darkGreen,
              ),
            ),
          ),

          const Spacer(flex: 2),

          const SizedBox(height: 80),
        ],
      ),
    );
  }

  // DECORATIVE CIRCLE
  Widget _decorationCircle(double diameter) {
    return Container(
      height: diameter,
      width: diameter,
      decoration: BoxDecoration(
        color: Constant.darkGreen.withValues(alpha: 0.25),
        shape: BoxShape.circle,
      ),
    );
  }

  // FLOATING LABEL
  Widget _floatingLabel({required IconData icon, required String text}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        color: Constant.white.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Constant.darkGreen, size: 15),
          const SizedBox(width: 5),
          Text(
            text,
            style: TextStyle(
              color: Constant.darkGreen,
              fontSize: 9,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  // DECORATIVE LINE
  Widget _line() {
    return Container(
      height: 1.2,
      width: 28,
      color: Constant.darkGreen.withValues(alpha: 0.35),
    );
  }
}
