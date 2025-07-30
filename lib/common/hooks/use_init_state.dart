import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

void useInitState({
  Dispose? Function()? initState,
  Function? onBuild,
  List<Object?>? keys,
}) {
  useEffect(() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      onBuild?.call();
    });
    final dispose = initState?.call();
    return () {
      dispose?.call();
    };
  }, keys ?? const []);
}
