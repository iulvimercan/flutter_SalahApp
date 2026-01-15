import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Utility class for responsive sizing that handles orientation changes correctly.
///
/// In portrait mode: width is relative to 412, height is relative to 917
/// In landscape mode: width is relative to 917, height is relative to 412
///
/// This ensures consistent visual sizing across orientations.
class Responsive {
  static const double _designWidth = 412;
  static const double _designHeight = 917;

  /// Get responsive width that accounts for orientation
  static double w(double value, BuildContext context) {
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
    if (isLandscape) {
      // In landscape, screen width maps to design height
      return value * 1.sw / _designHeight;
    }
    return value.w;
  }

  /// Get responsive height that accounts for orientation
  static double h(double value, BuildContext context) {
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
    if (isLandscape) {
      // In landscape, screen height maps to design width
      return value * 1.sh / _designWidth;
    }
    return value.h;
  }

  /// Get responsive radius (uses the smaller dimension for consistency)
  static double r(double value, BuildContext context) {
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
    if (isLandscape) {
      // Use height (smaller in landscape) as reference
      return value * 1.sh / _designWidth;
    }
    return value.r;
  }

  /// Get responsive font size
  static double sp(double value, BuildContext context) {
    // Font size should scale based on the shorter dimension for readability
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
    if (isLandscape) {
      return value * 1.sh / _designWidth;
    }
    return value.sp;
  }

  /// Get responsive EdgeInsets with proper orientation handling
  static EdgeInsets symmetric({
    required BuildContext context,
    double horizontal = 0,
    double vertical = 0,
  }) {
    return EdgeInsets.symmetric(
      horizontal: w(horizontal, context),
      vertical: h(vertical, context),
    );
  }

  /// Get responsive EdgeInsets.all with proper orientation handling
  static EdgeInsets all(double value, BuildContext context) {
    return EdgeInsets.all(r(value, context));
  }

  /// Get responsive EdgeInsets.only with proper orientation handling
  static EdgeInsets only({
    required BuildContext context,
    double left = 0,
    double top = 0,
    double right = 0,
    double bottom = 0,
  }) {
    return EdgeInsets.only(
      left: w(left, context),
      top: h(top, context),
      right: w(right, context),
      bottom: h(bottom, context),
    );
  }

  /// Get responsive SizedBox for width
  static SizedBox horizontalSpace(double value, BuildContext context) {
    return SizedBox(width: w(value, context));
  }

  /// Get responsive SizedBox for height
  static SizedBox verticalSpace(double value, BuildContext context) {
    return SizedBox(height: h(value, context));
  }

  /// Get responsive BorderRadius.circular
  static BorderRadius circular(double value, BuildContext context) {
    return BorderRadius.circular(r(value, context));
  }
}

/// Extension methods for easier usage
extension ResponsiveExtension on num {
  double rw(BuildContext context) => Responsive.w(toDouble(), context);
  double rh(BuildContext context) => Responsive.h(toDouble(), context);
  double rr(BuildContext context) => Responsive.r(toDouble(), context);
  double rsp(BuildContext context) => Responsive.sp(toDouble(), context);
}

