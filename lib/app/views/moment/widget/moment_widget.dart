import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hit_moments/app/core/constants/assets.dart';
import 'package:hit_moments/app/core/extensions/format_time_extension.dart';
import 'package:hit_moments/app/custom/widgets/icon_on_tap_scale.dart';
import 'package:hit_moments/app/custom/widgets/scale_on_tap_widget.dart';
import 'package:hit_moments/app/datasource/local/storage.dart';
import 'package:hit_moments/app/models/moment_model.dart';
import 'package:hit_moments/app/providers/moment_provider.dart';
import 'package:hit_moments/app/views/moment/widget/bottom_sheet_input.dart';
import 'package:hit_moments/app/views/moment/widget/moment_content_widget.dart';
import 'package:hit_moments/app/views/moment/widget/select_funtion_widget.dart';
import 'package:provider/provider.dart';
import '../../../core/config/enum.dart';
import '../../../core/extensions/theme_extensions.dart';
import '../../../l10n/l10n.dart';

class MomentWidget extends StatefulWidget {
  const MomentWidget({
    super.key,
    required this.momentModel,
    required this.pageViewController});
  final MomentModel momentModel;
  final PageController pageViewController;

  @override
  State<MomentWidget> createState() => _MomentWidgetState();
}

class _MomentWidgetState extends State<MomentWidget> {
  late TextEditingController controller;
  void showBottomSheetInput(){
    controller = TextEditingController();
    showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      clipBehavior: Clip.antiAlias,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      context: context,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: BottomSheetInput(momentModel: widget.momentModel,
            controller: controller,
          ),
        );
      },
    );
  }
  Future<void> showDialogReact() async {
    await context.read<MomentProvider>().getReact(widget.momentModel.momentID!);
    showDialog(
      context: context,
      builder: (context) {
        final momentProvider = context.watch<MomentProvider>();
        return AlertDialog(
          title:  Text(
            S.of(context).receivedInteractions,
            textAlign: TextAlign.center,
            style: AppTextStyles.of(context).bold24.copyWith(
                color: AppColors.of(context).neutralColor11
            ),
          ),
          content: momentProvider.listReact.isEmpty
              ?  SizedBox(
                width: double.maxFinite,
                height: 200,
                child: Center(
                   child: Text(S.of(context).noInteractions,
                style: AppTextStyles.of(context).regular20.copyWith(
                    color: AppColors.of(context).neutralColor12
                ),
                            ),
                          ),
              )
              : SizedBox(
            width: double.maxFinite,
            height: 200,
            child: ListView.builder(
              itemCount: momentProvider.listReact.length,
              itemBuilder: (context, index) {
                final react = momentProvider.listReact[index];
                return ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(40),
                    child: CachedNetworkImage(
                      imageUrl: react.avatar,
                      width: 40,
                      height: 40,
                      fit: BoxFit.cover,
                    ),
                  ),
                  title: Text(react.fullname,
                    style: AppTextStyles.of(context).regular20.copyWith(
                        color: AppColors.of(context).neutralColor11
                    ),
                  ),
                  subtitle: Text(react.reacts.join(' '),
                    style: AppTextStyles.of(context).regular16.copyWith(
                        color: AppColors.of(context).primaryColor10
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            alignment: Alignment.center,
              margin: EdgeInsets.only(top: 10.w,left: 4.w,right: 4.w),
              child: MomentContentWidget(momentModel: widget.momentModel)
          ),
          SizedBox(height: 16.h,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(2),
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(100))),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(40.w),
                  child: CachedNetworkImage(
                    imageUrl: widget.momentModel.imgAvatar ?? "",
                    width: 40.w,
                    height: 40.w,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(
                width: 8.w,
              ),
              Text(
                widget.momentModel.userName ?? "",
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: AppTextStyles.of(context).regular16.copyWith(
                  height: 1.5,
                  overflow: TextOverflow.ellipsis,
                  color: AppColors.of(context).neutralColor1,
                  shadows: [
                    const Shadow(
                      blurRadius: 1.0,
                      color: Colors.black,
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 8.w,
              ),
              Text(
                FormatTimeExtension().formatTimeDifference(
                    widget.momentModel.createAt!, context),
                style: AppTextStyles.of(context).light14.copyWith(
                  height: 1,
                  color: AppColors.of(context).neutralColor6,
                  shadows: [
                    Shadow(
                      blurRadius: 1.0,
                      color: AppColors.of(context).neutralColor12,
                    ),
                  ],
                ),
              )
            ],
          ),
          SizedBox(height: 80.h,),
          Row(
            children: [
              Expanded(
                  child: widget.momentModel.userID! != getUserID()? ScaleOnTapWidget(
                    onTap: (isSelect) {
                      showBottomSheetInput();
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 8.w),
                      padding: EdgeInsets.only(top: 6.w, bottom: 2.w, left: 24.w, right: 24.w),
                      decoration: BoxDecoration(
                          color: AppColors.of(context).neutralColor1,
                          border: Border.all(
                            width: 1.w,
                            color: AppColors.of(context).primaryColor10
                          ),
                          borderRadius: const BorderRadius.all(Radius.circular(100))
                      ),
                      child: Text(S.of(context).writeComment,
                        style: AppTextStyles.of(context).light20.copyWith(
                          color: AppColors.of(context).neutralColor8
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ):ScaleOnTapWidget(
                    onTap: (isSelect) {
                      showDialogReact();
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 8.w),
                      padding: EdgeInsets.only(top: 6.w, bottom: 2.w, left: 24.w, right: 24.w),
                      decoration: BoxDecoration(
                          color: AppColors.of(context).neutralColor1,
                          border: Border.all(
                              width: 1.w,
                              color: AppColors.of(context).primaryColor10
                          ),
                          borderRadius: const BorderRadius.all(Radius.circular(100))
                      ),
                      child: Text(S.of(context).viewInteractions,
                        style: AppTextStyles.of(context).light20.copyWith(
                            color: AppColors.of(context).neutralColor8
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  )
              ),
              Expanded(
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 8.w),
                    child: Row(
                      mainAxisAlignment: widget.momentModel.userID! != getUserID()?
                      MainAxisAlignment.spaceBetween:MainAxisAlignment.spaceAround,
                      children: [
                        if(widget.momentModel.userID! != getUserID())
                          IconOnTapScale(
                            icon1Path: Assets.icons.heartOrangeSVG,
                            backGroundColor: AppColors.of(context).neutralColor1,
                            icon1Color: AppColors.of(context).primaryColor9,
                            iconHeight: 28.w, iconWidth: 28.w,
                            borderColor: AppColors.of(context).primaryColor10,
                            onPress: () {
                              context.read<MomentProvider>().sendReact(widget.momentModel.momentID!);
                            },
                          ),
                        IconOnTapScale(
                          icon1Path: Assets.icons.sendSVG,
                          icon2Color: AppColors.of(context).primaryColor9,
                          backGroundColor: AppColors.of(context).neutralColor1,
                          icon1Color: AppColors.of(context).neutralColor9,
                          iconHeight: 28.w, iconWidth: 28.w,
                          borderColor: AppColors.of(context).primaryColor10,
                          onPress: () {

                          },
                        ),
                        SelectFunctionWidget(
                          momentModel: widget.momentModel,
                        )
                      ],
                    ),
                  )
              )
            ],
          ),
        ],
      ),
    );
  }

}

