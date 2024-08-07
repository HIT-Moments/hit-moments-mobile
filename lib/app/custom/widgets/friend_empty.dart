import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hit_moments/app/core/extensions/theme_extensions.dart';
import 'package:hit_moments/app/l10n/l10n.dart';
import '../../core/constants/assets.dart';
import '../../core/constants/color_constants.dart';

class FriendEmpty extends StatelessWidget {
  const FriendEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            Assets.icons.addFriendSVG,
            width: 100.w,
            height: 100.h,
            color: ColorConstants.neutralLight100,
          ),
          Text(
            S.of(context).titleFriendEmpty,
            style: AppTextStyles.of(context).light24.copyWith(
                  color: AppColors.of(context).neutralColor11,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
