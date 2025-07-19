import 'package:frontend/utils/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomOmTexFieldEyeCloseWidget extends StatelessWidget {
  final String? assetName;
  const CustomOmTexFieldEyeCloseWidget({
    super.key,
    this.assetName,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: SizedBox(
        height: 5.49.h,
        width: 5.49.h,
        child: SvgPicture.asset(
          assetName ?? AppConstants.textFieldEyeCloseIcon,
        ),
      ),
    );
  }
}
