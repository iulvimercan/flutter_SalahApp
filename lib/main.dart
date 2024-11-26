import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salah_app/model/TimeProvider.dart';
import 'package:salah_app/screens/home.dart';
import 'package:salah_app/screens/kankim.dart';
import 'package:salah_app/services/KankimProvider.dart';
import 'package:salah_app/services/LanguageService.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'model/DailySalah.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MaterialApp(
      localizationsDelegates: const [
        GlobalCupertinoLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''), // English
        Locale('tr', ''), // Turkish
      ],
      localeResolutionCallback: (locale, supportedLocales) {
        if (locale == null) {
          return const Locale('en', ''); // Default locale
        }
        for (var supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale.languageCode) {
            return supportedLocale;
          }
        }
        return const Locale('en', ''); // Default locale
      },
      home: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (c) => LanguageService()),
          ChangeNotifierProvider(create: (c) => DailySalah.current()),
          ChangeNotifierProvider(create: (c) => TimeProvider()),
          ChangeNotifierProvider(create: (c) => KankimProvider()),
        ],
        child: const HomeScreen(),
      ),
    ),
  );
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    KankimProvider kankimProvider = Provider.of<KankimProvider>(context);
    LanguageService lang = Provider.of<LanguageService>(context, listen: false);
    lang.locale = Localizations.localeOf(context).languageCode;
    var title = lang.get('app_title');
    return kankimProvider.isActive ? Kankim() : Home(title: title);
  }
}
