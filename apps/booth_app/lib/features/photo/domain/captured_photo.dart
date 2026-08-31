class CapturedPhoto {
  final String id;
  final int index;
  final String localPath;
  final DateTime capturedAt;
  final String? filterName;

  CapturedPhoto({
    required this.id,
    required this.index,
    required this.localPath,
    required this.capturedAt,
    this.filterName,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'index': index,
        'localPath': localPath,
        'capturedAt': capturedAt.toIso8601String(),
        'filterName': filterName,
      };

  factory CapturedPhoto.fromJson(Map<String, dynamic> json) => CapturedPhoto(
        id: json['id'] as String,
        index: json['index'] as int,
        localPath: json['localPath'] as String,
        capturedAt: DateTime.parse(json['capturedAt'] as String),
        filterName: json['filterName'] as String?,
      );
}
