// shared/widgets/responsive_layout.dart
import 'package:flutter/material.dart';
import '../../core/utils/responsive_helper.dart';

class ResponsiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;

  const ResponsiveLayout({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (ResponsiveHelper.isDesktop(context)) {
          return desktop ?? tablet ?? mobile;
        } else if (ResponsiveHelper.isTablet(context)) {
          return tablet ?? mobile;
        } else {
          return mobile;
        }
      },
    );
  }
}

class ResponsiveLayoutBuilder extends StatelessWidget {
  final Widget Function(BuildContext context, BoxConstraints constraints) mobile;
  final Widget Function(BuildContext context, BoxConstraints constraints)? tablet;
  final Widget Function(BuildContext context, BoxConstraints constraints)? desktop;

  const ResponsiveLayoutBuilder({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (ResponsiveHelper.isDesktop(context)) {
          return desktop?.call(context, constraints) ??
                 tablet?.call(context, constraints) ??
                 mobile(context, constraints);
        } else if (ResponsiveHelper.isTablet(context)) {
          return tablet?.call(context, constraints) ??
                 mobile(context, constraints);
        } else {
          return mobile(context, constraints);
        }
      },
    );
  }
}

class ResponsiveBuilder extends StatelessWidget {
  final Widget Function(BuildContext context, BoxConstraints constraints, DeviceType deviceType) builder;

  const ResponsiveBuilder({
    super.key,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        DeviceType deviceType;
        if (ResponsiveHelper.isDesktop(context)) {
          deviceType = DeviceType.desktop;
        } else if (ResponsiveHelper.isTablet(context)) {
          deviceType = DeviceType.tablet;
        } else {
          deviceType = DeviceType.mobile;
        }

        return builder(context, constraints, deviceType);
      },
    );
  }
}

enum DeviceType { mobile, tablet, desktop }

class ResponsiveValue<T> {
  final T mobile;
  final T? tablet;
  final T? desktop;

  const ResponsiveValue({
    required this.mobile,
    this.tablet,
    this.desktop,
  });

  T getValue(BuildContext context) {
    if (ResponsiveHelper.isDesktop(context)) {
      return desktop ?? tablet ?? mobile;
    } else if (ResponsiveHelper.isTablet(context)) {
      return tablet ?? mobile;
    } else {
      return mobile;
    }
  }
}

// Responsive padding widget
class ResponsivePadding extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry mobile;
  final EdgeInsetsGeometry? tablet;
  final EdgeInsetsGeometry? desktop;

  const ResponsivePadding({
    super.key,
    required this.child,
    required this.mobile,
    this.tablet,
    this.desktop,
  });

  @override
  Widget build(BuildContext context) {
    EdgeInsetsGeometry padding;

    if (ResponsiveHelper.isDesktop(context)) {
      padding = desktop ?? tablet ?? mobile;
    } else if (ResponsiveHelper.isTablet(context)) {
      padding = tablet ?? mobile;
    } else {
      padding = mobile;
    }

    return Padding(
      padding: padding,
      child: child,
    );
  }
}

// Responsive sized box
class ResponsiveSizedBox extends StatelessWidget {
  final double? mobileHeight;
  final double? tabletHeight;
  final double? desktopHeight;
  final double? mobileWidth;
  final double? tabletWidth;
  final double? desktopWidth;
  final Widget? child;

  const ResponsiveSizedBox({
    super.key,
    this.mobileHeight,
    this.tabletHeight,
    this.desktopHeight,
    this.mobileWidth,
    this.tabletWidth,
    this.desktopWidth,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    double? height;
    double? width;

    if (ResponsiveHelper.isDesktop(context)) {
      height = desktopHeight ?? tabletHeight ?? mobileHeight;
      width = desktopWidth ?? tabletWidth ?? mobileWidth;
    } else if (ResponsiveHelper.isTablet(context)) {
      height = tabletHeight ?? mobileHeight;
      width = tabletWidth ?? mobileWidth;
    } else {
      height = mobileHeight;
      width = mobileWidth;
    }

    return SizedBox(
      height: height,
      width: width,
      child: child,
    );
  }
}

// Responsive flex widget
class ResponsiveFlex extends StatelessWidget {
  final List<Widget> children;
  final int mobileFlex;
  final int? tabletFlex;
  final int? desktopFlex;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final Axis direction;

  const ResponsiveFlex({
    super.key,
    required this.children,
    required this.mobileFlex,
    this.tabletFlex,
    this.desktopFlex,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.direction = Axis.horizontal,
  });

  @override
  Widget build(BuildContext context) {
    int flex;

    if (ResponsiveHelper.isDesktop(context)) {
      flex = desktopFlex ?? tabletFlex ?? mobileFlex;
    } else if (ResponsiveHelper.isTablet(context)) {
      flex = tabletFlex ?? mobileFlex;
    } else {
      flex = mobileFlex;
    }

    return Expanded(
      flex: flex,
      child: Flex(
        direction: direction,
        mainAxisAlignment: mainAxisAlignment,
        crossAxisAlignment: crossAxisAlignment,
        children: children,
      ),
    );
  }
}

// Responsive grid
class ResponsiveGrid extends StatelessWidget {
  final List<Widget> children;
  final int mobileColumns;
  final int? tabletColumns;
  final int? desktopColumns;
  final double spacing;
  final double runSpacing;

  const ResponsiveGrid({
    super.key,
    required this.children,
    required this.mobileColumns,
    this.tabletColumns,
    this.desktopColumns,
    this.spacing = 8.0,
    this.runSpacing = 8.0,
  });

  @override
  Widget build(BuildContext context) {
    int columns;

    if (ResponsiveHelper.isDesktop(context)) {
      columns = desktopColumns ?? tabletColumns ?? mobileColumns;
    } else if (ResponsiveHelper.isTablet(context)) {
      columns = tabletColumns ?? mobileColumns;
    } else {
      columns = mobileColumns;
    }

    return GridView.count(
      crossAxisCount: columns,
      crossAxisSpacing: spacing,
      mainAxisSpacing: runSpacing,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: children,
    );
  }
}

// Responsive text
class ResponsiveText extends StatelessWidget {
  final String text;
  final TextStyle? mobileStyle;
  final TextStyle? tabletStyle;
  final TextStyle? desktopStyle;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  const ResponsiveText(
    this.text, {
    super.key,
    this.mobileStyle,
    this.tabletStyle,
    this.desktopStyle,
    this.textAlign,
    this.maxLines,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) {
    TextStyle? style;

    if (ResponsiveHelper.isDesktop(context)) {
      style = desktopStyle ?? tabletStyle ?? mobileStyle;
    } else if (ResponsiveHelper.isTablet(context)) {
      style = tabletStyle ?? mobileStyle;
    } else {
      style = mobileStyle;
    }

    return Text(
      text,
      style: style,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}
