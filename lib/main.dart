import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salah_app/providers/providers.dart';
import 'package:salah_app/screens/home.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize SharedPreferences before running the app
  await SharedPreferencesNotifier.init();

  runApp(
    const ProviderScope(
      child: SalahApp(),
    ),
  );
}

class SalahApp extends ConsumerStatefulWidget {
  const SalahApp({super.key});

  @override
  ConsumerState<SalahApp> createState() => _SalahAppState();
}

class _SalahAppState extends ConsumerState<SalahApp> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: const [
        GlobalCupertinoLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''),
        Locale('tr', ''),
      ],
      localeResolutionCallback: (locale, supportedLocales) {
        if (locale == null) {
          return const Locale('en', '');
        }
        for (var supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale.languageCode) {
            return supportedLocale;
          }
        }
        return const Locale('en', '');
      },
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Initialize language based on device locale
    final deviceLocale = Localizations.localeOf(context).languageCode;

    // Set locale on first build if not already set
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final currentLocale = ref.read(languageProvider).locale;
      if (currentLocale != deviceLocale) {
        ref.read(languageProvider.notifier).setLocale(deviceLocale);
      }
    });

    final langNotifier = ref.read(languageProvider.notifier);
    final dailySalah = ref.watch(dailySalahProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 254, 233),
        title: Text(langNotifier.get('app_title'), style: GoogleFonts.lato()),
        actions: [
          _RegionSelector(
            currentRegion: dailySalah.region,
            onRegionSelected: (region) {
              ref.read(dailySalahProvider.notifier).setRegion(region);
            },
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: const Home(),
    );
  }
}

class _RegionSelector extends StatelessWidget {
  final String currentRegion;
  final Function(String) onRegionSelected;

  const _RegionSelector({
    required this.currentRegion,
    required this.onRegionSelected,
  });

  static const List<String> _availableRegions = [
    'İstanbul',
    'Başakşehir',
    'Küçükçekmece',
    'Tuzla',
  ];

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      offset: const Offset(-10, 32),
      child: _RegionDisplayButton(region: currentRegion),
      itemBuilder: (context) {
        return _availableRegions.map((region) {
          return PopupMenuItem(
            child: Text(region),
            onTap: () => onRegionSelected(region),
          );
        }).toList();
      },
    );
  }
}

class _RegionDisplayButton extends StatelessWidget {
  final String region;

  const _RegionDisplayButton({required this.region});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black54),
        borderRadius: BorderRadius.circular(35),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        child: Row(
          children: [
            const Icon(Icons.location_on, color: Colors.black54, size: 16),
            Text(
              region,
              style: const TextStyle(fontSize: 16, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}
