import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hit_moments/app/core/extensions/theme_extensions.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class AppPageWidget extends StatelessWidget {
  const AppPageWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      width: 1.sw,
      height: 1.sh,
      child: Container(
        color: AppColors.of(context).neutralColor1,
        child: Center(
          // Using a different loading animation
          child: LoadingAnimationWidget.discreteCircle(
            size: 60,
            color: AppColors.of(context).primaryColor9,
            secondRingColor: AppColors.of(context).primaryColor9,
            thirdRingColor: AppColors.of(context).primaryColor9,
          ),
        ),
      ),
    );
  }
}
