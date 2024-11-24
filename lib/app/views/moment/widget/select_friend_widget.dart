import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hit_moments/app/core/constants/assets.dart';
import 'package:hit_moments/app/providers/list_moment_provider.dart';
import 'package:popover/popover.dart';
import 'package:provider/provider.dart';

import '../../../core/extensions/theme_extensions.dart';
import '../../../custom/widgets/scale_on_tap_widget.dart';
import '../../../l10n/l10n.dart';
import '../../../models/user_model.dart';
import 'popover_select_friend.dart';

class SelectFriendWidget extends StatefulWidget {
  const SelectFriendWidget({super.key, required this.friendSelected});
  final void Function(User?) friendSelected;

  @override
  State<SelectFriendWidget> createState() => _SelectFriendWidgetState();
}

class _SelectFriendWidgetState extends State<SelectFriendWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isChangeColor = false;
  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
      upperBound: 0.5,
    );
  }
  @override
  Widget build(BuildContext context) {
    return ScaleOnTapWidget(
        onTap: (isSelect) {
          setState(() {
            _isChangeColor = !_isChangeColor;
          });
          if(!_isChangeColor){
            _controller.reverse(from: 0.5);

          }else{
            _controller.forward(from: 0.0);
          }
          showPopover(
              context: context,
              bodyBuilder: (context) =>
                  PopoverSelectFriend(listFriend: context.watch<ListMomentProvider>().friendList,
                    isBack: (friendSelect) {
                      widget.friendSelected(friendSelect);
                    },),
              onPop: () => print("Đã ấn"),
              direction: PopoverDirection.bottom,
              width: MediaQuery.of(context).size.width/1.6,
              height: 190.w,
              arrowHeight: 15.w,
              arrowWidth: 30.w
          );

        },
        child: Container(
            padding: EdgeInsets.only(left: 24.w,top: 4.w, right: 24.w,),
            decoration: BoxDecoration(
                color: AppColors.of(context).neutralColor6,
                borderRadius: const BorderRadius.all(Radius.circular(100)),
                border: Border.all(
                    color: _isChangeColor?AppColors.of(context).primaryColor8:AppColors.of(context).neutralColor6,
                    width: 1.w
                )
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Text(context.watch<ListMomentProvider>().friendSort==null
                      ?S.of(context).all
                      :context.watch<ListMomentProvider>().friendSort!.fullName,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.of(context).regular24.copyWith(
                        color: AppColors.of(context).neutralColor11
                    ),),
                ),
                SizedBox(width: 8.w,),
                Padding(
                  padding: EdgeInsets.only(bottom: 6.w),
                  child: RotationTransition(
                    turns: Tween(begin: 1.0, end: 0.0).animate(_controller),
                    child: SvgPicture.asset(Assets.icons.downSVG,
                      color: AppColors.of(context).neutralColor10,),
                  ),
                )
              ],
            )
        )


    );
  }
}