import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hit_moments/app/core/constants/assets.dart';
import 'package:hit_moments/app/core/extensions/theme_extensions.dart';
import 'package:hit_moments/app/custom/widgets/icon_on_tap_scale.dart';
import 'package:hit_moments/app/providers/moment_provider.dart';
import 'package:hit_moments/app/views/moment/widget/moment_widget.dart';
import 'package:hit_moments/app/views/moment/widget/select_friend_widget.dart';
import 'package:hit_moments/app/views/suggested_friends/suggested_friends_view.dart';
import 'package:provider/provider.dart';

import '../../models/moment_model.dart';

class MomentView extends StatefulWidget {
  const MomentView({super.key});

  @override
  State<MomentView> createState() => _MomentViewState();
}

class _MomentViewState extends State<MomentView> {
  late final List<MomentModel> listMoment;
   List<Widget> _list = [];
  @override
  void initState() {
    super.initState();
    getData();
    context.read<MomentProvider>().getListFriendOfUser();
    context.read<MomentProvider>().getWeather('21.0314268', '105.7792771');
  }
  int selected = 5;

  Future<void> getData() async{
    listMoment = await context.read<MomentProvider>().getListMoment();
    _list = listMoment.map((e) => MomentWidget(momentModel: e,)).toList();
    setState(() {
      _list;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: Padding(
            padding: EdgeInsets.only(left: 16.w, top: 8.w, bottom: 8.w),
            child: IconOnTapScale(
              icon1Path: Assets.icons.plusSVG,
              backGroundColor: AppColors.of(context).neutralColor6,
              icon1Color: AppColors.of(context).neutralColor10,
              iconHeight: 15.w,
              iconWidth: 15.w,
              onPress: () {

              },
            )
          ),
          backgroundColor: Colors.white,
          title: SelectFriendWidget(),
          centerTitle: true,
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 16.w),
              child: IconOnTapScale(
                  icon1Path: Assets.icons.layersSVG,
                  backGroundColor: AppColors.of(context).neutralColor6,
                  icon1Color: AppColors.of(context).neutralColor10,
                  iconHeight: 20.w, iconWidth: 20.w,
                  onPress: () {

                    //SelectFriendWidget();
                  },),
            )
          ],
        ),
        body: _list.isEmpty?Center(child: CircularProgressIndicator()):
        PageView(
          children: _list,
          scrollDirection: Axis.vertical,
        ),
      ),
    );
  }
}
