import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hit_moments/app/core/constants/color_constants.dart';
import 'package:hit_moments/app/custom/widgets/search_data_not_found.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/assets.dart';
import '../../../core/extensions/theme_extensions.dart';
import '../../../datasource/network_services/user_service.dart';
import '../../../models/user_model.dart';
import '../../../providers/user_provider.dart';
import 'my_friend_information/my_friend_infomation.dart';

class ListFriendSuggestions extends StatefulWidget {
  const ListFriendSuggestions(
      {super.key,
      required this.users,
      required this.setExpanded,
      required this.isExpanded,});

  final VoidCallback setExpanded;
  final bool isExpanded;
  final List<User> users;

  @override
  State<ListFriendSuggestions> createState() => _ListFriendSuggestionsState();
}
class _ListFriendSuggestionsState extends State<ListFriendSuggestions> {
  late List<bool> sentRequestList;

  @override
  void initState() {
    super.initState();
    sentRequestList = List<bool>.filled(widget.users.length, false);
  }

  void sentRequestFriend(int index) async {
    int statusCode = await UserService.sentRequestById(widget.users[index].id, true);
    if (statusCode == 200) {
      setState(() {
        sentRequestList[index] = true;
      });
      print("Gửi yêu cầu kết bạn thành công");
    } else {
      print("Gửi yêu cầu kết bạn thất bại");
    }
  }

  @override
  Widget build(BuildContext context) {
    List<User> lists = widget.users;
    return lists.isNotEmpty
        ? SingleChildScrollView(
      child: Column(
        children: [
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: widget.isExpanded
                ? lists.length
                : (lists.length > 3 ? 3 : lists.length),
            itemBuilder: (context, index) {
              return Column(
                children: [
                  ListTile(
                    onTap: () {
                      sentRequestList[index]==false? Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MyFriendInfomationScreen(
                            user: widget.users[index],
                            option: 0,
                          ),
                        ),
                      ): null ;
                    },
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Image.network(
                        lists[index].avatar!,
                        height: 36.w,
                        width: 36.w,
                        fit: BoxFit.cover,
                      ),
                    ),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          lists[index].fullName,
                          style: AppTextStyles.of(context)
                              .light20
                              .copyWith(
                            color:
                            AppColors.of(context).neutralColor12,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        GestureDetector(
                          child: sentRequestList[index]
                              ? SvgPicture.asset(
                            Assets.icons.play,
                            width: 28.w,
                            height: 28.h,
                            color:ColorConstants.accentGreen,
                          )
                              : SvgPicture.asset(
                            Assets.icons.zoomIn,
                            width: 28.w,
                            height: 28.h,
                            color:AppColors.of(context).primaryColor10,
                          ),
                          onTap: ()=>sentRequestFriend(index),
                        ),
                      ],
                    ),
                  ),
                  Opacity(
                    opacity: 0.5,
                    child: Container(
                      height: 1.0,
                      margin: EdgeInsets.only(
                        top: 6.h,
                        bottom: 6.h,
                      ),
                      padding: EdgeInsets.only(
                        left: 12.w,
                        right: 12.w,
                      ),
                      color: AppColors.of(context).neutralColor11,
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    )
        : const SearchDataNotFound();
  }
}
// class _ListFriendSuggestionsState extends State<ListFriendSuggestions> {
//
//   void sentRequestFriend(User user,bool isSenRequest) async {
//     int statusCode = await UserService.sentRequestById(user.id);
//     if (statusCode == 200) {
//       setState(() {
//         isSenRequest = true;
//       });
//       print("Gửi yêu cầu kết bạn thành công");
//     } else {
//       print("Gửi yêu cầu kết bạn thất bại");
//     }
//   }
//   @override
//   Widget build(BuildContext context) {
//     List<User> lists = widget.users
//         .where((user) => user.fullName
//             .toLowerCase()
//             .contains(widget.keySearch.toLowerCase()))
//         .toList();
//     return lists.isNotEmpty
//         ? SingleChildScrollView(
//             child: Column(
//               children: [
//                 ListView.builder(
//                   shrinkWrap: true,
//                   physics: const NeverScrollableScrollPhysics(),
//                   itemCount: widget.isExpanded
//                       ? lists.length
//                       : (lists.length > 3 ? 3 : lists.length),
//                   itemBuilder: (context, index) {
//                     bool isSentRequest = false;
//                     return Column(
//                       children: [
//                         ListTile(
//                           onTap: () {
//                             // Navigator.push(
//                             //   context,
//                             //   MaterialPageRoute(
//                             //     builder: (context) => MyFriendInfomationScreen(
//                             //       user: widget.users[index],
//                             //       option: 0,
//                             //     ),
//                             //   ),
//                             // );
//                           },
//                           leading: ClipRRect(
//                             borderRadius: BorderRadius.circular(50),
//                             child: Image.network(
//                               lists[index].avatar!,
//                               height: 36.w,
//                               width: 36.w,
//                               fit: BoxFit.cover,
//                             ),
//                           ),
//                           title: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Text(
//                                 lists[index].fullName,
//                                 style: AppTextStyles.of(context)
//                                     .light20
//                                     .copyWith(
//                                       color:
//                                           AppColors.of(context).neutralColor12,
//                                     ),
//                                 overflow: TextOverflow.ellipsis,
//                               ),
//                               GestureDetector(
//                                 child: isSentRequest?
//                                 SvgPicture.asset(
//                                   Assets.icons.play,
//                                   width: 28.w,
//                                   height: 28.h,
//                                   color:ColorConstants.accentGreen,
//                                 ):
//                                 SvgPicture.asset(
//                                   Assets.icons.zoomIn,
//                                   width: 28.w,
//                                   height: 28.h,
//                                   color:AppColors.of(context).primaryColor10,
//                                 ),
//                                 onTap: ()=>sentRequestFriend(lists[index],isSentRequest),
//                               ),
//                             ],
//                           ),
//                         ),
//                         Opacity(
//                           opacity: 0.5,
//                           child: Container(
//                             height: 1.0,
//                             margin: EdgeInsets.only(
//                               top: 6.h,
//                               bottom: 6.h,
//                             ),
//                             padding: EdgeInsets.only(
//                               left: 12.w,
//                               right: 12.w,
//                             ),
//                             color: AppColors.of(context).neutralColor11,
//                           ),
//                         ),
//                       ],
//                     );
//                   },
//                 ),
//               ],
//             ),
//           )
//         : const SearchDataNotFound();
//   }
// }
