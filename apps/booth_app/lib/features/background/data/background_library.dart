import '../domain/background_item.dart';

class BackgroundLibrary {
  static const List<BackgroundItem> backgrounds = [
    BackgroundItem(
      id: 'none',
      name: 'Original',
      category: 'DEFAULT',
      icon: '🖼️',
      type: BackgroundType.original,
    ),
    BackgroundItem(
      id: 'blur',
      name: 'Blur FX',
      category: 'EFFECT',
      icon: '💧',
      type: BackgroundType.blur,
    ),
    BackgroundItem(
      id: 'wedding',
      name: 'Wedding',
      category: 'EVENT',
      icon: '💒',
      type: BackgroundType.gradient,
      colorValues: [0xFFFCE7F3, 0xFFFBCFE8],
    ),
    BackgroundItem(
      id: 'galaxy',
      name: 'Galaxy',
      category: 'SPACE',
      icon: '🌌',
      type: BackgroundType.gradient,
      colorValues: [0xFF0F172A, 0xFF312E81],
    ),
    BackgroundItem(
      id: 'studio',
      name: 'Studio',
      category: 'PROFESSIONAL',
      icon: '🎨',
      type: BackgroundType.solidColor,
      colorValues: [0xFF1E293B],
    ),
  ];

  static BackgroundItem getById(String id) {
    return backgrounds.firstWhere(
      (b) => b.id == id,
      orElse: () => backgrounds.first,
    );
  }
}
