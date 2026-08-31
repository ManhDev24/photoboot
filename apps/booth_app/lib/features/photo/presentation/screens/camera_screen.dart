import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../admin/presentation/admin_health_screen.dart';
import '../../../admin/presentation/admin_lock_dialog.dart';
import '../../../camera/domain/camera_service.dart';
import '../../../effects/presentation/ar_sticker_painter.dart';
import '../../../session/domain/photo_session.dart';
import '../../../session/presentation/session_provider.dart';
import '../../../session/presentation/widgets/countdown_overlay.dart';
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
  bool _isFilterEnabled = true; // TikTok style ON/OFF Filter Toggle
  int _activeControlTab = 0; // 0: Beauty, 1: Color Filters, 2: AR Props
  String _selectedColorFilterId = 'original';
  String _selectedBeautyModeId = 'beauty_natural';
  final double _beautyIntensity = 0.5;
  Color _selectedFrameColor = Colors.white;

  void _applyWebCssFilter(String filterId) {
    if (kIsWeb) {
      String cssFilter = 'none';
      if (_isFilterEnabled) {
        switch (filterId) {
          case 'b_w_film':
            cssFilter = 'grayscale(100%) contrast(125%) brightness(95%)';
            break;
          case 'vintage_70s':
            cssFilter = 'sepia(65%) contrast(115%) brightness(105%) hue-rotate(-15deg)';
            break;
          case 'cyber_neon':
            cssFilter = 'hue-rotate(180deg) saturate(220%) contrast(130%)';
            break;
          case 'warm_sunset':
            cssFilter = 'sepia(35%) saturate(160%) hue-rotate(-10deg) brightness(105%)';
            break;
          case 'ai_beauty_glow':
          case 'porcelain_glow':
            cssFilter = 'brightness(115%) contrast(98%) saturate(110%) blur(0.2px)';
            break;
          case 'korean_idol':
          case 'idol_retouch':
            cssFilter = 'brightness(118%) contrast(106%) saturate(115%)';
            break;
          case 'portrait_sharp':
          case 'eye_sharpen':
            cssFilter = 'contrast(140%) saturate(112%)';
            break;
          case 'beauty_natural':
            cssFilter = 'brightness(108%) contrast(102%) saturate(106%)';
            break;
          default:
            cssFilter = 'none';
        }
      }
      debugPrint('Applied web filter: $cssFilter');
    }
  }

  final List<Map<String, dynamic>> _beautyModes = [
    {'id': 'off', 'name': 'Beauty Off', 'icon': '🚫', 'matrix': <double>[1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0]},
    {'id': 'beauty_natural', 'name': 'Natural Skin', 'icon': '🌸', 'matrix': <double>[1.1, 0.04, 0.04, 0.0, 10.0, 0.04, 1.08, 0.04, 0.0, 8.0, 0.04, 0.04, 1.06, 0.0, 10.0, 0.0, 0.0, 0.0, 1.0, 0.0]},
    {'id': 'porcelain_glow', 'name': 'Porcelain Glow', 'icon': '💎', 'matrix': <double>[1.18, 0.06, 0.06, 0.0, 20.0, 0.06, 1.15, 0.06, 0.0, 16.0, 0.06, 0.06, 1.12, 0.0, 18.0, 0.0, 0.0, 0.0, 1.0, 0.0]},
    {'id': 'idol_retouch', 'name': 'Idol Retouch', 'icon': '👑', 'matrix': <double>[1.22, 0.08, 0.05, 0.0, 25.0, 0.05, 1.18, 0.05, 0.0, 20.0, 0.03, 0.05, 1.10, 0.0, 15.0, 0.0, 0.0, 0.0, 1.0, 0.0]},
    {'id': 'eye_sharpen', 'name': 'Eye & Lip Sharp', 'icon': '👁️', 'matrix': <double>[1.35, -0.1, -0.1, 0.0, 8.0, -0.1, 1.35, -0.1, 0.0, 8.0, -0.1, -0.1, 1.35, 0.0, 8.0, 0.0, 0.0, 0.0, 1.0, 0.0]},
  ];

  final List<Map<String, String>> _effects = [
    {'id': 'none', 'name': 'None', 'icon': '✨'},
    {'id': 'crown', 'name': 'Crown', 'icon': '👑'},
    {'id': 'glasses', 'name': 'Sunglasses', 'icon': '😎'},
    {'id': 'bunny', 'name': 'Bunny Ears', 'icon': '🐰'},
    {'id': 'horns', 'name': 'Devil Horns', 'icon': '😈'},
    {'id': 'hearts', 'name': 'Love Hearts', 'icon': '❤️'},
    {'id': 'fire', 'name': 'Fire Aura', 'icon': '🔥'},
  ];

  final List<Map<String, dynamic>> _frameColors = [
    {'name': 'White', 'color': Colors.white},
    {'name': 'Black', 'color': Colors.black},
    {'name': 'Pink', 'color': const Color(0xFFFCE7F3)},
    {'name': 'Blue', 'color': const Color(0xFFDBEAFE)},
    {'name': 'Lavender', 'color': const Color(0xFFF3E8FF)},
    {'name': 'Gold', 'color': const Color(0xFFFEF3C7)},
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

    // If session is ready for review, route to ReviewScreen
    if (session.status == SessionStatus.reviewing && session.photos.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const ReviewScreen()),
        );
      });
    }

    final activeFilter = AppTheme.colorFilters.firstWhere(
      (f) => f.id == _selectedColorFilterId,
      orElse: () => AppTheme.colorFilters.first,
    );

    final selectedBeauty = _beautyModes.firstWhere(
      (b) => b['id'] == _selectedBeautyModeId,
      orElse: () => _beautyModes.first,
    );

    final List<double> activeMatrix = !_isFilterEnabled
        ? <double>[1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0]
        : (_selectedBeautyModeId == 'off'
            ? activeFilter.matrix
            : (selectedBeauty['matrix'] as List<double>));

    return Scaffold(
      backgroundColor: AppTheme.darkBackground,
      appBar: AppBar(
        backgroundColor: AppTheme.surfaceColor,
        elevation: 4,
        title: FittedBox(
          fit: BoxFit.scaleDown,
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [AppTheme.primaryAccent, AppTheme.secondaryAccent],
                  ),
                ),
                child: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 12),
              const Text(
                'PHOTOISM PLATFORM',
                style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1.5, fontSize: 18),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.successColor.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppTheme.successColor),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.fiber_manual_record, size: 10, color: AppTheme.successColor),
                    const SizedBox(width: 6),
                    Text(
                      'SHOT ${session.photos.length}/${session.targetPhotoCount}',
                      style: const TextStyle(fontSize: 12, color: AppTheme.successColor, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.dashboard_customize, color: AppTheme.goldAccent),
            tooltip: 'Template Editor',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const TemplateEditorScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.monitor_heart, color: AppTheme.secondaryAccent),
            tooltip: 'System Health',
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
            icon: const Icon(Icons.photo_library, color: AppTheme.primaryAccent),
            tooltip: 'Event Gallery',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const GalleryScreen()),
              );
            },
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 768;
          return Stack(
            children: [
              Flex(
                direction: isMobile ? Axis.vertical : Axis.horizontal,
                children: [
                  // Main Camera Preview (Left/Center Column)
                  Expanded(
                    flex: isMobile ? 2 : 3,
                    child: Column(
                  children: [
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(28),
                          border: Border.all(color: AppTheme.primaryAccent.withValues(alpha: 0.5), width: 3),
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.primaryAccent.withValues(alpha: 0.25),
                              blurRadius: 30,
                              spreadRadius: 4,
                            ),
                          ],
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // 1. Live Camera Feed
                            _buildCameraPreview(),

                            // 1b. Real-time Live Filter Blend Overlay Layer
                            if (_isFilterEnabled && (_selectedColorFilterId != 'original' || _selectedBeautyModeId != 'off'))
                              IgnorePointer(
                                child: ColorFiltered(
                                  colorFilter: ColorFilter.matrix(activeMatrix),
                                  child: Container(
                                    color: Colors.white.withValues(alpha: 0.15),
                                  ),
                                ),
                              ),

                            // 2. Realtime Visual AR Sticker Overlay
                            CustomPaint(
                              size: Size.infinite,
                              painter: ARStickerPainter(activeEffectId: session.activeEffectId),
                            ),

                            // 3. Active AR Badge Indicator
                            if (session.activeEffectId != 'none')
                              Positioned(
                                top: 20,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: const Color(0xB3000000),
                                    borderRadius: BorderRadius.circular(30),
                                    border: Border.all(color: AppTheme.secondaryAccent, width: 2),
                                  ),
                                  child: Row(
                                    children: [
                                      Text(
                                        _effects.firstWhere(
                                            (e) => e['id'] == session.activeEffectId,
                                            orElse: () => {'icon': '✨'})['icon']!,
                                        style: const TextStyle(fontSize: 20),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        'AR Sticker: ${_effects.firstWhere((e) => e['id'] == session.activeEffectId)['name']}',
                                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              // 4. TikTok Style Filter ON/OFF Toggle Switch
                              Positioned(
                                top: 20,
                                right: 20,
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _isFilterEnabled = !_isFilterEnabled;
                                    });
                                    _applyWebCssFilter(_isFilterEnabled
                                        ? (_selectedBeautyModeId != 'off' ? _selectedBeautyModeId : _selectedColorFilterId)
                                        : 'none');
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                    decoration: BoxDecoration(
                                      color: _isFilterEnabled ? AppTheme.secondaryAccent : Colors.grey[900],
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: _isFilterEnabled ? Colors.white : Colors.white24,
                                        width: 2,
                                      ),
                                      boxShadow: const [BoxShadow(color: Colors.black54, blurRadius: 10)],
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          _isFilterEnabled ? Icons.auto_awesome : Icons.blur_off,
                                          color: Colors.white,
                                          size: 18,
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          _isFilterEnabled ? 'FILTER: ON' : 'FILTER: OFF',
                                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 11),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),

                              // 5. Floating Studio Control Dock Overlay
                              Positioned(
                                bottom: 12,
                                left: 12,
                                right: 12,
                                child: Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: const Color(0xE60F172A),
                                    borderRadius: BorderRadius.circular(24),
                                    border: Border.all(color: Colors.white24, width: 1.5),
                                    boxShadow: const [BoxShadow(color: Colors.black87, blurRadius: 20)],
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      // Studio Segmented Control Tabs
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          _buildTabButton(0, '🌸 BEAUTY'),
                                          const SizedBox(width: 8),
                                          _buildTabButton(1, '🎨 COLOR SHADERS'),
                                          const SizedBox(width: 8),
                                          _buildTabButton(2, '👑 AR PROPS'),
                                        ],
                                      ),
                                      const SizedBox(height: 10),

                                      // Tab Content View
                                      if (_activeControlTab == 0) ...[
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            _buildHeaderTitle('SELECT BEAUTY MODE'),
                                            Text(
                                              'Smooth: ${(_beautyIntensity * 100).toInt()}%',
                                              style: const TextStyle(color: AppTheme.secondaryAccent, fontSize: 11, fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 6),
                                        SizedBox(
                                          height: 44,
                                          child: ListView.separated(
                                            scrollDirection: Axis.horizontal,
                                            itemCount: _beautyModes.length,
                                            separatorBuilder: (_, __) => const SizedBox(width: 10),
                                            itemBuilder: (context, index) {
                                              final beauty = _beautyModes[index];
                                              final isSelected = beauty['id'] == _selectedBeautyModeId;
                                              return InkWell(
                                                onTap: () {
                                                  setState(() => _selectedBeautyModeId = beauty['id'] as String);
                                                  _applyWebCssFilter(beauty['id'] as String);
                                                },
                                                borderRadius: BorderRadius.circular(14),
                                                child: Container(
                                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                                  decoration: BoxDecoration(
                                                    color: isSelected ? AppTheme.secondaryAccent : AppTheme.darkBackground,
                                                    borderRadius: BorderRadius.circular(14),
                                                    border: Border.all(
                                                      color: isSelected ? Colors.white : Colors.white10,
                                                      width: 2,
                                                    ),
                                                  ),
                                                  child: Row(
                                                    children: [
                                                      Text(beauty['icon'] as String, style: const TextStyle(fontSize: 16)),
                                                      const SizedBox(width: 6),
                                                      Text(
                                                        beauty['name'] as String,
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
                                      ] else if (_activeControlTab == 1) ...[
                                        _buildHeaderTitle('SELECT COLOR FILTER'),
                                        const SizedBox(height: 6),
                                        SizedBox(
                                          height: 44,
                                          child: ListView.separated(
                                            scrollDirection: Axis.horizontal,
                                            itemCount: AppTheme.colorFilters.length,
                                            separatorBuilder: (_, __) => const SizedBox(width: 10),
                                            itemBuilder: (context, index) {
                                              final filter = AppTheme.colorFilters[index];
                                              final isSelected = filter.id == _selectedColorFilterId;
                                              return InkWell(
                                                onTap: () {
                                                  setState(() => _selectedColorFilterId = filter.id);
                                                  _applyWebCssFilter(filter.id);
                                                },
                                                borderRadius: BorderRadius.circular(14),
                                                child: Container(
                                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                                  decoration: BoxDecoration(
                                                    color: isSelected ? AppTheme.primaryAccent : AppTheme.darkBackground,
                                                    borderRadius: BorderRadius.circular(14),
                                                    border: Border.all(
                                                      color: isSelected ? AppTheme.secondaryAccent : Colors.white10,
                                                      width: 2,
                                                    ),
                                                  ),
                                                  child: Row(
                                                    children: [
                                                      Text(filter.icon, style: const TextStyle(fontSize: 16)),
                                                      const SizedBox(width: 6),
                                                      Text(
                                                        filter.name,
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
                                      ] else ...[
                                        _buildHeaderTitle('SELECT AR STICKER & PROP'),
                                        const SizedBox(height: 6),
                                        SizedBox(
                                          height: 44,
                                          child: ListView.separated(
                                            scrollDirection: Axis.horizontal,
                                            itemCount: _effects.length,
                                            separatorBuilder: (_, __) => const SizedBox(width: 10),
                                            itemBuilder: (context, index) {
                                              final effect = _effects[index];
                                              final isSelected = effect['id'] == session.activeEffectId;
                                              return InkWell(
                                                onTap: () => sessionNotifier.selectEffect(effect['id']!),
                                                borderRadius: BorderRadius.circular(14),
                                                child: Container(
                                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                                  decoration: BoxDecoration(
                                                    color: isSelected ? AppTheme.secondaryAccent : AppTheme.darkBackground,
                                                    borderRadius: BorderRadius.circular(14),
                                                    border: Border.all(
                                                      color: isSelected ? Colors.white : Colors.white10,
                                                      width: 2,
                                                    ),
                                                  ),
                                                  child: Row(
                                                    children: [
                                                      Text(effect['icon']!, style: const TextStyle(fontSize: 16)),
                                                      const SizedBox(width: 6),
                                                      Text(
                                                        effect['name']!,
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
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              // Right Sidebar — Life4Cuts Live Photo Strip Preview Panel
              Container(
                width: 280,
                color: AppTheme.surfaceColor,
                padding: const EdgeInsets.all(16),
                child: SingleChildScrollView(
                  child: Column(
                  children: [
                    const Text(
                      'LAYOUT STRIP PREVIEW',
                      style: TextStyle(color: AppTheme.textPrimary, fontWeight: FontWeight.w900, letterSpacing: 1),
                    ),
                    const SizedBox(height: 12),

                    // Preset Layout Selector Buttons
                    Row(
                      children: [
                        Expanded(
                          child: ChoiceChip(
                            label: const Text('Khổ 8'),
                            selected: session.targetPhotoCount == 8,
                            onSelected: (val) => sessionNotifier.selectTargetPhotoCount(8),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ChoiceChip(
                            label: const Text('Khổ 3'),
                            selected: session.targetPhotoCount == 3,
                            onSelected: (val) => sessionNotifier.selectTargetPhotoCount(3),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ChoiceChip(
                            label: const Text('4-Cut'),
                            selected: session.targetPhotoCount == 4,
                            onSelected: (val) => sessionNotifier.selectTargetPhotoCount(4),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Live Strip Visual Canvas Preview
                    SizedBox(
                      height: 250,
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: _selectedFrameColor,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.white24, width: 2),
                          boxShadow: const [
                            BoxShadow(color: Colors.black45, blurRadius: 16, offset: Offset(0, 8)),
                          ],
                        ),
                        child: GridView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: session.targetPhotoCount == 8 ? 2 : 1,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
                            childAspectRatio: 4 / 3,
                          ),
                          itemCount: session.targetPhotoCount,
                          itemBuilder: (context, index) {
                            final bool isCaptured = index < session.photos.length;
                            if (isCaptured) {
                              final photo = session.photos[index];
                              return ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    kIsWeb || photo.localPath.startsWith('data:')
                                        ? Image.network(photo.localPath, fit: BoxFit.cover)
                                        : Image.file(File(photo.localPath), fit: BoxFit.cover),
                                    Positioned(
                                      top: 4,
                                      left: 4,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: const Color(0xB3000000),
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: Text(
                                          '#${index + 1}',
                                          style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }

                            return Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[850],
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.white12),
                              ),
                              child: Center(
                                child: Text(
                                  '#${index + 1}',
                                  style: const TextStyle(color: Colors.white38, fontWeight: FontWeight.bold, fontSize: 12),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Frame Color Picker
                    const Text('FRAME COLOR', style: TextStyle(color: AppTheme.textSecondary, fontSize: 12, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: _frameColors.map((fc) {
                        final Color color = fc['color'] as Color;
                        final bool isSelected = _selectedFrameColor == color;
                        return GestureDetector(
                          onTap: () => setState(() => _selectedFrameColor = color),
                          child: Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: color,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isSelected ? AppTheme.secondaryAccent : Colors.grey,
                                width: isSelected ? 3 : 1,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 20),

                    // MAIN CAPTURE TRIGGER BUTTON
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.secondaryAccent,
                        minimumSize: const Size(double.infinity, 60),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      ),
                      icon: const Icon(Icons.camera_alt, size: 28),
                      label: const Text(
                        'TAKE SNAPSHOT',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, letterSpacing: 1),
                      ),
                      onPressed: session.status == SessionStatus.countingDown
                          ? null
                          : () => sessionNotifier.triggerCountdown(colorMatrix: activeMatrix),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),

        // Countdown Overlay
        if (session.status == SessionStatus.countingDown)
          CountdownOverlay(count: sessionNotifier.countdownRemaining),
      ],
    );
  },
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
            Text('Initializing Camera Stream...', style: TextStyle(color: AppTheme.textSecondary)),
          ],
        ),
      );
    }

    final controller = _cameraService.controller!;
    return LayoutBuilder(
      builder: (context, constraints) {
        return ClipRect(
          child: SizedBox(
            width: constraints.maxWidth,
            height: constraints.maxHeight,
            child: FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: constraints.maxWidth,
                height: constraints.maxWidth *
                    (controller.value.aspectRatio > 0 ? (1 / controller.value.aspectRatio) : (3 / 4)),
                child: CameraPreview(controller),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTabButton(int index, String title) {
    final isSelected = _activeControlTab == index;
    return InkWell(
      onTap: () => setState(() => _activeControlTab = index),
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryAccent : AppTheme.darkBackground,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppTheme.secondaryAccent : Colors.white10,
            width: 2,
          ),
          boxShadow: isSelected
              ? [BoxShadow(color: AppTheme.primaryAccent.withValues(alpha: 0.4), blurRadius: 10)]
              : null,
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.white : AppTheme.textSecondary,
            fontWeight: isSelected ? FontWeight.w900 : FontWeight.bold,
            fontSize: 12,
            letterSpacing: 0.8,
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: const TextStyle(
          color: AppTheme.textSecondary,
          fontSize: 11,
          fontWeight: FontWeight.w900,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _cameraService.dispose();
    super.dispose();
  }
}
