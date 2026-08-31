class PhotoSlot {
  final int index;
  final double x; // Percentage (0.0 to 1.0)
  final double y;
  final double width;
  final double height;
  final double rotation;

  const PhotoSlot({
    required this.index,
    required this.x,
    required this.y,
    required this.width,
    required this.height,
    this.rotation = 0.0,
  });

  Map<String, dynamic> toJson() => {
        'index': index,
        'x': x,
        'y': y,
        'width': width,
        'height': height,
        'rotation': rotation,
      };

  factory PhotoSlot.fromJson(Map<String, dynamic> json) => PhotoSlot(
        index: json['index'] as int,
        x: (json['x'] as num).toDouble(),
        y: (json['y'] as num).toDouble(),
        width: (json['width'] as num).toDouble(),
        height: (json['height'] as num).toDouble(),
        rotation: (json['rotation'] as num?)?.toDouble() ?? 0.0,
      );
}

enum LayoutType { kho8, kho3, custom }

class LayoutDefinition {
  final String id;
  final String name;
  final LayoutType type;
  final int canvasWidth;
  final int canvasHeight;
  final double aspectRatio;
  final List<PhotoSlot> photoSlots;

  const LayoutDefinition({
    required this.id,
    required this.name,
    required this.type,
    required this.canvasWidth,
    required this.canvasHeight,
    required this.aspectRatio,
    required this.photoSlots,
  });

  // Preset Khổ 8 (8 slots 2x4 vertical strip layout)
  factory LayoutDefinition.kho8() {
    final List<PhotoSlot> slots = [];
    double slotW = 0.42;
    double slotH = 0.20;
    for (int i = 0; i < 8; i++) {
      int row = i ~/ 2;
      int col = i % 2;
      slots.add(PhotoSlot(
        index: i,
        x: 0.05 + col * 0.46,
        y: 0.04 + row * 0.22,
        width: slotW,
        height: slotH,
      ));
    }
    return LayoutDefinition(
      id: 'kho_8_preset',
      name: 'Khổ 8 (2x4 Strip)',
      type: LayoutType.kho8,
      canvasWidth: 1200,
      canvasHeight: 1800,
      aspectRatio: 2 / 3,
      photoSlots: slots,
    );
  }

  // Preset Khổ 3 (3 vertical photo slots)
  factory LayoutDefinition.kho3() {
    final List<PhotoSlot> slots = [];
    for (int i = 0; i < 3; i++) {
      slots.add(PhotoSlot(
        index: i,
        x: 0.08,
        y: 0.05 + i * 0.28,
        width: 0.84,
        height: 0.25,
      ));
    }
    return LayoutDefinition(
      id: 'kho_3_preset',
      name: 'Khổ 3 (3-Vertical Strip)',
      type: LayoutType.kho3,
      canvasWidth: 1200,
      canvasHeight: 1800,
      aspectRatio: 2 / 3,
      photoSlots: slots,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'type': type.name,
        'canvasWidth': canvasWidth,
        'canvasHeight': canvasHeight,
        'aspectRatio': aspectRatio,
        'photoSlots': photoSlots.map((s) => s.toJson()).toList(),
      };
}
