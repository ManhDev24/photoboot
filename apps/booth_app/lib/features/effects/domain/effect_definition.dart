enum AnchorType { forehead, eyes, nose, mouth, body, screen }

class EffectDefinition {
  final String id;
  final String name;
  final String category;
  final String icon;
  final AnchorType anchor;
  final double scaleFactor;
  final bool hasParticles;

  const EffectDefinition({
    required this.id,
    required this.name,
    required this.category,
    required this.icon,
    required this.anchor,
    this.scaleFactor = 1.0,
    this.hasParticles = false,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'category': category,
        'icon': icon,
        'anchor': anchor.name,
        'scaleFactor': scaleFactor,
        'hasParticles': hasParticles,
      };
}
