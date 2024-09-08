import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salah_app/screens/home.dart';
import 'package:salah_app/services/LanguageService.dart';


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
      ],
      child: MaterialApp(

        home: Scaffold(
          appBar: AppBar(
            title: Consumer<LanguageService>(
              builder: (context, lang, child) {
                return Text(lang.get('app_title'));
              },
            ),
            actions: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.language),
              ),
            ],
          ),
          body: const Home(),
        ),
      ),
    );
  }
}
