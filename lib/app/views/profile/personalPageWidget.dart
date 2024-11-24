import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hit_moments/app/core/config/theme_config.dart';
import 'package:hit_moments/app/core/constants/assets.dart';
import 'package:hit_moments/app/core/constants/color_constants.dart';
import 'package:hit_moments/app/core/extensions/theme_extensions.dart';
import 'package:hit_moments/app/providers/language_provider.dart';
import 'package:hit_moments/app/providers/theme_provider.dart';
import 'package:provider/provider.dart';

import '../../datasource/local/storage.dart';
import '../../routes/app_routes.dart';

class PersonalPageWidget extends StatefulWidget {
  const PersonalPageWidget({super.key});

  @override
  State<PersonalPageWidget> createState() => PersonalPageScreenState();
}

class PersonalPageScreenState extends State<PersonalPageWidget> {
  bool _value1 = getIsDarkMode();
  bool _value2 = getLocaleLocal().languageCode == 'en' ? true : false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    SvgPicture.asset(
                      Assets.icons.lightDark,
                      color: AppColors.of(context).neutralColor11,
                    ),
                    SizedBox(
                      width: 10.w,
                    ),
                    Text(AppLocalizations.of(context)!.modeLightDark,
                        style: AppTextStyles.of(context).light20.copyWith(
                            color: AppColors.of(context).neutralColor12)),
                  ],
                ),
                // Switch(
                //   value : _value1,
                //   onChanged: (value) {
                //     setState(() {
                //       if (_value1!=true) {
                //         context.read<ThemeProvider>().setThemeData(ThemeConfig.darkTheme);
                //       } else {
                //         context.read<ThemeProvider>().setThemeData(ThemeConfig.lightTheme);
                //       }
                //       _value1 = value;
                //       setDarkMode(_value1);
                //     });
                //   },
                // ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      if (_value1 != true) {
                        context
                            .read<ThemeProvider>()
                            .setThemeData(ThemeConfig.darkTheme);
                      } else {
                        context
                            .read<ThemeProvider>()
                            .setThemeData(ThemeConfig.lightTheme);
                      }
                      _value1 = !_value1;
                      setDarkMode(_value1);
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.linear,
                    width: 52.w,
                    height: 26.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: _value1
                          ? ColorConstants.neutralDark20
                          : ColorConstants.neutralLight50,
                    ),
                    child: AnimatedAlign(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.linear,
                      alignment: _value1
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: _value1 == false
                            ? SvgPicture.asset(
                                Assets.icons.sun,
                                width: 26.w,
                                height: 26.w,
                              )
                            : SvgPicture.asset(
                                Assets.icons.dark,
                                width: 26.w,
                                height: 26.w,
                              ),
                      ),
                    ),
                  ),
                )
              ],
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 12.w),
              child: Divider(
                color: AppColors.of(context).neutralColor12,
                height: 1,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    SvgPicture.asset(
                      Assets.icons.settings,
                      color: AppColors.of(context).neutralColor11,
                    ),
                    SizedBox(
                      width: 15.w,
                    ),
                    Text(AppLocalizations.of(context)!.language,
                        style: AppTextStyles.of(context).light20.copyWith(
                            color: AppColors.of(context).neutralColor12)),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      if (_value2 != true) {
                        context
                            .read<LocaleProvider>()
                            .changeLocale(const Locale('en'));
                      } else {
                        context
                            .read<LocaleProvider>()
                            .changeLocale(const Locale('vi'));
                      }
                      _value2 = !_value2;
                      setLocaleLocal(_value2 ? 'en' : 'vi');
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.linear,
                    width: 52.w,
                    height: 26.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: _value2
                          ? ColorConstants.neutralDark20
                          : ColorConstants.neutralLight50,
                    ),
                    child: AnimatedAlign(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.linear,
                      alignment: _value2
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: _value2 == false
                            ? SvgPicture.asset(
                                Assets.icons.vietNam,
                                width: 26.w,
                                height: 26.w,
                              )
                            : SvgPicture.asset(
                                Assets.icons.my,
                                width: 26.w,
                                height: 26.w,
                              ),
                      ),
                    ),
                  ),
                )
              ],
            ),
            Container(
              margin: EdgeInsets.only(top: 12.w, bottom: 12.w),
              child: Divider(
                color: AppColors.of(context).neutralColor12,
                height: 1,
              ),
            ),
            Row(
              children: [
                SvgPicture.asset(
                  Assets.icons.danger,
                  color: AppColors.of(context).neutralColor11,
                ),
                SizedBox(
                  width: 15.w,
                ),
                Text(AppLocalizations.of(context)!.report,
                    style: AppTextStyles.of(context)
                        .light20
                        .copyWith(color: AppColors.of(context).neutralColor12))
              ],
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 12.w),
              child: Divider(
                color: AppColors.of(context).neutralColor12,
                height: 1,
              ),
            ),
            Row(
              children: [
                SvgPicture.asset(
                  Assets.icons.document2,
                  color: AppColors.of(context).neutralColor11,
                ),
                SizedBox(
                  width: 15.w,
                ),
                Text(AppLocalizations.of(context)!.blockList,
                    style: AppTextStyles.of(context)
                        .light20
                        .copyWith(color: AppColors.of(context).neutralColor12))
              ],
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 12.w),
              child: Divider(
                color: AppColors.of(context).neutralColor12,
                height: 1,
              ),
            ),
            Row(
              children: [
                SvgPicture.asset(
                  Assets.icons.star,
                  color: AppColors.of(context).neutralColor11,
                ),
                SizedBox(
                  width: 15.w,
                ),
                Text(AppLocalizations.of(context)!.review,
                    style: AppTextStyles.of(context)
                        .light20
                        .copyWith(color: AppColors.of(context).neutralColor12))
              ],
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 12.w),
              child: Divider(
                color: AppColors.of(context).neutralColor12,
                height: 1,
              ),
            ),
            Row(
              children: [
                SvgPicture.asset(
                  Assets.icons.document2,
                  color: AppColors.of(context).neutralColor11,
                ),
                SizedBox(
                  width: 15.w,
                ),
                Text(AppLocalizations.of(context)!.tos,
                    style: AppTextStyles.of(context)
                        .light20
                        .copyWith(color: AppColors.of(context).neutralColor12))
              ],
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 12.w),
              child: Divider(
                color: AppColors.of(context).neutralColor12,
                height: 1,
              ),
            ),
            Row(
              children: [
                SvgPicture.asset(
                  Assets.icons.shield,
                  color: AppColors.of(context).neutralColor11,
                ),
                SizedBox(
                  width: 15.w,
                ),
                Text(AppLocalizations.of(context)!.privacy,
                    style: AppTextStyles.of(context)
                        .light20
                        .copyWith(color: AppColors.of(context).neutralColor12))
              ],
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 12.w),
              child: Divider(
                color: AppColors.of(context).neutralColor12,
                height: 1,
              ),
            ),
            InkWell(
              onTap: () {
                _logout();
              },
              child: Row(
                children: [
                  SvgPicture.asset(
                    Assets.icons.logout,
                    color: AppColors.of(context).neutralColor11,
                  ),
                  SizedBox(
                    width: 15.w,
                  ),
                  Text(AppLocalizations.of(context)!.logout,
                      style: AppTextStyles.of(context).light20.copyWith(
                          color: AppColors.of(context).neutralColor12))
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 12.w),
              child: Divider(
                color: AppColors.of(context).neutralColor12,
                height: 1,
              ),
            ),
            InkWell(
              onTap: () {},
              child: Row(
                children: [
                  SvgPicture.asset(
                    Assets.icons.trash,
                    color: AppColors.of(context).neutralColor11,
                  ),
                  SizedBox(
                    width: 15.w,
                  ),
                  Text(AppLocalizations.of(context)!.deleteAcc,
                      style: AppTextStyles.of(context).light20.copyWith(
                          color: AppColors.of(context).primaryColor10))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
  void _logout() {
    setEmail('');
    setPassWord('');
    setToken('');
    setUserID('');
    setAvatarUser('');
    Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.AUTHENTICATION,
        (route) => false);
  }
}
