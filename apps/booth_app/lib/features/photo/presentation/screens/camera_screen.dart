import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../camera/domain/camera_service.dart';
import '../../../session/domain/photo_session.dart';
import '../../../session/presentation/session_provider.dart';
import '../../../session/presentation/widgets/countdown_overlay.dart';
import '../../../admin/presentation/admin_health_screen.dart';
import '../../../admin/presentation/admin_lock_dialog.dart';
import '../../../template_editor/presentation/template_editor_screen.dart';
import 'gallery_screen.dart';
import 'review_screen.dart';

class CameraScreen extends ConsumerStatefulWidget {
  const CameraScreen({super.key});

  @override
  ConsumerState<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends ConsumerState<CameraScreen> {
  late CameraService _cameraService;
  bool _isInitCompleted = false;

  final List<Map<String, String>> _effects = [
    {'id': 'none', 'name': 'Original', 'icon': '✨'},
    {'id': 'crown', 'name': 'Crown', 'icon': '👑'},
    {'id': 'glasses', 'name': 'Glasses', 'icon': '😎'},
    {'id': 'bunny', 'name': 'Bunny', 'icon': '🐰'},
    {'id': 'hearts', 'name': 'Hearts', 'icon': '❤️'},
    {'id': 'fire', 'name': 'Fire', 'icon': '🔥'},
  ];

  final List<Map<String, String>> _backgrounds = [
    {'id': 'none', 'name': 'Original', 'icon': '🖼️'},
    {'id': 'blur', 'name': 'Blur FX', 'icon': '💧'},
    {'id': 'wedding', 'name': 'Wedding', 'icon': '💒'},
    {'id': 'galaxy', 'name': 'Galaxy', 'icon': '🌌'},
    {'id': 'studio', 'name': 'Studio', 'icon': '🎨'},
  ];

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    _cameraService = ref.read(cameraServiceProvider);
    await _cameraService.initialize();
    if (mounted) {
      setState(() {
        _isInitCompleted = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(sessionNotifierProvider);
    final sessionNotifier = ref.read(sessionNotifierProvider.notifier);

    // If session is ready for review, automatically route to ReviewScreen
    if (session.status == SessionStatus.reviewing && session.photos.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const ReviewScreen()),
        );
      });
    }

    return Scaffold(
      backgroundColor: AppTheme.darkBackground,
      appBar: AppBar(
        title: FittedBox(
          fit: BoxFit.scaleDown,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.camera_alt, color: AppTheme.secondaryAccent),
              const SizedBox(width: 8),
              const Text('PHOTO BOOTH PLATFORM'),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.successColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.successColor),
                ),
                child: Text(
                  'LIVE: ${session.photos.length}/${session.targetPhotoCount} PHOTOS',
                  style: const TextStyle(fontSize: 12, color: AppTheme.successColor, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.dashboard_customize),
            tooltip: 'Template Editor',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const TemplateEditorScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.monitor_heart),
            tooltip: 'Admin System Health',
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => AdminLockDialog(
                  onUnlocked: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const AdminHealthScreen()),
                    );
                  },
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.photo_library),
            tooltip: 'Event Gallery',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const GalleryScreen()),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              // Main Camera Preview (80% viewport)
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: AppTheme.primaryAccent.withOpacity(0.4), width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.primaryAccent.withOpacity(0.2),
                        blurRadius: 20,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      _buildCameraPreview(),
                      // Active AR Filter Sticker Overlay Indicator
                      if (session.activeEffectId != 'none')
                        Positioned(
                          top: 40,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.black54,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: AppTheme.secondaryAccent),
                            ),
                            child: Row(
                              children: [
                                Text(
                                  _effects.firstWhere(
                                      (e) => e['id'] == session.activeEffectId,
                                      orElse: () => {'icon': '✨', 'name': 'Filter'})['icon']!,
                                  style: const TextStyle(fontSize: 20),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'AR Effect: ${_effects.firstWhere((e) => e['id'] == session.activeEffectId)['name']}',
                                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              // Control Panel (Effects, Backgrounds, Preset, Capture)
              Container(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                decoration: const BoxDecoration(
                  color: AppTheme.surfaceColor,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // AR Effects Carousel
                    _buildSelectionCarousel(
                      title: 'AR EFFECTS',
                      items: _effects,
                      selectedId: session.activeEffectId,
                      onSelect: (id) => sessionNotifier.selectEffect(id),
                    ),
                    const SizedBox(height: 12),

                    // Background Replacement Carousel
                    _buildSelectionCarousel(
                      title: 'BACKGROUND',
                      items: _backgrounds,
                      selectedId: session.activeBackgroundId,
                      onSelect: (id) => sessionNotifier.selectBackground(id),
                    ),
                    const SizedBox(height: 16),

                    // Preset Photo Selector & Capture Button Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Preset Selector Dropdown
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppTheme.darkBackground,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: AppTheme.textSecondary.withOpacity(0.3)),
                          ),
                          child: DropdownButton<int>(
                            value: session.targetPhotoCount,
                            underline: const SizedBox.shrink(),
                            dropdownColor: AppTheme.surfaceColor,
                            items: const [
                              DropdownMenuItem(value: 1, child: Text('1 Photo (Single)')),
                              DropdownMenuItem(value: 3, child: Text('3 Photos (Khổ 3)')),
                              DropdownMenuItem(value: 4, child: Text('4 Photos (Standard)')),
                              DropdownMenuItem(value: 6, child: Text('6 Photos (Grid)')),
                              DropdownMenuItem(value: 8, child: Text('8 Photos (Khổ 8)')),
                            ],
                            onChanged: session.status == SessionStatus.countingDown
                                ? null
                                : (count) {
                                    if (count != null) {
                                      sessionNotifier.selectTargetPhotoCount(count);
                                    }
                                  },
                          ),
                        ),

                        // CAPTURE BUTTON
                        GestureDetector(
                          onTap: session.status == SessionStatus.countingDown
                              ? null
                              : () {
                                  sessionNotifier.triggerCountdown();
                                },
                          child: Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: const LinearGradient(
                                colors: [AppTheme.primaryAccent, AppTheme.secondaryAccent],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: AppTheme.secondaryAccent.withOpacity(0.6),
                                  blurRadius: 20,
                                  spreadRadius: 4,
                                ),
                              ],
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.camera,
                                size: 44,
                                color: Colors.white,
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
          ),

          // Countdown Overlay
          if (session.status == SessionStatus.countingDown)
            CountdownOverlay(count: sessionNotifier.countdownRemaining),
        ],
      ),
    );
  }

  Widget _buildCameraPreview() {
    if (!_isInitCompleted || !_cameraService.isInitialized || _cameraService.controller == null) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(color: AppTheme.secondaryAccent),
            SizedBox(height: 16),
            Text('Initializing Camera Service...', style: TextStyle(color: AppTheme.textSecondary)),
          ],
        ),
      );
    }

    return CameraPreview(_cameraService.controller!);
  }

  Widget _buildSelectionCarousel({
    required String title,
    required List<Map<String, String>> items,
    required String selectedId,
    required Function(String) onSelect,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 6),
          child: Text(
            title,
            style: const TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
        ),
        SizedBox(
          height: 44,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: items.length,
            separatorBuilder: (_, __) => const SizedBox(width: 10),
            itemBuilder: (context, index) {
              final item = items[index];
              final isSelected = item['id'] == selectedId;
              return InkWell(
                onTap: () => onSelect(item['id']!),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? AppTheme.primaryAccent : AppTheme.darkBackground,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected ? AppTheme.secondaryAccent : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child: Row(
                    children: [
                      Text(item['icon']!, style: const TextStyle(fontSize: 16)),
                      const SizedBox(width: 6),
                      Text(
                        item['name']!,
                        style: TextStyle(
                          color: isSelected ? Colors.white : AppTheme.textSecondary,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
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
    );
  }

  @override
  void dispose() {
    _cameraService.dispose();
    super.dispose();
  }
}
