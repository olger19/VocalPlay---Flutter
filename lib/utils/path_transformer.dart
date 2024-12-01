import 'package:flutter/material.dart';

class PathTransformer {
  static Path scaleAndCenter(Path path, Size size, {double scaleFactor = 0.5}) {
    final Rect bounds = path.getBounds();

    final double scale = (size.width * scaleFactor) / bounds.width;
    final double scaledHeight = bounds.height * scale;

    final double dx = (size.width - bounds.width * scale) / 2;
    final double dy = (size.height - scaledHeight) / 2;

    final Matrix4 matrix = Matrix4.identity()
      ..scale(scale, scale)
      ..translate(dx / scale - bounds.left, dy / scale - bounds.top);

    return path.transform(matrix.storage);
  }
}