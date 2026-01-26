
import 'package:flutter/cupertino.dart';

class DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xff252525)
      ..strokeWidth = 1;

    const dashWidth = 2.0;
    const dashSpace = 2.0;
    double startY = 0;

    while (startY < size.height) {
      canvas.drawLine(
        Offset(0, startY),
        Offset(0, startY + dashWidth),
        paint,
      );
      startY += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}