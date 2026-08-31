import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/storage/local_storage_service.dart';
import 'core/theme/app_theme.dart';
import 'features/photo/presentation/screens/camera_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalStorageService.init();

  runApp(
    const ProviderScope(
      child: PhotoboothApp(),
    ),
  );
}

class PhotoboothApp extends StatelessWidget {
  const PhotoboothApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Photobooth Platform',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const CameraScreen(),
    );
  }
}
