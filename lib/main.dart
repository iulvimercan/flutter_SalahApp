import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salah_app/screens/home.dart';
import 'package:salah_app/services/LanguageService.dart';

import 'model/DailySalah.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const SalahApp());
}

class SalahApp extends StatelessWidget {
  const SalahApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (c) => LanguageService()),
        ChangeNotifierProvider(create: (c) => DailySalah.current()),
      ],
      child: MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            title: Consumer<LanguageService>(
              builder: (context, lang, child) {
                return Text(lang.get('app_title'));
              },
            ),
          ),
          body: const Home(),
        ),
      ),
    );
  }
}
