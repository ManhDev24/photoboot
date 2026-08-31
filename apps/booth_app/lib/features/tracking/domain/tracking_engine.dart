import 'face_landmark.dart';

abstract class TrackingEngine {
  Future<void> initialize();
  Future<FaceLandmarks?> detectFaceLandmarks();
  void setActiveEffect(String effectId);
  void dispose();
}
