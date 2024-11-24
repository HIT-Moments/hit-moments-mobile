// app/views/example/example_view.dart
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hit_moments/app/core/config/theme_config.dart';
import 'package:hit_moments/app/core/extensions/theme_extensions.dart';
import 'package:hit_moments/app/datasource/local/storage.dart';
import 'package:hit_moments/app/l10n/l10n.dart';
//import 'package:hit_moments/app/l10n/l10n.dart';
import 'package:hit_moments/app/providers/language_provider.dart';
import 'package:hit_moments/app/providers/theme_provider.dart';
import 'package:hit_moments/app/views/example/home_view.dart';
import 'package:hit_moments/app/views/moment/camera/take_pictures_screen.dart';
import 'package:hit_moments/app/routes/app_routes.dart';
import 'package:hit_moments/app/views/auth/auth_view.dart';
import 'package:hit_moments/app/views/conversation/conversation_view.dart';
import 'package:hit_moments/app/views/list_my_friend/list_my_friend_view.dart';
import 'package:hit_moments/app/views/moment/moment_view.dart';
import 'package:hit_moments/app/views/moment/widget/get_weather_widget.dart';
import 'package:hit_moments/app/views/onboarding/onboarding_view.dart';
import 'package:hit_moments/app/views/profile/personalPageWidget.dart';
import 'package:hit_moments/app/views/profile/personalPageview.dart';
import 'package:hit_moments/app/views/suggested_friends/suggested_friends_view.dart';
import 'package:provider/provider.dart';

class ExampleView extends StatefulWidget {
  const ExampleView({super.key});

  @override
  State<ExampleView> createState() => _ExampleViewState();
}

class _ExampleViewState extends State<ExampleView> {
  bool _value = false;

  @override
  Widget build(BuildContext context) {
    print(Platform.localeName);
    print(getToken());
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.of(context).primaryColor12,
      ),
      body: Center(
        child: Column(
          children: [
            Text(
              S.of(context)!.hello,
              style: AppTextStyles.of(context).regular32.copyWith(
                color: AppColors.of(context).neutralColor12,
              ),
            ),
            // ElevatedButton(
            //     onPressed: () {
            //       Navigator.push(
            //           context,
            //           MaterialPageRoute(
            //             builder: (context) => MomentView(),
            //           ));
            //     },
            //     child: Text("Moment")),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SuggestedFriendsView(),
                      ));
                },
                child: Text("Suggested Friends")),
            ElevatedButton(
                onPressed: () {

                },
                child: Text("Đăng xuất")),
            // ElevatedButton(
            //     onPressed: () {
            //       Navigator.push(
            //           context,
            //           MaterialPageRoute(
            //             builder: (context) => const TakePictureScreen(),
            //           ));
            //     },
            //     child: Text("Home")),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ListMyFriendView(),
                      ));
                },
                child: Text("List My Friend")),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ConversationView(),
                      ));
                },
                child: Text("My Conversation")),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const GetWeatherWidget(),
                      ));
                },
                child: Text("Get weather")),
            // ElevatedButton(
            //     onPressed: () {
            //       Navigator.push(
            //           context,
            //           MaterialPageRoute(
            //             builder: (context) => TakePictureScreen(),
            //           ));
            //     },
            //     child: Text("Camera")),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PersonalPageScreen(),
                      ));
                },
                child: Text("Trang cá nhân")),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Onboarding(),
                      ));
                },
                child: Text("Onboarding")),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomeView(),
                      ));
                },
                child: Text("Home App")),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        child: Switch(
          onChanged: (value) {
            setState(() {
              _value = value;
              print(value);
              if (value) {
                context.read<LocaleProvider>().changeLocale(const Locale('en'));
                context
                    .read<ThemeProvider>()
                    .setThemeData(ThemeConfig.darkTheme);
              } else {
                context.read<LocaleProvider>().changeLocale(const Locale('vi'));
                context
                    .read<ThemeProvider>()
                    .setThemeData(ThemeConfig.lightTheme);
              }
            });
          },
          value: _value,
        ),
      ),
    );
  }
}
