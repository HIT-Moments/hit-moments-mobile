import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hit_moments/app/core/extensions/theme_extensions.dart';
import 'package:hit_moments/app/providers/user_provider.dart';
import 'package:hit_moments/app/views/list_my_friend/list_my_friend_widget.dart';
import 'package:provider/provider.dart';

import '../../core/constants/assets.dart';
import '../../core/constants/color_constants.dart';
import '../../custom/widgets/tool_tip_shape.dart';
import '../../datasource/network_services/user_service.dart';
import '../../l10n/l10n.dart';
import '../../models/user_model.dart';
import 'components/friend_request.dart';

class ListMyFriendView extends StatefulWidget {
  const ListMyFriendView({super.key});

  @override
  State<ListMyFriendView> createState() => _ListMyFriendViewState();
}

class _ListMyFriendViewState extends State<ListMyFriendView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UserProvider>().getFriendOfUser();
      context.read<UserProvider>().getFriendRequestOfUser();
    });
  }

  final PageController _pageController = PageController();
  int pageIndex = 0;
  bool checkOpacity = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: Padding(
            padding: EdgeInsets.only(top: 15.w),
            child: BackButton(
              color: AppColors.of(context).neutralColor9,
            ),
          ),
          title: Padding(
            padding: EdgeInsets.only(top: 15.w),
            child: Text(
              overflow: TextOverflow.ellipsis,
              S.of(context).friend,
              style: AppTextStyles.of(context).bold32,
            ),
          ),
          centerTitle: true,
          actions: [
            PopupMenuButton(
              offset: const Offset(
                -16,
                64,
              ),
              shape: const TooltipShape(),
              constraints: BoxConstraints.expand(width: 0.8.sw, height: 0.4.sh),
              padding: EdgeInsets.only(
                top: 15.w,
                right: 15.w,
              ),
              onOpened: () {
                setState(() {
                  checkOpacity = true;
                });
              },
              onCanceled: () {
                setState(() {
                  checkOpacity = false;
                });
              },
              icon: Stack(
                clipBehavior: Clip.none,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.of(context).neutralColor7,
                      ),
                      padding: EdgeInsets.all(8.w),
                      child: SvgPicture.asset(
                        Assets.icons.bell,
                        width: 20.w,
                        height: 20.w,
                      ),
                    ),
                  ),
                  !context.watch<UserProvider>().isLoandingFriendRequests
                      ? (context.watch<UserProvider>().friendRequests.isNotEmpty
                          ? Positioned(
                              right: 1.w,
                              top: -3.w,
                              child: Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: ColorConstants.accentRed,
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                width: 20.w,
                                height: 20.w,
                                child: Text(
                                  '${Provider.of<UserProvider>(context, listen: false).friendRequests.length}',
                                  style: AppTextStyles.of(context).light16,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            )
                          : Container())
                      : Container(),
                ],
              ),
              itemBuilder: (_) =>
                  !Provider.of<UserProvider>(context, listen: false)
                          .isLoandingFriendRequests
                      ? _buildFriendRequestMenu(
                          Provider.of<UserProvider>(context, listen: false)
                              .friendRequests)
                      : [
                          const PopupMenuItem(
                              child: Center(child: CircularProgressIndicator()))
                        ],
            ),
          ],
        ),
        body: Container(
          margin: EdgeInsets.only(bottom: 32.h),
          child: Opacity(
            opacity: checkOpacity ? 0.3 : 1,
            child: (!context.watch<UserProvider>().isLoandingFriendList)
                ? ListMyFriendWidget(
                    friendProposals: const [],
                    friendsUsers: context.watch<UserProvider>().friendList)
                : const Center(
                    child: CircularProgressIndicator(),
                  ),
          ),
        ),
      ),
    );
  }

  List<PopupMenuItem> _buildFriendRequestMenu(List<User> users) {
    List<PopupMenuItem> items = [];
    items.add(
      PopupMenuItem(
        child: Center(
          child: Text(
            S.of(context).friendRequest,
            style: AppTextStyles.of(context).bold20,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        enabled: false,
      ),
    );

    if (users.isEmpty) {
      items.add(
        PopupMenuItem(
          child: Center(
            child: Text(
              S.of(context).noNotification,
              style: AppTextStyles.of(context).regular20,
            ),
          ),
          enabled: false, // Disable the item so it can't be selected
        ),
      );
    } else {
      // Nếu có yêu cầu kết bạn, thêm vào danh sách
      items.addAll(
        users
            .map(
              (e) => PopupMenuItem(
                child: FriendRequest(
                  user: e,
                ),
              ),
            )
            .toList(),
      );
    }

    return items;
  }

}
