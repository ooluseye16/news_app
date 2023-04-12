import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';



extension ActualSize on num {
  Widget get height => SizedBox(
        height: h,
      );

  Widget get width => SizedBox(
        width: w,
      );
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}
