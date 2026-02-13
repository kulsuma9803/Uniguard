import 'package:flutter/material.dart';

class Responsive {
  static const double mobileBreakpoint = 600;

  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < mobileBreakpoint;
  }

  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= mobileBreakpoint;
  }
  static T value<T>(
    BuildContext context, {
    required T mobile,
    required T desktop,
  }) {
    return isMobile(context) ? mobile : desktop;
  }
  static double horizontalPadding(BuildContext context) {
    return isMobile(context) ? 16.0 : 32.0;
  }

  static double? maxContentWidth(BuildContext context) {
    return isMobile(context) ? null : 600.0;
  }
}

class ResponsiveCenter extends StatelessWidget {
  final Widget child;
  final double maxWidth;
  final EdgeInsetsGeometry? padding;

  const ResponsiveCenter({
    Key? key,
    required this.child,
    this.maxWidth = 600,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: BoxConstraints(maxWidth: maxWidth),
        padding: padding,
        child: child,
      ),
    );
  }
}
