import 'package:flutter/material.dart';

class DashedBorderPainter extends CustomPainter {
  final bool isExpired;

  DashedBorderPainter({super.repaint, this.isExpired = false});
  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color =
              isExpired
                  ? Colors.grey
                  : Color(0xFF0062CC) // Set color for dashed border
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2;

    const dashWidth = 6.0;
    const dashSpace = 10.0;
    double startX = 0;

    // Top border
    while (startX < size.width) {
      canvas.drawLine(Offset(startX, 0), Offset(startX + dashWidth, 0), paint);
      startX += dashWidth + dashSpace;
    }

    // Bottom border
    startX = 0;
    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, size.height),
        Offset(startX + dashWidth, size.height),
        paint,
      );
      startX += dashWidth + dashSpace;
    }

    // Left border
    double startY = 0;
    while (startY < size.height) {
      canvas.drawLine(Offset(0, startY), Offset(0, startY + dashWidth), paint);
      startY += dashWidth + dashSpace;
    }

    // Right border
    startY = 0;
    while (startY < size.height) {
      canvas.drawLine(
        Offset(size.width, startY),
        Offset(size.width, startY + dashWidth),
        paint,
      );
      startY += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
