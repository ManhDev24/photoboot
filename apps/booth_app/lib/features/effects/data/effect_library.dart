import '../domain/effect_definition.dart';

class EffectLibrary {
  static const List<EffectDefinition> arEffects = [
    EffectDefinition(
      id: 'none',
      name: 'Original',
      category: 'FACE',
      icon: '✨',
      anchor: AnchorType.screen,
    ),
    EffectDefinition(
      id: 'crown',
      name: 'Crown',
      category: 'FACE',
      icon: '👑',
      anchor: AnchorType.forehead,
      scaleFactor: 1.2,
    ),
    EffectDefinition(
      id: 'glasses',
      name: 'Glasses',
      category: 'FACE',
      icon: '😎',
      anchor: AnchorType.eyes,
      scaleFactor: 1.1,
    ),
    EffectDefinition(
      id: 'bunny',
      name: 'Bunny',
      category: 'FACE',
      icon: '🐰',
      anchor: AnchorType.forehead,
      scaleFactor: 1.4,
    ),
    EffectDefinition(
      id: 'hearts',
      name: 'Hearts',
      category: 'PARTICLE',
      icon: '❤️',
      anchor: AnchorType.screen,
      hasParticles: true,
    ),
    EffectDefinition(
      id: 'fire',
      name: 'Fire',
      category: 'PARTICLE',
      icon: '🔥',
      anchor: AnchorType.body,
      hasParticles: true,
    ),
  ];

  static EffectDefinition getById(String id) {
    return arEffects.firstWhere(
      (e) => e.id == id,
      orElse: () => arEffects.first,
    );
  }
}
