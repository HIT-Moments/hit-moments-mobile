import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hit_moments/app/core/base/base_connect.dart';
import 'package:hit_moments/app/core/extensions/theme_extensions.dart';
import 'package:hit_moments/app/providers/user_provider.dart';
import 'package:hit_moments/app/views/list_my_friend/list_my_friend_widget.dart';
import 'package:provider/provider.dart';

import '../../core/constants/assets.dart';
import '../../core/constants/color_constants.dart';
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
    //
    super.initState();
    Provider.of<UserProvider>(context, listen: false).getUser();
    Provider.of<UserProvider>(context, listen: false).getFriendOfUser();
    Provider.of<UserProvider>(context, listen: false).getMyFriendsUsers();
    Provider.of<UserProvider>(context, listen: false).getFriendRequests();
    Provider.of<UserProvider>(context, listen: false).getFriendProposals();
    //
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
              color: AppColors
                  .of(context)
                  .neutralColor9,
            ),
          ),
          title: Padding(
            padding: EdgeInsets.only(top: 15.w),
            child: Text(
              overflow: TextOverflow.ellipsis,
              S
                  .of(context)
                  .friend,
              style: AppTextStyles
                  .of(context)
                  .bold32,
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
                        color: AppColors
                            .of(context)
                            .neutralColor7,
                      ),
                      padding: EdgeInsets.all(8.w),
                      child: SvgPicture.asset(
                        Assets.icons.bell,
                        width: 20.w,
                        height: 20.w,
                      ),
                    ),
                  ),
                  Positioned(
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
                        '${Provider
                            .of<UserProvider>(context, listen: false)
                            .friendRequests
                            .length ?? 0}',
                        style: AppTextStyles
                            .of(context)
                            .light16,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
              itemBuilder: (_) =>
              !Provider
                  .of<UserProvider>(context, listen: false)
                  .isLoandingFriendRequests
                  ? _buildFriendRequestMenu(
                  Provider
                      .of<UserProvider>(context, listen: false)
                      .friendRequests)
                  : [
                const PopupMenuItem(
                    child: Center(child: CircularProgressIndicator()))
              ],
            ),
          ],
        ),
        body:
        Opacity(
            opacity: checkOpacity ? 0.3 : 1,
            child: (!Provider
                .of<UserProvider>(context, listen: false)
                .isLoandingFriendProposals &&
                !Provider
                    .of<UserProvider>(context, listen: false)
                    .isLoandingFriendsUsers)
                ? ListMyFriendWidget(
                friendProposals:
                Provider
                    .of<UserProvider>(context, listen: false)
                    .friendProposals,
                friendsUsers:
                Provider
                    .of<UserProvider>(context, listen: false)
                    .friendsUsers)
                : const Center(child: CircularProgressIndicator())),
      ),
    );
  }

  List<PopupMenuItem> _buildFriendRequestMenu(List<User> users) {
    List<PopupMenuItem> items = users
        .map(
          (e) => PopupMenuItem(
            child: FriendRequest(
              user: e,
            ),
          ),
        )
        .toList();
    items.insert(
      0,
      PopupMenuItem(
        child: Center(
          child: Text(
            overflow: TextOverflow.ellipsis,
            S.of(context).friendRequest,
            style: AppTextStyles.of(context).bold20,
          ),
        ),
        enabled: false, // Disable the item so it can't be selected
      ),
    );
    return items;
  }
}



class TooltipShape extends ShapeBorder {
  const TooltipShape();

  final BorderSide _side = BorderSide.none;
  final BorderRadiusGeometry _borderRadius = BorderRadius.zero;

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.all(_side.width);

  @override
  Path getInnerPath(
    Rect rect, {
    TextDirection? textDirection,
  }) {
    final Path path = Path();

    path.addRRect(
      _borderRadius.resolve(textDirection).toRRect(rect).deflate(_side.width),
    );

    return path;
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    final Path path = Path();
    final RRect rrect = _borderRadius.resolve(textDirection).toRRect(rect);

    path.moveTo(0, 10);
    path.quadraticBezierTo(0, 0, 10, 0);
    path.lineTo(rrect.width - 30, 0);
    path.lineTo(rrect.width - 20, -10);
    path.lineTo(rrect.width - 10, 0);
    path.quadraticBezierTo(rrect.width, 0, rrect.width, 10);
    path.lineTo(rrect.width, rrect.height - 10);
    path.quadraticBezierTo(
        rrect.width, rrect.height, rrect.width - 10, rrect.height);
    path.lineTo(10, rrect.height);
    path.quadraticBezierTo(0, rrect.height, 0, rrect.height - 10);

    return path;
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {}

  @override
  ShapeBorder scale(double t) => RoundedRectangleBorder(
        side: _side.scale(t),
        borderRadius: _borderRadius * t,
      );
}
