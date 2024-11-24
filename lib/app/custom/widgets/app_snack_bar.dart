import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hit_moments/app/core/extensions/theme_extensions.dart';

class AppSnackBar {
  static void showSuccess(
      BuildContext context, // Add BuildContext parameter
      String message, {
        FlushbarPosition position = FlushbarPosition.TOP,
      }) {
    bool isPressed = false;

    Flushbar(
      icon: SvgPicture.asset(
        "assets/icons/ic_done.svg",
        width: 18.w,
        height: 18.w,
      ),
      messageText: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
          GestureDetector(
            onTap: () {
              if (!isPressed) {
                NavigationService.navigatorKey.currentState!.maybePop();
                isPressed = true;
              }
            },
            child: Icon(
              Icons.clear,
              size: 20.w,
              color: AppColors.of(context).neutralColor1, // Use the passed context
            ),
          )
        ],
      ),
      flushbarStyle: FlushbarStyle.FLOATING,
      flushbarPosition: position,
      isDismissible: true,
      backgroundColor: Colors.white,
      boxShadows: [
        BoxShadow(
          color: const Color.fromRGBO(0, 0, 0, 0.08),
          blurRadius: 10.w,
        )
      ],
      duration: const Duration(seconds: 1),
      margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 3.h),
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      borderRadius: BorderRadius.circular(10.w),
    ).show(context); // Use the passed context
  }

  static void showError(
      BuildContext context, // Add BuildContext parameter
      String title,
      String? content, {
        FlushbarPosition position = FlushbarPosition.TOP,
      }) {
    bool isPressed = false;

    Flushbar(
      icon: SvgPicture.asset(
        "assets/icons/ic_error.svg",
        width: 20.w,
        height: 20.w,
      ),
      messageText: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 230.w,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.of(context).bold16.copyWith(
                    color: AppColors.of(context).neutralColor12,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                content != null
                    ? Text(
                  content,
                  style: AppTextStyles.of(context).bold16,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 5,
                )
                    : const SizedBox(),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              if (!isPressed) {
                NavigationService.navigatorKey.currentState!.maybePop();
                isPressed = true;
              }
            },
            child: Icon(
              Icons.clear,
              size: 20.w,
              color: AppColors.of(context).neutralColor1,
            ),
          )
        ],
      ),
      flushbarStyle: FlushbarStyle.FLOATING,
      flushbarPosition: position,
      isDismissible: true,
      backgroundColor: Colors.white,
      boxShadows: [
        BoxShadow(
          color: const Color.fromRGBO(0, 0, 0, 0.08),
          blurRadius: 10.w,
        )
      ],
      duration: const Duration(seconds: 3),
      margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 3.h),
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      borderRadius: BorderRadius.circular(8),
    ).show(context); // Use the passed context
  }
}


class NavigationService {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
}
