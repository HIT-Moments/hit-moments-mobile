import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hit_moments/app/core/config/app_config.dart';
import 'package:hit_moments/app/l10n/l10n.dart';
import 'package:hit_moments/app/providers/language_provider.dart';
import 'package:hit_moments/app/providers/providers_list.dart';
import 'package:hit_moments/app/routes/app_pages.dart';
import 'package:hit_moments/app/routes/app_routes.dart';
import 'package:provider/provider.dart';

void main() async {
  await GetStorage.init('hit_moment');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final LocaleProvider locale = LocaleProvider();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ...listProviders.map((e) => ChangeNotifierProvider(create: (context) => e)),

        //provider ngôn ngữ riêng
        ChangeNotifierProvider(
          create: (context) => locale,
        )
      ],
      child: Consumer<LocaleProvider>(
        builder: (context, provider, child) => MaterialApp(
          title: AppConfig.appName,
          locale: provider.locale,
          // themeAnimationCurve: Curves.easeIn,
          // themeAnimationDuration: const Duration(milliseconds: 500),
          debugShowCheckedModeBanner: false,
          initialRoute: AppRoutes.SPASH,
          routes: AppPages.routes,
          supportedLocales: L10n.all,
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            AppLocalizations.delegate,
          ],
        ),
      ),
    );
  }
}
