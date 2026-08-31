import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class GuestWebGallery extends StatelessWidget {
  final String qrToken;
  final String? photoUrl;

  const GuestWebGallery({super.key, required this.qrToken, this.photoUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.darkBackground,
      appBar: AppBar(
        title: const Text('GUEST PHOTO GALLERY'),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: AppTheme.secondaryAccent.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppTheme.secondaryAccent),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.check_circle, color: AppTheme.secondaryAccent, size: 18),
                    SizedBox(width: 8),
                    Text(
                      'No App Installation Required',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Digital Photo Frame Preview
              Container(
                width: 320,
                height: 480,
                decoration: BoxDecoration(
                  color: AppTheme.surfaceColor,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: AppTheme.primaryAccent, width: 2),
                  boxShadow: const [
                    BoxShadow(color: Colors.black54, blurRadius: 20, offset: Offset(0, 10)),
                  ],
                ),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.photo, size: 80, color: AppTheme.primaryAccent),
                    SizedBox(height: 16),
                    Text(
                      'PHOTO BOOTH DIGITAL MEMORY',
                      style: TextStyle(color: AppTheme.textPrimary, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // One-Tap Download & Share Buttons
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.successColor,
                  minimumSize: const Size(280, 56),
                ),
                icon: const Icon(Icons.download, size: 24),
                label: const Text('DOWNLOAD HD PHOTO', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Downloading HD Photo to Device Camera Roll...')),
                  );
                },
              ),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: const BorderSide(color: AppTheme.primaryAccent, width: 2),
                  minimumSize: const Size(280, 56),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                icon: const Icon(Icons.share, size: 24),
                label: const Text('SHARE TO INSTAGRAM / OS', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Opening Native Share Sheet...')),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
