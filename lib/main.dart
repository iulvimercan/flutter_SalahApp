import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salah_app/screens/home.dart';
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
      home: const HomeScreen(),
    ),
  );
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var deviceLocale = Localizations.localeOf(context).languageCode;

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (c) => LanguageService(locale: deviceLocale)),
        ChangeNotifierProvider(create: (c) => DailySalah.current()),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Consumer<LanguageService>(
            builder: (context, lang, child) {
              return Text(lang.get('app_title'));
            },
          ),
        ),
        body: const Home(),
      ),
    );
  }
}
