import '../../layout/domain/layout_definition.dart';

class TemplateElement {
  final String id;
  final String type; // TEXT, LOGO, FRAME, QR
  final double x;
  final double y;
  final double width;
  final double height;
  final String content; // Text content or image path

  const TemplateElement({
    required this.id,
    required this.type,
    required this.x,
    required this.y,
    required this.width,
    required this.height,
    required this.content,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type,
        'x': x,
        'y': y,
        'width': width,
        'height': height,
        'content': content,
      };

  factory TemplateElement.fromJson(Map<String, dynamic> json) => TemplateElement(
        id: json['id'] as String,
        type: json['type'] as String,
        x: (json['x'] as num).toDouble(),
        y: (json['y'] as num).toDouble(),
        width: (json['width'] as num).toDouble(),
        height: (json['height'] as num).toDouble(),
        content: json['content'] as String,
      );
}

class TemplateDefinition {
  final String id;
  final String name;
  final int version;
  final LayoutDefinition layout;
  final String backgroundColorHex;
  final String? frameOverlayPath;
  final List<TemplateElement> elements;

  const TemplateDefinition({
    required this.id,
    required this.name,
    this.version = 1,
    required this.layout,
    this.backgroundColorHex = '#0F172A',
    this.frameOverlayPath,
    required this.elements,
  });

  factory TemplateDefinition.defaultWedding() {
    final layout = LayoutDefinition.kho8();
    return TemplateDefinition(
      id: 'wedding_01',
      name: 'Wedding Elegant Pink',
      layout: layout,
      backgroundColorHex: '#FCE7F3',
      elements: const [
        TemplateElement(
          id: 'title_text',
          type: 'TEXT',
          x: 0.1,
          y: 0.92,
          width: 0.8,
          height: 0.05,
          content: 'HAPPY WEDDING • ANNA & JOHN',
        ),
      ],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'version': version,
        'layout': layout.toJson(),
        'backgroundColorHex': backgroundColorHex,
        'frameOverlayPath': frameOverlayPath,
        'elements': elements.map((e) => e.toJson()).toList(),
      };
}
