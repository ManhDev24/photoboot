import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../../core/storage/local_storage_service.dart';
import '../../../../core/theme/app_theme.dart';

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  List<Map<String, dynamic>> _savedSessions = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadGallery();
  }

  Future<void> _loadGallery() async {
    final sessions = await LocalStorageService.getAllSessions();
    if (mounted) {
      setState(() {
        _savedSessions = sessions.reversed.toList(); // Newest first
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.darkBackground,
      appBar: AppBar(
        title: const Text('OFFLINE EVENT GALLERY'),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppTheme.secondaryAccent))
          : _savedSessions.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.photo_album_outlined, size: 64, color: AppTheme.textSecondary),
                      SizedBox(height: 16),
                      Text(
                        'No captured sessions in local storage yet.',
                        style: TextStyle(color: AppTheme.textSecondary, fontSize: 16),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _savedSessions.length,
                  itemBuilder: (context, sessionIdx) {
                    final sessionData = _savedSessions[sessionIdx];
                    final photosRaw = (sessionData['photos'] as List<dynamic>?) ?? [];
                    final createdAt = DateTime.tryParse(sessionData['createdAt'] ?? '') ?? DateTime.now();

                    return Container(
                      margin: const EdgeInsets.only(bottom: 20),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceColor,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppTheme.primaryAccent.withOpacity(0.3)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'SESSION #${_savedSessions.length - sessionIdx}',
                                style: const TextStyle(
                                  color: AppTheme.primaryAccent,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                '${createdAt.hour.toString().padLeft(2, '0')}:${createdAt.minute.toString().padLeft(2, '0')} - ${photosRaw.length} Photos',
                                style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            height: 100,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: photosRaw.length,
                              separatorBuilder: (_, __) => const SizedBox(width: 10),
                              itemBuilder: (context, photoIdx) {
                                final photoMap = photosRaw[photoIdx] as Map<String, dynamic>;
                                final path = photoMap['localPath'] as String? ?? '';
                                return ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Container(
                                    width: 130,
                                    height: 100,
                                    color: Colors.black,
                                    child: kIsWeb || path.startsWith('data:')
                                        ? Image.network(path, fit: BoxFit.cover)
                                        : Image.file(File(path), fit: BoxFit.cover),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
    );
  }
}
