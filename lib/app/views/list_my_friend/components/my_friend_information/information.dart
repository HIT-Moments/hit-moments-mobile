import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/extensions/theme_extensions.dart';

class Information extends StatelessWidget {
  const Information({super.key, required this.iconUrl, required this.title});

  final String iconUrl;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center, // Add this line
        children: [
          SvgPicture.asset(
            iconUrl,
            width: 36.w,
            height: 36.h,
          ),
          SizedBox(
            width: 16.w, // Add spacing between icon and text
          ),
          SizedBox(
            width: 160.w,
            child: Text(
              textAlign: TextAlign.left,
              overflow: TextOverflow.ellipsis,
              title,
              style: AppTextStyles.of(context).light20,
            ),
          ),
        ],
      ),
    );
  }
}