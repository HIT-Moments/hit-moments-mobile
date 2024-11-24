import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/scheduler.dart';
import 'package:hit_moments/app/core/constants/color_constants.dart';
import 'package:hit_moments/app/core/extensions/theme_extensions.dart';
Future showCustomDialog(
    BuildContext context, {
      Function? onPressNegative,
      Function? onPressPositive,
      Function? onHide,
      String? urlIcon,
      String? title,
      double? widthIcon,
      double? heightIcon,
      Widget? content,
      bool? hideNegativeButton = false,
      bool? hidePositiveButton = false,
      bool? disablePressPositive,
      Color? backgroundPositiveButton,
      Color? borderNegativeButton,
      Color? colorTitle,
      String? textNegative,
      String? textPositive,
      double? marginButton,
      bool? showCloseButton,
      bool? barrierDismissible = true,
      bool? preventBack,
      Color? colorTextNegative,
      Color? colorTextPositive,
    }) async {
  final result = await showDialog(
    barrierDismissible: barrierDismissible!,
    context: context,
    builder: (_) => AlertDialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 16.w),
      contentPadding: EdgeInsets.zero,
      content: PopScope(
        canPop: !(preventBack ?? false),
        child: DialogWidget(
          title: title ?? '',
          urlIcon: urlIcon,
          textNegative: textNegative,
          textPositive: textPositive,
          content: content,
          colorTitle: colorTitle,
          widthIcon: widthIcon,
          marginButton: marginButton,
          heightIcon: heightIcon,
          hidePositiveButton: hidePositiveButton,
          backgroundPositiveButton: backgroundPositiveButton,
          borderNegativeButton: borderNegativeButton,
          onPressNegative: onPressNegative,
          disablePressPositive: disablePressPositive,
          hideNegativeButton: hideNegativeButton,
          onPressPositive: onPressPositive,
          showCloseButton: showCloseButton,
          colorTextNegative: colorTextNegative,
          colorTextPositive: colorTextPositive,
        ),
      ),
    ),
  );
  onHide?.call();
  return result;
}

class DialogWidget extends StatelessWidget {
  final String title;
  final Widget? content;
  final String? urlIcon;
  final double? widthIcon;
  final double? heightIcon;
  final String? textNegative;
  final String? textPositive;
  final Color? colorTitle;
  final bool? hideNegativeButton;
  final Function? onPressNegative;
  final bool? hidePositiveButton;
  final double? marginButton;
  final Function? onPressPositive;
  final bool? disablePressPositive;
  final Color? backgroundPositiveButton;
  final Color? borderNegativeButton;
  final bool? showCloseButton;
  final Color? colorTextNegative;
  final Color? colorTextPositive;

  const DialogWidget({
    super.key,
    required this.title,
    this.content,
    this.marginButton,
    this.urlIcon,
    this.hidePositiveButton,
    this.textNegative,
    this.colorTitle,
    this.widthIcon,
    this.heightIcon,
    this.textPositive,
    this.hideNegativeButton = false,
    this.backgroundPositiveButton,
    this.borderNegativeButton,
    this.onPressNegative,
    this.disablePressPositive,
    this.onPressPositive,
    this.showCloseButton = true,
    this.colorTextNegative,
    this.colorTextPositive,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Utils.getScreenWidth(context),
      margin: EdgeInsets.symmetric(horizontal: 12.w),
      decoration: BoxDecoration(color: AppColors.of(context).neutralColor1, borderRadius: BorderRadius.circular(16.w)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(
            height: 20.w,
          ),
          showCloseButton ?? false
              ? Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Padding(
                  padding: EdgeInsets.only(right: 20.w),
                  child: SvgPicture.asset('assets/icons/icon_close.svg'),
                ),
              ),
            ],
          )
              : const SizedBox(),
          urlIcon != null
              ? SvgPicture.asset(
            urlIcon!,
            width: widthIcon ?? Utils.getScreenWidth(context) * 0.17,
            height: heightIcon ?? Utils.getScreenWidth(context) * 0.17,
          )
              : const SizedBox.shrink(),
          title != ''
              ? Padding(
            padding: EdgeInsets.only( bottom: 8.w),
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 24.sp, fontWeight: FontWeight.w700, color: colorTitle ?? ColorConstants.primaryDark90),
            ),
          )
              : const SizedBox.shrink(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 6.w),
            child: content ?? Container(),
          ),
          hidePositiveButton ?? false
              ? Container()
              : SizedBox(
            height: 24.w,
          ),
          hidePositiveButton ?? false
              ? Container()
              : Opacity(
            opacity: (disablePressPositive ?? false) ? 0.5 : 1,
            child: ButtonDialog(
              marginButton: marginButton,
              title: textPositive ?? '',
              backgroundColor: backgroundPositiveButton,
              onPressed: () {
                onPressPositive?.call();
              },
              textColor: colorTextPositive,
            ),
          ),
          !(hideNegativeButton ?? false)
              ? Column(
            children: [
              SizedBox(
                height: 12.w,
              ),
              ButtonDialog(
                marginButton: marginButton,
                title: textNegative ?? '',
                borderColor: AppColors.of(context).primaryColor10,
                backgroundColor: AppColors.of(context).primaryColor1,
                onPressed: () {
                  onPressNegative?.call();
                },
                textColor: colorTextNegative,
              )
            ],
          )
              : const SizedBox(),
          SizedBox(
            height: 30.h,
          ),
        ],
      ),
    );
  }
}

class ButtonDialog extends StatelessWidget {
  final Function? onPressed;
  final String title;
  final Color? titleColor;
  final Color? backgroundColor;
  final Color? borderColor;
  final double? marginButton;
  final Color? textColor;

  const ButtonDialog(
      {super.key,
        required this.title,
        this.borderColor,
        this.onPressed,
        this.marginButton,
        this.titleColor,
        this.backgroundColor,
        this.textColor});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (onPressed != null) {
          onPressed!();
        } else {
          Navigator.of(context).pop();
        }
      },
      child: Container(
          margin: EdgeInsets.symmetric(horizontal: marginButton ?? 18.w),
          padding: EdgeInsets.symmetric(vertical: 12.w),
          decoration: BoxDecoration(
            border: Border.all(
                color: borderColor != null
                    ? borderColor!
                    : backgroundColor != null
                    ? backgroundColor!
                    : Colors.white),
            color: backgroundColor ?? Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(100.w)),
          ),
          child: Center(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w700, color: textColor ?? Colors.white),
            ),
          )),
    );
  }
}

class Utils {
  static void dismissKeyboard() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  static getScreenWidth(context) => MediaQuery.of(context).size.width;

  static getScreenHeight(context) => MediaQuery.of(context).size.height;

  void onWidgetBuildDone(Function function) {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      function();
    });
  }
}
