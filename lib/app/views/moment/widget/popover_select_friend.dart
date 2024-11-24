import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hit_moments/app/core/extensions/theme_extensions.dart';

import '../../../core/constants/assets.dart';
import '../../../l10n/l10n.dart';
import '../../../models/user_model.dart';

class PopoverSelectFriend extends StatefulWidget {
  const PopoverSelectFriend({
    super.key,
    required this.listFriend,
    required this.isBack,
  });

  final List<User> listFriend;
  final void Function(User? friendSelect) isBack;

  @override
  State<PopoverSelectFriend> createState() => _PopoverSelectFriendState();
}

class _PopoverSelectFriendState extends State<PopoverSelectFriend> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.only(top: 0),
              itemCount: widget.listFriend.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Column(
                    children: [
                      ListTile(
                      title: rowUser(null, Assets.icons.usersSVG, S.of(context).all),
                        onTap: () {
                          widget.isBack(null);
                          Navigator.pop(context);
                        },
                      ),
                      if (index < widget.listFriend.length+1)
                        Divider(
                          color: Colors.grey,
                          height: ScreenUtil().setHeight(1.0),
                        ),
                    ],
                  );
                } else {
                  final friend = widget.listFriend[index - 1];
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        title: rowUser(friend.avatar, null, friend.fullName),
                        onTap: () {
                          widget.isBack(friend);
                          Navigator.pop(context);
                        },
                      ),
                      if (index < widget.listFriend.length)
                        Divider(
                          color: Colors.grey,
                          height: ScreenUtil().setHeight(1.0),
                        ),
                    ],
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget rowUser(String? imgAvatar, String? imgIcon, String fullName) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(1),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(100)),
          ),
          child: imgIcon==null? ClipRRect(
            borderRadius: BorderRadius.circular(40.w),
            child:CachedNetworkImage(
              imageUrl: imgAvatar!,
              width: 40.w,
              height: 40.w,
              fit: BoxFit.cover,
            )
            ): Container(
              height: 40.w,
              width: 40.w,
              decoration: BoxDecoration(
                color: AppColors.of(context).neutralColor6,
                border: Border.all(
                  width: 1.0,
                  color: AppColors.of(context).primaryColor9
                ),
                borderRadius: BorderRadius.all(Radius.circular(100))
              ),
              child: Center(child: SvgPicture.asset(imgIcon)),
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: Text(
            fullName,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.of(context).light20.copyWith(
              color: AppColors.of(context).neutralColor11,
            ),
          ),
        ),
      ],
    );
  }
}
