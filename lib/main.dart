import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salah_app/model/TimeProvider.dart';
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
        ChangeNotifierProvider(create: (c) => TimeProvider()),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Consumer<LanguageService>(
            builder: (context, lang, child) {
              return Text(lang.get('app_title'));
            },
          ),
          actions: [
            PopupMenuButton(
              offset: const Offset(-10, 32),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black54),
                  borderRadius: BorderRadius.circular(35),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                  child: Row(
                    children: [
                      const Icon(Icons.location_on, color: Colors.black54, size: 16,),
                      Consumer<DailySalah>(
                        builder: (context, dailySalah, child) {
                          return Text(
                            dailySalah.region,
                            style: TextStyle(fontSize: 16, color: Colors.black54),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              itemBuilder: (context) {
                return [
                  PopupMenuItem(
                    child: Text('İstanbul'),
                    onTap: () {
                      Provider.of<DailySalah>(context, listen: false).region =
                          'İstanbul';
                    },
                  ),
                  PopupMenuItem(
                    child: Text('Başakşehir'),
                    onTap: () {
                      Provider.of<DailySalah>(context, listen: false).region =
                          'Başakşehir';
                    },
                  ),
                  PopupMenuItem(
                    child: Text('Küçükçekmece'),
                    onTap: () {
                      Provider.of<DailySalah>(context, listen: false).region =
                          'Küçükçekmece';
                    },
                  ),
                ];
              },
            ),
            const SizedBox(width: 12),
          ],
        ),
        body: const Home(),
      ),
    );
  }
}
