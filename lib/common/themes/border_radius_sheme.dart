import 'package:hh_example/common/widgets/theme_extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

final borderRadiusScheme = BorderRadiusScheme(
  input: BorderRadius.all(Radius.circular(16.r)),
  button: BorderRadius.all(Radius.circular(16.r)),
  itemS: BorderRadius.all(Radius.circular(4.r)),
  itemM: BorderRadius.all(Radius.circular(12.r)),
  itemL: BorderRadius.all(Radius.circular(16.r)),
  itemSTop: BorderRadius.vertical(top: Radius.circular(4.r)),
  itemMTop: BorderRadius.vertical(top: Radius.circular(12.r)),
  itemLTop: BorderRadius.vertical(top: Radius.circular(16.r)),
  tooltip: BorderRadius.only(
    topLeft: Radius.circular(16.r),
    topRight: Radius.circular(16.r),
    bottomRight: Radius.circular(16.r),
  ),
  circularLoader: BorderRadius.all(Radius.circular(28.r)),
  bottomSheet: BorderRadius.vertical(top: Radius.circular(28.r)),
  dialog: BorderRadius.all(Radius.circular(28.r)),
  checkBox: BorderRadius.all(Radius.circular(4.r)),
  dragHandle: BorderRadius.all(Radius.circular(2.h)),
);
