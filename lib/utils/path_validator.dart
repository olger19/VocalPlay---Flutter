import 'package:flutter/material.dart';

class PathValidator {
  static bool validateTracing(List<Offset> userPoints, Path letterPath, {double tolerance = 20.0}) {
    int validPoints = 0;

    for (final point in userPoints) {
      if (letterPath.contains(point) || 
          _isPointNearPath(point, letterPath, tolerance)) {
        validPoints++;
      }
    }

    return validPoints >= userPoints.length * 0.9;
  }

  static bool _isPointNearPath(Offset point, Path path, double tolerance) {
    for (final metric in path.computeMetrics()) {
      for (double distance = 0; distance <= metric.length; distance += 1) {
        final tangent = metric.getTangentForOffset(distance);
        if (tangent != null && (tangent.position - point).distance <= tolerance) {
          return true;
        }
      }
    }
    return false;
  }
}