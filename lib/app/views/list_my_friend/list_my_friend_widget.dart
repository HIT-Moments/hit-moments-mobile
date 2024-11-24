import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hit_moments/app/core/constants/assets.dart';
import 'package:hit_moments/app/core/constants/color_constants.dart';
import 'package:hit_moments/app/core/extensions/theme_extensions.dart';
import 'package:provider/provider.dart';

import '../../l10n/l10n.dart';
import '../../models/user_model.dart';
import '../../providers/user_provider.dart';
import 'components/list_friend_proposal.dart';
import 'components/list_my_friend.dart';

class ListMyFriendWidget extends StatefulWidget {
  const ListMyFriendWidget(
      {super.key, required this.friendsUsers, required this.friendProposals});

  final List<User> friendsUsers, friendProposals;

  @override
  State<ListMyFriendWidget> createState() => _ListMyFriendWidgetState();
}

class _ListMyFriendWidgetState extends State<ListMyFriendWidget> {
  bool checkColorList = false;
  bool isExpandedMyFriend = false;
  bool isExpandedFriendProposals = false;
  bool isDownUpMyFriend = false;
  bool isDownUpFriendProposals = false;
  bool isCheckInput = false;

  // void toggleColor(String title) {
  //   setState(() {
  //     isCheckInput = false;
  //   });
  //   setState(() {
  //     if (title == S.of(context).list) {
  //       checkColorList = false;
  //     } else if (title == S.of(context).proposal) {
  //       checkColorList = true;
  //     }
  //   });
  // }
  void toggleColor(String title) {
    setState(() {
      isCheckInput = false;
      //
      // isCheckText = false; // Đặt lại trạng thái của isCheckText
    });
    if (title == S.of(context).list) {
      setState(() {
        checkColorList = false;
        if (_searchController.text.isNotEmpty) {
          _searchController.clear(); // Xóa nội dung ô tìm kiếm
          context.read<UserProvider>().getFriendProposals();
        }
      });
    } else if (title == S.of(context).proposal) {
      setState(() {
        checkColorList = true;
      });
    }
  }

  void setExpandedMyFriend() {
    setState(() {
      isExpandedMyFriend = !isExpandedMyFriend;
    });
  }

  void setExpandedFriendProposals() {
    setState(() {
      isExpandedFriendProposals = !isExpandedFriendProposals;
    });
  }

  void setIsDownUpMyFriend() {
    setState(() {
      isDownUpMyFriend = !isDownUpMyFriend;
    });
  }

  void setIsDownUpFriendProposals() {
    setState(() {
      isDownUpFriendProposals = !isDownUpFriendProposals;
    });
  }

  final TextEditingController _searchController = TextEditingController();

  Future<void> _refreshData() async {
    context.read<UserProvider>().getFriendOfUser();
    context.read<UserProvider>().getFriendRequestOfUser();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(
              top: 20.h,
              bottom: 22.h,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: AppColors.of(context).neutralColor8,
                width: 1,
              ),
            ),
            child: IntrinsicWidth(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TabBarMyFriend(
                    title: S.of(context).list,
                    checkColor: !checkColorList,
                    toggleColor: () => toggleColor(S.of(context).list),
                  ),
                  TabBarMyFriend(
                    title: S.of(context).proposal,
                    checkColor: checkColorList,
                    toggleColor: () => toggleColor(S.of(context).proposal),
                  ),
                ],
              ),
            ),
          ),
          checkColorList != true
              ? Column(
                children: [
                  ListMyFriend(
                    users: widget.friendsUsers,
                    setExpanded: setExpandedMyFriend,
                    isExpanded: isExpandedMyFriend,
                  ),
                  context.watch<UserProvider>().isSearchFriend
                      ? const SizedBox()
                      : (widget.friendsUsers.length > 3
                          ? Padding(
                              padding: EdgeInsets.all(6.w),
                              child: InkWell(
                                onTap: setExpandedMyFriend,
                                child: isExpandedMyFriend
                                    ? SvgPicture.asset(
                                        Assets.icons.upSVG,
                                        width: 13.w,
                                        height: 13.w,
                                        color: AppColors.of(context)
                                            .neutralColor9,
                                      )
                                    : SvgPicture.asset(
                                        Assets.icons.downSVG,
                                        width: 13.w,
                                        height: 13.w,
                                        color: AppColors.of(context)
                                            .neutralColor9,
                                      ),
                              ),
                            )
                          : const SizedBox())
                ],
              )
              : Container(
                  margin: EdgeInsets.only(
                    top: 20.h,
                    left: 20.w,
                    right: 20.w,
                  ),
                  padding: EdgeInsets.only(
                    top: 10.h,
                    left: 12.w,
                    right: 12.w,
                    bottom: 10.h,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: ColorConstants.neutralLight80,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Column(
                    children: [
                      ListFriendSuggestions(
                        users: widget.friendProposals,
                        setExpanded: setExpandedFriendProposals,
                        isExpanded: isExpandedFriendProposals,
                        // keySearch: checkColorList == true
                        //     ? _searchController.text
                        //     : "",
                      ),
                      if (widget.friendProposals.length > 3)
                        Padding(
                          padding: EdgeInsets.all(6.w),
                          child: InkWell(
                            onTap: setExpandedFriendProposals,
                            child: isExpandedFriendProposals
                                ? SvgPicture.asset(
                                    Assets.icons.upSVG,
                                    width: 12.w,
                                    height: 12.w,
                                  )
                                : SvgPicture.asset(
                                    Assets.icons.downSVG,
                                    width: 12.w,
                                    height: 12.w,
                                  ),
                          ),
                        ),
                    ],
                  ),
                ),
        ],
      ),
    );
  }
}

class TabBarMyFriend extends StatelessWidget {
  const TabBarMyFriend({
    super.key,
    required this.title,
    required this.checkColor,
    required this.toggleColor,
  });

  final bool checkColor;
  final String title;
  final VoidCallback toggleColor;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: toggleColor,
        child: Container(
          padding: EdgeInsets.only(
            left: 15.w,
            right: 15.w,
          ),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: checkColor
                ? AppColors.of(context).primaryColor9
                : AppColors.of(context).primaryColor1,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Text(
            title,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 25.w,
              color: checkColor
                  ? AppColors.of(context).primaryColor1
                  : AppColors.of(context).neutralColor7,
            ),
          ),
        ),
      ),
    );
  }
}
