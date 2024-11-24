// app/views/profile/informationPersonalWidget.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hit_moments/app/core/constants/assets.dart';
import 'package:hit_moments/app/core/extensions/theme_extensions.dart';
import 'package:hit_moments/app/l10n/l10n.dart';
import 'package:hit_moments/app/models/user_model.dart';
import 'package:hit_moments/app/providers/user_provider.dart';
import 'package:hit_moments/app/views/profile/editInformationPersonal.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class informationPersonalWidget extends StatefulWidget {
  final User userInfor;
  const informationPersonalWidget({super.key, required this.userInfor});
  
  @override
  State<informationPersonalWidget> createState() => informationPersonalWidgetState();
} 

class informationPersonalWidgetState extends State<informationPersonalWidget> {
  @override
  void initState() {
    super.initState();
  }

  String formatPhone(String phone) {
    final String firstPart = phone.substring(0, 4);
    final String remaining = phone.substring(4);
    final tmp = remaining.replaceRange(0, remaining.length, 'X' * remaining.length);
    final String formattedRemaining = tmp.replaceAllMapped(RegExp(r".{3}"), (match) {
      return '${match.group(0)} ';
    });

    final String formatted = '$firstPart $formattedRemaining';

    return formatted.trim(); // Use trim to remove the trailing space
  }

  String formatDate(DateTime date) {
    final DateFormat formatter = DateFormat('dd/MM/yyyy');
    final String formatted = formatter.format(date);
    return formatted;
  }
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 20.h),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: (context.watch<UserProvider>().isLoandingProfiles) ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(Assets.icons.call),
                  Container(
                    margin: EdgeInsets.only(left: 20.w),
                    width: 150.w,
                    child: Text(formatPhone(widget.userInfor.phoneNumber!), style: AppTextStyles.of(context).light20,)
                  ),
                ],
              ),
              SizedBox(height: 20.h,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(Assets.icons.calendar),
                  Container(
                    margin: EdgeInsets.only(left: 20.w),
                    width: 150.w,
                    child: Text(formatDate(widget.userInfor.dob!), style: AppTextStyles.of(context).light20,)
                  ),
                ],
              ),
              SizedBox(height: 20.h,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(Assets.icons.mail),
                  Container(
                    margin: EdgeInsets.only(left: 20.w),
                    width: 150.w,
                    child: Text(widget.userInfor.email!, style: AppTextStyles.of(context).light20,)
                  ),
                ],
              ),
              SizedBox(height: 70.h,),
              ElevatedButton(
                onPressed: () { 
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => editInformationPersonal(userInfor: context.watch<UserProvider>().user,))
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.of(context).neutralColor7,
                  padding: const EdgeInsets.fromLTRB(30, 5, 30, 5)
                ),
                child: Text(S.of(context).editInfor, style: AppTextStyles.of(context).regular20.copyWith(color: AppColors.of(context).neutralColor11),)
              ),
              const SizedBox(height: 40,),
            ],
          ) : const SizedBox(),
        ),
      ),
    );
  }
}