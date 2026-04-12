import 'package:flutter/material.dart';

class QrScannerOverlayShape extends ShapeBorder {
  final Color borderColor;
  final double borderWidth;
  final Color overlayColor;
  final double borderRadius;
  final double borderLength;
  final double cutOutSize;

  const QrScannerOverlayShape({
    this.borderColor = Colors.white,
    this.borderWidth = 4.0,
    this.overlayColor = const Color.fromRGBO(0, 0, 0, 80),
    this.borderRadius = 10,
    this.borderLength = 40,
    this.cutOutSize = 250,
  });

  @override
  EdgeInsetsGeometry get dimensions => const EdgeInsets.all(10);

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return Path()
      ..fillType = PathFillType.evenOdd
      ..addPath(getOuterPath(rect), Offset.zero);
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    Path getLeftTopPath(Rect rect) {
      return Path()
        ..moveTo(rect.left, rect.bottom)
        ..lineTo(rect.left, rect.top)
        ..lineTo(rect.right, rect.top);
    }

    return getLeftTopPath(rect)
      ..lineTo(rect.right, rect.bottom)
      ..lineTo(rect.left, rect.bottom)
      ..lineTo(rect.left, rect.top);
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    final width = rect.width;
    final borderWidthSize = width / 2;
    final height = rect.height;
    final borderOffset = borderWidth / 2;
    final effectiveBorderLength =
        borderLength > cutOutSize / 2 + borderWidthSize
        ? borderWidthSize / 2
        : borderLength;
    final effectiveCutOutSize = cutOutSize < width
        ? cutOutSize
        : width - borderOffset;

    final backgroundPaint = Paint()
      ..color = overlayColor
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth;

    final boxPaint = Paint()
      ..color = overlayColor
      ..style = PaintingStyle.fill
      ..blendMode = BlendMode.dstOut;

    final cutOutRect = Rect.fromLTWH(
      rect.left + width / 2 - effectiveCutOutSize / 2 + borderOffset,
      rect.top + height / 2 - effectiveCutOutSize / 2 + borderOffset,
      effectiveCutOutSize - borderOffset * 2,
      effectiveCutOutSize - borderOffset * 2,
    );

    canvas
      ..saveLayer(rect, backgroundPaint)
      ..drawRect(rect, backgroundPaint)
      // Draw the transparent cutout square
      ..drawRRect(
        RRect.fromRectAndCorners(
          cutOutRect,
          topLeft: Radius.circular(borderRadius),
          topRight: Radius.circular(borderRadius),
          bottomLeft: Radius.circular(borderRadius),
          bottomRight: Radius.circular(borderRadius),
        ),
        boxPaint,
      )
      ..restore();

    // Draw Top Left Bracket
    canvas.drawPath(
      Path()
        ..moveTo(cutOutRect.left, cutOutRect.top + effectiveBorderLength)
        ..lineTo(cutOutRect.left, cutOutRect.top + borderRadius)
        ..arcToPoint(
          Offset(cutOutRect.left + borderRadius, cutOutRect.top),
          radius: Radius.circular(borderRadius),
        )
        ..lineTo(cutOutRect.left + effectiveBorderLength, cutOutRect.top),
      borderPaint,
    );

    // Draw Top Right Bracket
    canvas.drawPath(
      Path()
        ..moveTo(cutOutRect.right, cutOutRect.top + effectiveBorderLength)
        ..lineTo(cutOutRect.right, cutOutRect.top + borderRadius)
        ..arcToPoint(
          Offset(cutOutRect.right - borderRadius, cutOutRect.top),
          radius: Radius.circular(borderRadius),
          clockwise: false,
        )
        ..lineTo(cutOutRect.right - effectiveBorderLength, cutOutRect.top),
      borderPaint,
    );

    // Draw Bottom Right Bracket
    canvas.drawPath(
      Path()
        ..moveTo(cutOutRect.right, cutOutRect.bottom - effectiveBorderLength)
        ..lineTo(cutOutRect.right, cutOutRect.bottom - borderRadius)
        ..arcToPoint(
          Offset(cutOutRect.right - borderRadius, cutOutRect.bottom),
          radius: Radius.circular(borderRadius),
        )
        ..lineTo(cutOutRect.right - effectiveBorderLength, cutOutRect.bottom),
      borderPaint,
    );

    // Draw Bottom Left Bracket
    canvas.drawPath(
      Path()
        ..moveTo(cutOutRect.left, cutOutRect.bottom - effectiveBorderLength)
        ..lineTo(cutOutRect.left, cutOutRect.bottom - borderRadius)
        ..arcToPoint(
          Offset(cutOutRect.left + borderRadius, cutOutRect.bottom),
          radius: Radius.circular(borderRadius),
          clockwise: false,
        )
        ..lineTo(cutOutRect.left + effectiveBorderLength, cutOutRect.bottom),
      borderPaint,
    );
  }

  @override
  ShapeBorder scale(double t) {
    return QrScannerOverlayShape(
      borderColor: borderColor,
      borderWidth: borderWidth,
      overlayColor: overlayColor,
    );
  }
}
