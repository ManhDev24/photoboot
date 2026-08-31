enum BackgroundType { original, blur, solidColor, gradient, imageAsset }

class BackgroundItem {
  final String id;
  final String name;
  final String category;
  final String icon;
  final BackgroundType type;
  final String? assetPath;
  final List<int>? colorValues;

  const BackgroundItem({
    required this.id,
    required this.name,
    required this.category,
    required this.icon,
    required this.type,
    this.assetPath,
    this.colorValues,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'category': category,
        'icon': icon,
        'type': type.name,
        'assetPath': assetPath,
      };
}
