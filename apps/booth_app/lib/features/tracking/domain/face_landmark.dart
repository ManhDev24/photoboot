class LandmarkPoint {
  final double x;
  final double y;
  final double z;

  const LandmarkPoint({required this.x, required this.y, this.z = 0.0});

  factory LandmarkPoint.fromJson(Map<String, dynamic> json) => LandmarkPoint(
        x: (json['x'] as num).toDouble(),
        y: (json['y'] as num).toDouble(),
        z: (json['z'] as num?)?.toDouble() ?? 0.0,
      );

  Map<String, dynamic> toJson() => {'x': x, 'y': y, 'z': z};
}

class FaceLandmarks {
  final LandmarkPoint forehead;
  final LandmarkPoint leftEye;
  final LandmarkPoint rightEye;
  final LandmarkPoint nose;
  final LandmarkPoint mouth;
  final LandmarkPoint chin;
  final double confidence;

  const FaceLandmarks({
    required this.forehead,
    required this.leftEye,
    required this.rightEye,
    required this.nose,
    required this.mouth,
    required this.chin,
    this.confidence = 0.95,
  });

  factory FaceLandmarks.defaultFace() {
    return const FaceLandmarks(
      forehead: LandmarkPoint(x: 0.5, y: 0.3),
      leftEye: LandmarkPoint(x: 0.4, y: 0.45),
      rightEye: LandmarkPoint(x: 0.6, y: 0.45),
      nose: LandmarkPoint(x: 0.5, y: 0.55),
      mouth: LandmarkPoint(x: 0.5, y: 0.7),
      chin: LandmarkPoint(x: 0.5, y: 0.85),
    );
  }

  factory FaceLandmarks.fromJson(Map<String, dynamic> json) => FaceLandmarks(
        forehead: LandmarkPoint.fromJson(json['forehead']),
        leftEye: LandmarkPoint.fromJson(json['leftEye']),
        rightEye: LandmarkPoint.fromJson(json['rightEye']),
        nose: LandmarkPoint.fromJson(json['nose']),
        mouth: LandmarkPoint.fromJson(json['mouth']),
        chin: LandmarkPoint.fromJson(json['chin']),
        confidence: (json['confidence'] as num?)?.toDouble() ?? 0.95,
      );

  Map<String, dynamic> toJson() => {
        'forehead': forehead.toJson(),
        'leftEye': leftEye.toJson(),
        'rightEye': rightEye.toJson(),
        'nose': nose.toJson(),
        'mouth': mouth.toJson(),
        'chin': chin.toJson(),
        'confidence': confidence,
      };
}
