import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pant_app/const/constant.dart';

class ScanPage extends StatefulWidget {
  const ScanPage({super.key});

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  final ImagePicker _picker = ImagePicker();

  File? _selectedImage;
  bool _isLoading = false;

  Future<void> _scanPlant() async {
    try {
      setState(() {
        _isLoading = true;
      });

      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
      );

      if (image != null && mounted) {
        setState(() {
          _selectedImage = File(image.path);
        });
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not open the camera. Please try again.'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _chooseFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );

      if (image != null && mounted) {
        setState(() {
          _selectedImage = File(image.path);
        });
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not select the image.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constant.background,
      appBar: AppBar(
        backgroundColor: Constant.background,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Plant Scanner',
          style: TextStyle(
            color: Constant.darkGreen,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Constant.darkGreen),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 15),

            const Text(
              'Discover Your Plant',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Constant.darkGreen,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              'Take a picture of a plant or choose one from your gallery.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey, height: 1.5),
            ),

            const SizedBox(height: 30),

            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Constant.softGreen.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(
                    color: Constant.darkGreen.withValues(alpha: 0.2),
                    width: 1.5,
                  ),
                ),
                clipBehavior: Clip.antiAlias,
                child: _selectedImage != null
                    ? Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.file(_selectedImage!, fit: BoxFit.cover),
                          Positioned(
                            top: 15,
                            right: 15,
                            child: IconButton(
                              onPressed: () {
                                setState(() {
                                  _selectedImage = null;
                                });
                              },
                              style: IconButton.styleFrom(
                                backgroundColor: Constant.white,
                              ),
                              icon: const Icon(
                                Icons.close,
                                color: Constant.darkGreen,
                              ),
                            ),
                          ),
                        ],
                      )
                    : LayoutBuilder(
                        builder: (context, constraints) {
                          final iconSize = constraints.maxHeight < 240
                              ? 110.0
                              : 150.0;

                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                height: iconSize,
                                width: iconSize,
                                decoration: const BoxDecoration(
                                  color: Constant.white,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.local_florist_rounded,
                                  size: iconSize * 0.57,
                                  color: Constant.darkGreen,
                                ),
                              ),

                              const SizedBox(height: 15),

                              const Text(
                                'Ready to Scan?',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Constant.darkGreen,
                                ),
                              ),

                              const SizedBox(height: 8),

                              const Text(
                                'Your plant photo will appear here.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
              ),
            ),

            const SizedBox(height: 25),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                onPressed: _isLoading ? null : _scanPlant,
                icon: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Constant.white,
                        ),
                      )
                    : const Icon(Icons.camera_alt_rounded),
                label: Text(
                  _isLoading ? 'Opening Camera...' : 'Start Scanning',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Constant.darkGreen,
                  foregroundColor: Constant.white,
                  disabledBackgroundColor: Constant.darkGreen,
                  disabledForegroundColor: Constant.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            TextButton.icon(
              onPressed: _chooseFromGallery,
              icon: const Icon(Icons.photo_library_outlined),
              label: const Text('Choose from Gallery'),
              style: TextButton.styleFrom(foregroundColor: Constant.darkGreen),
            ),

            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
