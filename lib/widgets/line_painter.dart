import 'package:flutter/material.dart';
import '../models/person_model.dart';

class LinePainter extends CustomPainter {
  final Map<String, PersonNode> nodes;
  final List<Relationship> relations;

  LinePainter(this.nodes, this.relations);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.brown[200]!
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    for (var rel in relations) {
      final start = nodes[rel.fromId];
      final end = nodes[rel.toId];
      if (start != null && end != null) {
        // 画线逻辑...
        canvas.drawLine(
          start.position + const Offset(40, 20),
          end.position + const Offset(40, 20),
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}