import 'package:sliver_tools/sliver_tools.dart';

class CustomSliverAnimatedPaintExtent extends SliverAnimatedPaintExtent {
  static const defaultDuration = Duration(milliseconds: 150);

  const CustomSliverAnimatedPaintExtent({
    super.key,
    super.duration = defaultDuration,
    required super.child,
    super.curve,
  });
}
