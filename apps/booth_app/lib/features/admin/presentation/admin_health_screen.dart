import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class AdminHealthScreen extends StatelessWidget {
  const AdminHealthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final healthItems = [
      {'name': 'Camera Hardware', 'status': 'READY', 'ok': true, 'icon': Icons.camera_alt},
      {'name': 'Photo Printer Service', 'status': 'READY', 'ok': true, 'icon': Icons.print},
      {'name': 'Local Storage Space', 'status': 'READY (48 GB Free)', 'ok': true, 'icon': Icons.storage},
      {'name': 'AR Effects Cache', 'status': 'READY (Loaded)', 'ok': true, 'icon': Icons.auto_awesome},
      {'name': 'Template & Layout Assets', 'status': 'READY (Cached)', 'ok': true, 'icon': Icons.space_dashboard},
      {'name': 'Internet Connectivity', 'status': 'ONLINE', 'ok': true, 'icon': Icons.wifi},
      {'name': 'Cloud Upload Queue', 'status': 'READY (0 Pending)', 'ok': true, 'icon': Icons.cloud_done},
    ];

    return Scaffold(
      backgroundColor: AppTheme.darkBackground,
      appBar: AppBar(
        title: const Text('ADMIN KIOSK SYSTEM HEALTH STATUS'),
        centerTitle: true,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(20),
        itemCount: healthItems.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final item = healthItems[index];
          final bool isOk = item['ok'] as bool;

          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.surfaceColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isOk ? AppTheme.successColor.withOpacity(0.4) : Colors.redAccent,
              ),
            ),
            child: Row(
              children: [
                Icon(item['icon'] as IconData, color: isOk ? AppTheme.successColor : Colors.redAccent, size: 28),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    item['name'] as String,
                    style: const TextStyle(color: AppTheme.textPrimary, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: (isOk ? AppTheme.successColor : Colors.redAccent).withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    item['status'] as String,
                    style: TextStyle(
                      color: isOk ? AppTheme.successColor : Colors.redAccent,
                      fontWeight: FontWeight.bold,
                    ),
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
