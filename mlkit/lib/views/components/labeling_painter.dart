
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';

class LabelDetectorPainter extends CustomPainter {
  final List<ImageLabel> labels;

  LabelDetectorPainter(this.labels);

  @override
  void paint(Canvas canvas, Size size) {
    final ui.ParagraphBuilder builder = ui.ParagraphBuilder(
      ui.ParagraphStyle(textAlign: TextAlign.left, fontSize: 16),
    );

    builder.pushStyle(ui.TextStyle(color: Colors.green));
    for (final label in labels) {
      builder.addText('${label.label} (${label.confidence.toStringAsFixed(2)})\n');
    }
    builder.pop();

    canvas.drawParagraph(
      builder.build()..layout(ui.ParagraphConstraints(width: size.width)),
      Offset.zero,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
