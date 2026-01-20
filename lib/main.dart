import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:salah_app/providers/providers.dart';
import 'package:salah_app/screens/home.dart';
import 'package:salah_app/services/home_widget_service.dart';
import 'package:salah_app/utils/responsive_utils.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize SharedPreferences before running the app
  await SharedPreferencesNotifier.init();

  // Initialize home widget service
  await HomeWidgetService.initialize();

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
    return ScreenUtilInit(
      designSize: const Size(412, 917),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
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
      },
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

    // Watch the state to rebuild when locale changes
    ref.watch(languageProvider);
    final langNotifier = ref.read(languageProvider.notifier);
    final dailySalah = ref.watch(dailySalahProvider);

    // Update home widget with current salah times
    WidgetsBinding.instance.addPostFrameCallback((_) {
      HomeWidgetService.updateWidget(dailySalah);
    });

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
          Responsive.horizontalSpace(12, context),
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
      offset: Offset(Responsive.w(-10, context), Responsive.h(32, context)),
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
        borderRadius: Responsive.circular(35, context),
      ),
      child: Padding(
        padding: Responsive.symmetric(context: context, horizontal: 8, vertical: 4),
        child: Row(
          children: [
            Icon(Icons.location_on, color: Colors.black54, size: Responsive.sp(16, context)),
            Text(
              region,
              style: TextStyle(fontSize: Responsive.sp(16, context), color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}
