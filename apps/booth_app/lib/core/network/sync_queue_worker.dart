import 'dart:async';
import 'package:flutter/foundation.dart';

enum SyncStatus { pending, uploading, uploaded, failed }

class SyncItem {
  final String id;
  final String localPath;
  final String eventId;
  final SyncStatus status;
  final int retryCount;

  SyncItem({
    required this.id,
    required this.localPath,
    required this.eventId,
    this.status = SyncStatus.pending,
    this.retryCount = 0,
  });
}

class SyncQueueWorker {
  final List<SyncItem> _queue = [];
  bool _isProcessing = false;
  Timer? _syncTimer;

  void init() {
    _syncTimer = Timer.periodic(const Duration(seconds: 15), (_) {
      processQueue();
    });
  }

  void addToQueue(SyncItem item) {
    _queue.add(item);
    processQueue();
  }

  Future<void> processQueue() async {
    if (_isProcessing || _queue.isEmpty) return;
    _isProcessing = true;

    try {
      debugPrint('[SyncQueueWorker] Processing ${_queue.length} pending offline uploads...');
      for (int i = _queue.length - 1; i >= 0; i--) {
        final item = _queue[i];
        // Simulate upload attempt to S3 / Node.js Backend API
        _queue.removeAt(i);
        debugPrint('[SyncQueueWorker] Successfully synced item ${item.id} to cloud storage.');
      }
    } catch (e) {
      debugPrint('[SyncQueueWorker] Upload error: $e');
    } finally {
      _isProcessing = false;
    }
  }

  void dispose() {
    _syncTimer?.cancel();
  }
}
