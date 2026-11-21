import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pant_app/const/constant.dart';
import 'package:pant_app/models/plant.dart';
import 'package:pant_app/services/plant_api.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String userName = 'GreenAura Member';
  String userEmail = 'Sign in to sync your account';
  String? profilePicturePath;

  bool _profileLoading = false;
  bool _pictureUploading = false;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _loadProfile() async {
    if (!PlantApi.isAuthenticated) return;

    setState(() => _profileLoading = true);

    try {
      final user = await PlantApi.getMe();

      if (!mounted) return;

      setState(() {
        userName = '${user['name'] ?? ''} ${user['last_name'] ?? ''}'.trim();
        userEmail = user['email']?.toString() ?? '';
        profilePicturePath = user['profile_picture']?.toString();
      });

      debugPrint('Profile picture: $profilePicturePath');
    } catch (error) {
      if (!mounted) return;
      _showMessage(error.toString());
    } finally {
      if (mounted) {
        setState(() => _profileLoading = false);
      }
    }
  }

  String _profilePictureUrl(String path) {
    final trimmedPath = path.trim();

    if (trimmedPath.startsWith('http://') ||
        trimmedPath.startsWith('https://')) {
      return trimmedPath;
    }

    return Uri.parse(ApiConfig.baseUrl).resolve(trimmedPath).toString();
  }

  Future<void> _pickAndUploadProfilePicture() async {
    if (!PlantApi.isAuthenticated) {
      _showMessage('Please sign in to change your profile picture.');
      return;
    }

    try {
      final image = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
        maxWidth: 1200,
      );

      if (!mounted || image == null) return;

      setState(() => _pictureUploading = true);

      final updatedUser = await PlantApi.uploadProfilePicture(image);

      if (!mounted) return;

      setState(() {
        profilePicturePath = updatedUser['profile_picture']?.toString();
      });

      _showMessage('Profile picture updated successfully!');
    } catch (error) {
      if (!mounted) return;
      _showMessage(error.toString());
    } finally {
      if (mounted) {
        setState(() => _pictureUploading = false);
      }
    }
  }

  Future<void> _showAuthDialog() async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const _GreenAuraAuthDialog(),
    );

    if (!mounted) return;

    if (result == true) {
      await _loadProfile();
    }
  }

  int get favoriteCount => Plant.getFavoritedPlants().length;

  int get cartCount =>
      Plant.addedToCartPlants().fold(0, (sum, plant) => sum + plant.quantity);

  void _showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Constant.darkGreen,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Future<void> _editProfile() async {
    if (!PlantApi.isAuthenticated) {
      await _showAuthDialog();
      return;
    }

    final nameController = TextEditingController(
      text: PlantApi.currentUser?['name']?.toString() ?? userName,
    );

    final emailController = TextEditingController(
      text: PlantApi.currentUser?['email']?.toString() ?? userEmail,
    );

    try {
      await showDialog<void>(
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
                onPressed: () async {
                  final name = nameController.text.trim();
                  final email = emailController.text.trim();

                  if (name.isEmpty || email.isEmpty) {
                    return;
                  }

                  try {
                    final updated = await PlantApi.updateProfile(
                      name: name,
                      email: email,
                    );

                    if (!mounted || !dialogContext.mounted) return;

                    setState(() {
                      userName =
                          '${updated['name'] ?? ''} ${updated['last_name'] ?? ''}'
                              .trim();
                      userEmail = updated['email']?.toString() ?? '';
                    });

                    Navigator.pop(dialogContext);
                    _showMessage('Profile updated successfully!');
                  } catch (error) {
                    if (!mounted || !dialogContext.mounted) return;

                    ScaffoldMessenger.of(dialogContext).showSnackBar(
                      SnackBar(
                        content: Text(error.toString()),
                        backgroundColor: Colors.red.shade700,
                      ),
                    );
                  }
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
    } finally {
      nameController.dispose();
      emailController.dispose();
    }
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
              _profileLoading
                  ? const Padding(
                      padding: EdgeInsets.only(top: 50, bottom: 50),
                      child: Center(child: CircularProgressIndicator()),
                    )
                  : _profileHeader(),
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
                    child: ClipOval(
                      child:
                          profilePicturePath != null &&
                              profilePicturePath!.trim().isNotEmpty
                          ? Image.network(
                              _profilePictureUrl(profilePicturePath!),
                              width: 105,
                              height: 105,
                              fit: BoxFit.cover,
                              loadingBuilder: (context, child, progress) {
                                if (progress == null) return child;
                                return const Center(
                                  child: SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Constant.white,
                                    ),
                                  ),
                                );
                              },
                              errorBuilder: (context, error, stackTrace) {
                                debugPrint(
                                  'Profile image failed to load: $error',
                                );
                                return const Center(
                                  child: Icon(
                                    Icons.person_rounded,
                                    size: 57,
                                    color: Constant.white,
                                  ),
                                );
                              },
                            )
                          : const Center(
                              child: Icon(
                                Icons.person_rounded,
                                size: 57,
                                color: Constant.white,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextButton.icon(
                    onPressed: _pictureUploading
                        ? null
                        : _pickAndUploadProfilePicture,
                    icon: _pictureUploading
                        ? const SizedBox(
                            width: 15,
                            height: 15,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Color(0xFFD6E8BD),
                            ),
                          )
                        : const Icon(Icons.camera_alt_outlined, size: 16),
                    label: Text(
                      _pictureUploading
                          ? 'Uploading...'
                          : 'Edit Profile Picture',
                      style: const TextStyle(
                        color: Constant.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: TextButton.styleFrom(
                      foregroundColor: Constant.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 7,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
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

  Widget _logoutButton() {
    final signedIn = PlantApi.isAuthenticated;

    return SizedBox(
      width: double.infinity,
      height: 54,
      child: OutlinedButton.icon(
        onPressed: () async {
          if (!signedIn) {
            await _showAuthDialog();
            return;
          }

          try {
            await PlantApi.logout();

            if (!mounted) return;

            setState(() {
              userName = 'GreenAura Member';
              userEmail = 'Sign in to sync your account';
              profilePicturePath = null;
            });

            _showMessage('You have been logged out.');
          } catch (error) {
            if (!mounted) return;
            _showMessage(error.toString());
          }
        },
        icon: Icon(
          signedIn ? Icons.logout_rounded : Icons.login_rounded,
          size: 19,
        ),
        label: Text(
          signedIn ? 'Log Out' : 'Sign In / Create Account',
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
        ),
        style: OutlinedButton.styleFrom(
          foregroundColor: signedIn ? Colors.red.shade400 : Constant.darkGreen,
          side: BorderSide(
            color: (signedIn ? Colors.red : Constant.darkGreen).withValues(
              alpha: 0.2,
            ),
          ),
          backgroundColor: (signedIn ? Colors.red : Constant.darkGreen)
              .withValues(alpha: 0.025),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }

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

class _GreenAuraAuthDialog extends StatefulWidget {
  const _GreenAuraAuthDialog();

  @override
  State<_GreenAuraAuthDialog> createState() => _GreenAuraAuthDialogState();
}

class _GreenAuraAuthDialogState extends State<_GreenAuraAuthDialog> {
  final _formKey = GlobalKey<FormState>();
  final _username = TextEditingController();
  final _password = TextEditingController();
  final _name = TextEditingController();
  final _lastName = TextEditingController();
  final _phone = TextEditingController();
  final _email = TextEditingController();

  bool _register = false;
  bool _busy = false;
  bool _obscure = true;

  @override
  void dispose() {
    _username.dispose();
    _password.dispose();
    _name.dispose();
    _lastName.dispose();
    _phone.dispose();
    _email.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _busy = true);

    try {
      if (_register) {
        await PlantApi.register(
          username: _username.text.trim(),
          name: _name.text.trim(),
          lastName: _lastName.text.trim(),
          phoneNumber: _phone.text.trim(),
          email: _email.text.trim(),
          password: _password.text,
        );
      }

      await PlantApi.login(_username.text.trim(), _password.text);

      if (!mounted) return;

      Navigator.pop(context, true);
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.toString()),
          backgroundColor: Colors.red.shade700,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _busy = false);
      }
    }
  }

  Widget _field(
    TextEditingController controller,
    String label, {
    bool secret = false,
    TextInputType? keyboard,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboard,
        obscureText: secret && _obscure,
        validator: (value) =>
            (value == null || value.trim().isEmpty) ? 'Required' : null,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Constant.background,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(13),
            borderSide: BorderSide.none,
          ),
          suffixIcon: secret
              ? IconButton(
                  onPressed: () => setState(() => _obscure = !_obscure),
                  icon: Icon(
                    _obscure
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                  ),
                )
              : null,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Constant.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      title: Text(
        _register ? 'Create your account' : 'Welcome back',
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Constant.darkGreen,
        ),
      ),
      content: SizedBox(
        width: 380,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (_register) ...[
                  _field(_name, 'First name'),
                  _field(_lastName, 'Last name'),
                  _field(_phone, 'Phone number', keyboard: TextInputType.phone),
                  _field(
                    _email,
                    'Email address',
                    keyboard: TextInputType.emailAddress,
                  ),
                ],
                _field(_username, 'Username'),
                _field(_password, 'Password', secret: true),
                TextButton(
                  onPressed: _busy
                      ? null
                      : () => setState(() => _register = !_register),
                  child: Text(
                    _register
                        ? 'Already have an account? Sign in'
                        : 'New to GreenAura? Create an account',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _busy ? null : () => Navigator.pop(context, false),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _busy ? null : _submit,
          style: ElevatedButton.styleFrom(
            backgroundColor: Constant.darkGreen,
            foregroundColor: Constant.white,
          ),
          child: _busy
              ? const SizedBox(
                  height: 18,
                  width: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : Text(_register ? 'Register' : 'Sign In'),
        ),
      ],
    );
  }
}
