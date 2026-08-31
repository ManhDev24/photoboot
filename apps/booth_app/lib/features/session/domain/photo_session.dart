import '../../photo/domain/captured_photo.dart';

enum SessionStatus { idle, countingDown, capturing, reviewing, completed }

class PhotoSession {
  final String id;
  final String eventId;
  final int targetPhotoCount;
  final List<CapturedPhoto> photos;
  final SessionStatus status;
  final int currentPhotoIndex;
  final String activeEffectId;
  final String activeBackgroundId;
  final DateTime createdAt;

  PhotoSession({
    required this.id,
    required this.eventId,
    required this.targetPhotoCount,
    required this.photos,
    required this.status,
    required this.currentPhotoIndex,
    required this.activeEffectId,
    required this.activeBackgroundId,
    required this.createdAt,
  });

  factory PhotoSession.initial({int targetCount = 4, String eventId = 'default_event'}) {
    return PhotoSession(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      eventId: eventId,
      targetPhotoCount: targetCount,
      photos: [],
      status: SessionStatus.idle,
      currentPhotoIndex: 0,
      activeEffectId: 'none',
      activeBackgroundId: 'none',
      createdAt: DateTime.now(),
    );
  }

  PhotoSession copyWith({
    String? id,
    String? eventId,
    int? targetPhotoCount,
    List<CapturedPhoto>? photos,
    SessionStatus? status,
    int? currentPhotoIndex,
    String? activeEffectId,
    String? activeBackgroundId,
    DateTime? createdAt,
  }) {
    return PhotoSession(
      id: id ?? this.id,
      eventId: eventId ?? this.eventId,
      targetPhotoCount: targetPhotoCount ?? this.targetPhotoCount,
      photos: photos ?? this.photos,
      status: status ?? this.status,
      currentPhotoIndex: currentPhotoIndex ?? this.currentPhotoIndex,
      activeEffectId: activeEffectId ?? this.activeEffectId,
      activeBackgroundId: activeBackgroundId ?? this.activeBackgroundId,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'eventId': eventId,
        'targetPhotoCount': targetPhotoCount,
        'photos': photos.map((p) => p.toJson()).toList(),
        'status': status.name,
        'currentPhotoIndex': currentPhotoIndex,
        'activeEffectId': activeEffectId,
        'activeBackgroundId': activeBackgroundId,
        'createdAt': createdAt.toIso8601String(),
      };

  factory PhotoSession.fromJson(Map<String, dynamic> json) => PhotoSession(
        id: json['id'] as String,
        eventId: json['eventId'] as String,
        targetPhotoCount: json['targetPhotoCount'] as int,
        photos: (json['photos'] as List<dynamic>)
            .map((p) => CapturedPhoto.fromJson(Map<String, dynamic>.from(p as Map)))
            .toList(),
        status: SessionStatus.values.firstWhere(
          (e) => e.name == json['status'],
          orElse: () => SessionStatus.idle,
        ),
        currentPhotoIndex: json['currentPhotoIndex'] as int,
        activeEffectId: json['activeEffectId'] as String? ?? 'none',
        activeBackgroundId: json['activeBackgroundId'] as String? ?? 'none',
        createdAt: DateTime.parse(json['createdAt'] as String),
      );
}
