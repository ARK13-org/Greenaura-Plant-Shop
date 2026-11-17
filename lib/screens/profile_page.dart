import 'package:flutter/material.dart';
import 'package:pant_app/const/constant.dart';
import 'package:pant_app/models/plant.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String userName = 'GreenAura Member';
  String userEmail = 'hello@greenaura.com';

  int get favoriteCount => Plant.getFavoritedPlants().length;

  int get cartCount =>
      Plant.addedToCartPlants().fold(0, (sum, plant) => sum + plant.quantity);

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Constant.darkGreen,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _editProfile() {
    final nameController = TextEditingController(text: userName);
    final emailController = TextEditingController(text: userEmail);

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: Constant.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          title: const Text(
            'Edit Profile',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Full Name',
                    prefixIcon: const Icon(Icons.person_outline),
                    filled: true,
                    fillColor: Constant.background,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Email Address',
                    prefixIcon: const Icon(Icons.email_outlined),
                    filled: true,
                    fillColor: Constant.background,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.grey.shade600),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (nameController.text.trim().isEmpty ||
                    emailController.text.trim().isEmpty) {
                  return;
                }

                setState(() {
                  userName = nameController.text.trim();
                  userEmail = emailController.text.trim();
                });

                Navigator.pop(dialogContext);
                _showMessage('Profile updated successfully!');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Constant.darkGreen,
                foregroundColor: Constant.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Save Changes'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constant.background,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              _profileHeader(),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 25, 20, 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _statistics(),
                    const SizedBox(height: 30),

                    _sectionTitle('MY ACCOUNT'),
                    const SizedBox(height: 13),
                    _menuCard([
                      _menuItem(
                        icon: Icons.person_outline_rounded,
                        title: 'Personal Information',
                        subtitle: 'Your name and email address',
                        onTap: _editProfile,
                      ),
                      _divider(),
                      _menuItem(
                        icon: Icons.location_on_outlined,
                        title: 'Shipping Address',
                        subtitle: 'Manage your delivery addresses',
                        onTap: () =>
                            _showMessage('Shipping Address coming soon!'),
                      ),
                      _divider(),
                      _menuItem(
                        icon: Icons.receipt_long_outlined,
                        title: 'My Orders',
                        subtitle: 'Check your order history',
                        onTap: () =>
                            _showMessage('Your orders will appear here.'),
                      ),
                    ]),

                    const SizedBox(height: 27),
                    _sectionTitle('PREFERENCES'),
                    const SizedBox(height: 13),
                    _menuCard([
                      _menuItem(
                        icon: Icons.notifications_none_rounded,
                        title: 'Notifications',
                        subtitle: 'Manage your notifications',
                        onTap: () =>
                            _showMessage('Notification settings coming soon!'),
                      ),
                      _divider(),
                      _menuItem(
                        icon: Icons.language_rounded,
                        title: 'Language',
                        subtitle: 'English',
                        onTap: () =>
                            _showMessage('Language settings coming soon!'),
                      ),
                    ]),

                    const SizedBox(height: 27),
                    _sectionTitle('MORE'),
                    const SizedBox(height: 13),
                    _menuCard([
                      _menuItem(
                        icon: Icons.help_outline_rounded,
                        title: 'Help Center',
                        subtitle: 'We are here to help',
                        onTap: () => _showMessage('Help Center coming soon!'),
                      ),
                      _divider(),
                      _menuItem(
                        icon: Icons.info_outline_rounded,
                        title: 'About GreenAura',
                        subtitle: 'Our story and app information',
                        onTap: _showAbout,
                      ),
                    ]),

                    const SizedBox(height: 25),
                    _logoutButton(),
                    const SizedBox(height: 25),

                    Center(
                      child: Column(
                        children: [
                          Icon(
                            Icons.eco_rounded,
                            color: Constant.darkGreen.withValues(alpha: 0.5),
                            size: 23,
                          ),
                          const SizedBox(height: 7),
                          Text(
                            'GROW WITH GREENAURA',
                            style: TextStyle(
                              color: Constant.darkGreen.withValues(alpha: 0.55),
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            'Bring Nature Home',
                            style: TextStyle(
                              color: Colors.grey.shade500,
                              fontSize: 11,
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
      ),
    );
  }

  // Profile Header
  Widget _profileHeader() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(22, 22, 22, 35),
          decoration: BoxDecoration(
            color: Constant.darkGreen,
            borderRadius: const BorderRadius.vertical(
              bottom: Radius.circular(35),
            ),
          ),
          child: Stack(
            children: [
              Positioned(right: -30, top: 30, child: _decorationCircle(150)),
              Positioned(right: 80, bottom: -65, child: _decorationCircle(110)),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'YOUR PERSONAL SPACE',
                            style: TextStyle(
                              color: Constant.white.withValues(alpha: 0.65),
                              fontSize: 10,
                              letterSpacing: 2,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 5),
                          const Text(
                            'My Profile',
                            style: TextStyle(
                              color: Constant.white,
                              fontSize: 27,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Constant.white.withValues(alpha: 0.12),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          onPressed: () =>
                              _showMessage('Settings coming soon!'),
                          icon: const Icon(
                            Icons.settings_outlined,
                            color: Constant.white,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  Container(
                    width: 105,
                    height: 105,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Constant.white.withValues(alpha: 0.12),
                      border: Border.all(
                        color: Constant.white.withValues(alpha: 0.65),
                        width: 2,
                      ),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.person_rounded,
                        size: 57,
                        color: Constant.white,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  Text(
                    userName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Constant.white,
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    userEmail,
                    style: TextStyle(
                      color: Constant.white.withValues(alpha: 0.7),
                      fontSize: 12,
                    ),
                  ),

                  const SizedBox(height: 12),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 13,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color: Constant.white.withValues(alpha: 0.13),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.spa_rounded,
                          color: Color(0xFFD6E8BD),
                          size: 15,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Plant Lover',
                          style: TextStyle(
                            color: Constant.white.withValues(alpha: 0.9),
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  SizedBox(
                    height: 43,
                    child: OutlinedButton.icon(
                      onPressed: _editProfile,
                      icon: const Icon(Icons.edit_outlined, size: 16),
                      label: const Text(
                        'Edit Profile',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Constant.white,
                        side: BorderSide(
                          color: Constant.white.withValues(alpha: 0.5),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(13),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _decorationCircle(double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: Constant.white.withValues(alpha: 0.07),
          width: 1.5,
        ),
      ),
    );
  }

  // Statistics
  Widget _statistics() {
    return Row(
      children: [
        Expanded(
          child: _statCard(
            icon: Icons.favorite_rounded,
            title: 'Favorites',
            value: '$favoriteCount',
            color: const Color(0xFFE68B91),
          ),
        ),
        const SizedBox(width: 13),
        Expanded(
          child: _statCard(
            icon: Icons.shopping_bag_rounded,
            title: 'Cart Items',
            value: '$cartCount',
            color: Constant.darkGreen,
          ),
        ),
      ],
    );
  }

  Widget _statCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 19),
      decoration: BoxDecoration(
        color: Constant.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.025),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 43,
            height: 43,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.10),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 21),
          ),
          const SizedBox(height: 11),
          Text(
            value,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Constant.black,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  // Section Title
  Widget _sectionTitle(String title) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 17,
          decoration: BoxDecoration(
            color: Constant.darkGreen,
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        const SizedBox(width: 9),
        Text(
          title,
          style: TextStyle(
            color: Constant.darkGreen,
            fontSize: 11,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.6,
          ),
        ),
      ],
    );
  }

  // Menu Card
  Widget _menuCard(List<Widget> children) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      decoration: BoxDecoration(
        color: Constant.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.025),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _menuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(13),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: Constant.softGreen.withValues(alpha: 0.28),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: Constant.darkGreen, size: 21),
            ),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Constant.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 10),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: Colors.grey.shade400,
              size: 14,
            ),
          ],
        ),
      ),
    );
  }

  Widget _divider() {
    return Divider(
      height: 1,
      indent: 57,
      color: Colors.grey.withValues(alpha: 0.12),
    );
  }

  // Logout
  Widget _logoutButton() {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: OutlinedButton.icon(
        onPressed: () {
          _showMessage('Logout functionality will be added later.');
        },
        icon: const Icon(Icons.logout_rounded, size: 19),
        label: const Text(
          'Log Out',
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
        ),
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.red.shade400,
          side: BorderSide(color: Colors.red.withValues(alpha: 0.2)),
          backgroundColor: Colors.red.withValues(alpha: 0.025),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }

  // About
  void _showAbout() {
    showAboutDialog(
      context: context,
      applicationName: 'GreenAura',
      applicationVersion: '1.0.0',
      applicationIcon: Icon(
        Icons.eco_rounded,
        color: Constant.darkGreen,
        size: 35,
      ),
      children: const [
        Text('Bring Nature Home.'),
        SizedBox(height: 8),
        Text(
          'GreenAura helps you discover beautiful plants '
          'and bring a little more nature into your life.',
        ),
      ],
    );
  }
}
