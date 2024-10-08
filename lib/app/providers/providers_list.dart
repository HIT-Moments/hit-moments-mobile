import 'package:hit_moments/app/providers/auth_provider.dart';
import 'package:hit_moments/app/providers/list_moment_provider.dart';
import 'package:hit_moments/app/providers/language_provider.dart';
import 'package:hit_moments/app/providers/moment_provider.dart';
import 'package:hit_moments/app/providers/theme_provider.dart';
import 'package:hit_moments/app/providers/user_provider.dart';
import 'package:hit_moments/app/providers/weather_provider.dart';

final listProviders = [
  ListMomentProvider(),
  ThemeProvider(),
  UserProvider(),
  LocaleProvider(),
  AuthProvider(),
  WeatherProvider()
];
