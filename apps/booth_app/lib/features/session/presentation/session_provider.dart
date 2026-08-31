import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/storage/local_storage_service.dart';
import '../../../core/utils/image_filter_utils.dart';
import '../../camera/data/platform_camera_service.dart';
import '../../camera/domain/camera_service.dart';
import '../../photo/domain/captured_photo.dart';
import '../domain/photo_session.dart';

final cameraServiceProvider = Provider<CameraService>((ref) {
  return PlatformCameraService();
});

class SessionStateNotifier extends StateNotifier<PhotoSession> {
  final CameraService _cameraService;
  Timer? _countdownTimer;
  int _countdownRemaining = 0;

  int get countdownRemaining => _countdownRemaining;

  SessionStateNotifier(this._cameraService) : super(PhotoSession.initial()) {
    _checkAndRecoverSession();
  }

  Future<void> _checkAndRecoverSession() async {
    final recoveredJson = await LocalStorageService.getActiveSession();
    if (recoveredJson != null) {
      try {
        final recoveredSession = PhotoSession.fromJson(recoveredJson);
        if (recoveredSession.photos.isNotEmpty && recoveredSession.status != SessionStatus.completed) {
          state = recoveredSession.copyWith(status: SessionStatus.reviewing);
          debugPrint('Session recovered successfully with ${recoveredSession.photos.length} photos!');
        }
      } catch (e) {
        debugPrint('Failed to recover session: $e');
        await LocalStorageService.clearActiveSession();
      }
    }
  }

  void startNewSession({int photoCount = 4}) {
    state = PhotoSession.initial(targetCount: photoCount);
    LocalStorageService.saveActiveSession(state.toJson());
  }

  void selectTargetPhotoCount(int count) {
    state = state.copyWith(targetPhotoCount: count);
  }

  void selectEffect(String effectId) {
    state = state.copyWith(activeEffectId: effectId);
  }

  void selectBackground(String bgId) {
    state = state.copyWith(activeBackgroundId: bgId);
  }

  void triggerCountdown({List<double>? colorMatrix, VoidCallback? onSnap}) {
    if (state.status == SessionStatus.countingDown || state.status == SessionStatus.capturing) {
      return;
    }

    _countdownRemaining = AppConstants.defaultCountdownSeconds;
    state = state.copyWith(status: SessionStatus.countingDown);

    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      _countdownRemaining--;
      if (_countdownRemaining <= 0) {
        timer.cancel();
        state = state.copyWith(status: SessionStatus.capturing);
        onSnap?.call();
        await captureCurrentFrameWithFilter(colorMatrix ?? [
          1, 0, 0, 0, 0,
          0, 1, 0, 0, 0,
          0, 0, 1, 0, 0,
          0, 0, 0, 1, 0,
        ]);
      } else {
        // Trigger state rebuild for countdown UI
        state = state.copyWith();
      }
    });
  }

  Future<void> captureCurrentFrameWithFilter(List<double> colorMatrix) async {
    final file = await _cameraService.capturePhoto();
    if (file != null) {
      final rawBytes = await file.readAsBytes();
      // Apply selected Color Matrix filter directly to captured photo bytes
      final processedBytes = await ImageFilterUtils.applyColorMatrixFilter(rawBytes, colorMatrix);
      
      final filename = 'photo_${const Uuid().v4()}.png';
      final localPath = await LocalStorageService.saveImageBytes(processedBytes, filename);

      final captured = CapturedPhoto(
        id: const Uuid().v4(),
        index: state.photos.length + 1,
        localPath: localPath,
        capturedAt: DateTime.now(),
        filterName: state.activeEffectId,
      );

      final updatedPhotos = List<CapturedPhoto>.from(state.photos)..add(captured);
      final isFinished = updatedPhotos.length >= state.targetPhotoCount;

      state = state.copyWith(
        photos: updatedPhotos,
        currentPhotoIndex: updatedPhotos.length,
        status: isFinished ? SessionStatus.reviewing : SessionStatus.idle,
      );

      // Persist session state after EVERY single capture (Requirement 103)
      await LocalStorageService.saveActiveSession(state.toJson());
    } else {
      // Fallback if hardware failed
      state = state.copyWith(status: SessionStatus.idle);
    }
  }

  Future<void> retakePhoto(int index) async {
    if (index >= 0 && index < state.photos.length) {
      final updatedPhotos = List<CapturedPhoto>.from(state.photos)..removeAt(index);
      state = state.copyWith(
        photos: updatedPhotos,
        currentPhotoIndex: updatedPhotos.length,
        status: SessionStatus.idle,
      );
      await LocalStorageService.saveActiveSession(state.toJson());
    }
  }

  Future<void> retakeAll() async {
    state = PhotoSession.initial(targetCount: state.targetPhotoCount);
    await LocalStorageService.saveActiveSession(state.toJson());
  }

  Future<void> completeSession() async {
    final completedState = state.copyWith(status: SessionStatus.completed);
    await LocalStorageService.saveCompletedSession(completedState.toJson());
    state = PhotoSession.initial();
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    super.dispose();
  }
}

final sessionNotifierProvider = StateNotifierProvider<SessionStateNotifier, PhotoSession>((ref) {
  final cameraService = ref.watch(cameraServiceProvider);
  return SessionStateNotifier(cameraService);
});
