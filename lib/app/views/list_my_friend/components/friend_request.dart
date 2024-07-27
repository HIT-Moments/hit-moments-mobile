import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/assets.dart';
import '../../../core/extensions/theme_extensions.dart';
import '../../../datasource/network_services/user_service.dart';
import '../../../models/user_model.dart';
import '../../../providers/user_provider.dart';
import 'my_friend_information/my_friend_infomation.dart';

class FriendRequest extends StatefulWidget {
  const FriendRequest({
    super.key,
    required this.user,
  });

  final User user;

  @override
  State<FriendRequest> createState() => _FriendRequestState();
}

class _FriendRequestState extends State<FriendRequest> {
  bool isConfirmFriendRequest = false;
  bool isDeleteFriendRequest = false;

  void confirmFriendRequest(int option) async {
    int statusCode =
        await UserService.confirmFriendRequestOfUserBy(widget.user.id, option);
    if (statusCode == 200) {
      if (option == 0) {
        setState(() {
          isDeleteFriendRequest = true;
        });
      } else {
        setState(() {
          isConfirmFriendRequest = true;
        });
      }
      context.read<UserProvider>().getFriendRequestOfUser();
      context.read<UserProvider>().getFriendOfUser();
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    print("isConfirmFriendRequest: $isConfirmFriendRequest");
    print("isDeleteFriendRequest: $isDeleteFriendRequest");
    return Column(
      children: [
        ListTile(
          onTap: () {
            isConfirmFriendRequest == false
                ? (isDeleteFriendRequest == false
                    ? Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MyFriendInfomationScreen(
                            user: widget.user,
                            option: 2,
                          ),
                        ),
                      )
                    : Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MyFriendInfomationScreen(
                            user: widget.user,
                            option: 0,
                          ),
                        ),
                      ))
                : Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MyFriendInfomationScreen(
                        user: widget.user,
                        option: 1,
                      ),
                    ),
                  );
          },
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: Image.network(
              widget.user.avatar!,
              height: 36.w,
              width: 36.w,
              fit: BoxFit.cover,
            ),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.user.fullName,
                style: AppTextStyles.of(context).light20.copyWith(
                      color: AppColors.of(context).neutralColor12,
                    ),
                overflow: TextOverflow.ellipsis,
              ),

              !isConfirmFriendRequest
                  ? !isDeleteFriendRequest
                      ? Row(
                          children: [
                            GestureDetector(
                              onTap: () => confirmFriendRequest(0),
                              child: SvgPicture.asset(
                                Assets.icons.zoomOut,
                                width: 24.w,
                                height: 24.w,
                              ),
                            ),
                            GestureDetector(
                              onTap: () => confirmFriendRequest(1),
                              child: SvgPicture.asset(
                                Assets.icons.zoomIn,
                                width: 24.w,
                                height: 24.w,
                              ),
                            ),
                          ],
                        )
                      : SvgPicture.asset(
                          Assets.icons.rightArrow,
                          width: 22.w,
                          height: 22.h,
                        )
                  : SvgPicture.asset(
                      Assets.icons.rightArrow,
                      width: 22.w,
                      height: 22.h,
                    )
            ],
          ),
        ),
        Opacity(
          opacity: 0.5,
          child: Container(
            height: 1.0,
            margin: EdgeInsets.only(
              top: 10.w,
              bottom: 10.w,
            ),
            padding: EdgeInsets.only(
              left: 10.w,
              right: 10.w,
            ),
            color: AppColors.of(context).neutralColor11,
          ),
        ),
      ],
    );
  }
}
