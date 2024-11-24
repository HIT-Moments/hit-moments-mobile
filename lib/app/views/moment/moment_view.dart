import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hit_moments/app/core/config/enum.dart';
import 'package:hit_moments/app/core/constants/assets.dart';
import 'package:hit_moments/app/core/extensions/theme_extensions.dart';
import 'package:hit_moments/app/custom/widgets/app_bar_animation.dart';
import 'package:hit_moments/app/custom/widgets/icon_on_tap_scale.dart';
import 'package:hit_moments/app/providers/list_moment_provider.dart';
import 'package:hit_moments/app/views/moment/widget/grid_view_moment.dart';
import 'package:hit_moments/app/views/moment/widget/moment_widget.dart';
import 'package:hit_moments/app/views/moment/widget/select_friend_widget.dart';
import 'package:hit_moments/app/views/suggested_friends/suggested_friends_view.dart';
import 'package:provider/provider.dart';

import '../../models/moment_model.dart';
import '../../providers/weather_provider.dart';

class MomentView extends StatefulWidget {
  const MomentView({super.key, required this.pageParentController});
  final PageController pageParentController;
  @override
  State<MomentView> createState() => _MomentViewState();
}

class _MomentViewState extends State<MomentView> {
  List<MomentModel> listMoment = [];
  int _currentIndex = 0;
  PageController pageViewController = PageController();
  List<Widget> _list = [];
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ListMomentProvider>().getListFriendOfUser();
      context.read<WeatherProvider>().getCurrentPosition();
      // context.read<ListMomentProvider>().getWeather('21.0314268', '105.7792771');
      pageViewController.addListener(() {
        if (pageViewController.position.atEdge) {
          bool isBottom = pageViewController.position.pixels != 0;
          if (isBottom && context.read<ListMomentProvider>().loadMoreStatus != ModuleStatus.fail) {
            context.read<ListMomentProvider>().loadMoreListMoment();
          }
          bool isTop = pageViewController.position.pixels == pageViewController.position.minScrollExtent;
          if (isTop) {
            widget.pageParentController.previousPage(duration: Duration(milliseconds: 200), curve: Curves.easeInOut);
          }
        }
      });
      setPageView();
    });
  }

  Future<void> setPageView() async {
    await context.read<ListMomentProvider>().getListMoment();
    if (context.read<ListMomentProvider>().getListMomentStatus == ModuleStatus.success) {
      listMoment = context.read<ListMomentProvider>().momentList;
      setState(() {
        _list = listMoment
            .map((e) => MomentWidget(momentModel: e, pageViewController: pageViewController))
            .toList();
      });
    }
  }

  void _onLayersPressed() {
    setState(() {
      _currentIndex = 1;
    });
  }

  void _onMomentPressed() {
    setState(() {
      _currentIndex = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (context.read<ListMomentProvider>().getListMomentStatus == ModuleStatus.success) {
      listMoment = context.read<ListMomentProvider>().momentList;
      _list = listMoment
          .map((e) => MomentWidget(momentModel: e, pageViewController: pageViewController))
          .toList();
    }
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
                widget.pageParentController.previousPage(duration: Duration(milliseconds: 200), curve: Curves.easeInOut);
              },
            ),
          ),
          backgroundColor: Colors.white,
          title: SelectFriendWidget(
            friendSelected: (friendSelected) {
              context.read<ListMomentProvider>().getListMomentByUserID(friendSelected);
            },
          ),
          centerTitle: true,
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 16.w),
              child: IconOnTapScale(
                icon1Path: _currentIndex==0?Assets.icons.layersSVG:Assets.icons.categorySVG,
                backGroundColor: AppColors.of(context).neutralColor6,
                icon1Color: AppColors.of(context).neutralColor10,
                iconHeight: 20.w,
                iconWidth: 20.w,
                onPress: () {
                  if (_currentIndex == 0) {
                    context.read<ListMomentProvider>().loadMoreListMoment();
                    _onLayersPressed();
                  } else {
                    _onMomentPressed();
                  }
                },
              ),
            ),
          ],
        ),
        body: Stack(
          children: [
            Positioned(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: IndexedStack(
                index: _currentIndex,
                children: [
                  _list.isEmpty
                      ? const Center(child: AppPageWidget())
                      : Column(
                    children: [
                      Expanded(
                        child: RefreshIndicator(
                          color: AppColors.of(context).primaryColor10,
                          onRefresh: () async {
                            _list = [];
                            await context.read<ListMomentProvider>().getListMoment();
                            if (context.read<ListMomentProvider>().getListMomentStatus ==
                                ModuleStatus.success) {
                              listMoment = context.read<ListMomentProvider>().momentList;
                              _list = listMoment
                                  .map((e) => MomentWidget(
                                momentModel: e,
                                pageViewController: pageViewController,
                              ))
                                  .toList();
                            }
                          },
                          child: PageView(
                            controller: pageViewController,
                            scrollDirection: Axis.vertical,
                            children: [
                              ..._list,
                              if (context.watch<ListMomentProvider>().loadMoreStatus ==
                                  ModuleStatus.fail)
                                const SuggestedFriendsView(),
                            ],
                          ),
                        ),
                      ),
                      if (context.watch<ListMomentProvider>().loadMoreStatus ==
                          ModuleStatus.loading)
                        const AppPageWidget(),
                    ],
                  ),
                  GridViewMoment(
                    listMoment: listMoment,
                    onSelected: (moment, index) {
                      _onMomentPressed();
                      pageViewController.animateToPage(
                        index,
                        duration: const Duration(milliseconds: 100),
                        curve: Curves.easeInOut,
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

