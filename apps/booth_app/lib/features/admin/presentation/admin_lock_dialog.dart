import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class AdminLockDialog extends StatefulWidget {
  final VoidCallback onUnlocked;

  const AdminLockDialog({super.key, required this.onUnlocked});

  @override
  State<AdminLockDialog> createState() => _AdminLockDialogState();
}

class _AdminLockDialogState extends State<AdminLockDialog> {
  final TextEditingController _pinController = TextEditingController();
  String? _errorMsg;

  void _verifyPin() {
    if (_pinController.text == '1234') {
      Navigator.of(context).pop();
      widget.onUnlocked();
    } else {
      setState(() {
        _errorMsg = 'Invalid Admin Passcode!';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppTheme.surfaceColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Row(
        children: [
          Icon(Icons.lock, color: AppTheme.secondaryAccent),
          SizedBox(width: 10),
          Text('Admin Kiosk Security', style: TextStyle(color: Colors.white)),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Enter 4-digit PIN code to unlock administration controls:', style: TextStyle(color: AppTheme.textSecondary)),
          const SizedBox(height: 16),
          TextField(
            controller: _pinController,
            obscureText: true,
            keyboardType: TextInputType.number,
            maxLength: 4,
            style: const TextStyle(color: Colors.white, fontSize: 24, letterSpacing: 8),
            decoration: InputDecoration(
              filled: true,
              fillColor: AppTheme.darkBackground,
              errorText: _errorMsg,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('CANCEL', style: TextStyle(color: AppTheme.textSecondary)),
        ),
        ElevatedButton(
          onPressed: _verifyPin,
          child: const Text('UNLOCK'),
        ),
      ],
    );
  }
}
