import 'package:flutter/material.dart';

const _navy = Color(0xFF061D3F);

/// A reusable yes/no confirmation dialog for any destructive or otherwise
/// consequential action. Returns `true` if the user confirmed, `false` if
/// they cancelled or dismissed it (tapping outside, back button, etc.).
Future<bool> showConfirmationModal(
  BuildContext context, {
  required String title,
  required String message,
  String confirmLabel = 'Confirm',
  String cancelLabel = 'Cancel',
  bool isDestructive = false,
}) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: _navy, width: 1),
        borderRadius: BorderRadius.circular(24),
      ),
      backgroundColor: Colors.white,
      title: Text(
        title,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: _navy,
          fontSize: 22,
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.w700,
        ),
      ),
      content: Text(
        message,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: _navy,
          fontSize: 15,
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.w500,
        ),
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        OutlinedButton(
          style: OutlinedButton.styleFrom(
            foregroundColor: _navy,
            side: const BorderSide(color: _navy),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
          ),
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(cancelLabel),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: isDestructive ? const Color(0xFFD32F2F) : _navy,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
          ),
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(confirmLabel),
        ),
      ],
    ),
  );
  return confirmed ?? false;
}
