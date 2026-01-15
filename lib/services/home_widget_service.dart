import 'package:home_widget/home_widget.dart';
import 'package:salah_app/providers/daily_salah_provider.dart';

/// Service for updating the Android home screen widget with salah times
class HomeWidgetService {
  static const String _appGroupId = 'group.com.example.salah_app';
  static const String _androidWidgetName = 'SalahTimerWidgetProvider';

  /// Initialize home widget
  static Future<void> initialize() async {
    await HomeWidget.setAppGroupId(_appGroupId);
  }

  /// Update the home widget with current salah times
  static Future<void> updateWidget(DailySalahState dailySalah) async {
    try {
      // Save salah times to shared preferences for the widget
      await HomeWidget.saveWidgetData<String>(
        'salah_fajr',
        _formatTime(dailySalah.fajr),
      );
      await HomeWidget.saveWidgetData<String>(
        'salah_sunrise',
        _formatTime(dailySalah.sunrise),
      );
      await HomeWidget.saveWidgetData<String>(
        'salah_dhuhr',
        _formatTime(dailySalah.dhuhr),
      );
      await HomeWidget.saveWidgetData<String>(
        'salah_asr',
        _formatTime(dailySalah.asr),
      );
      await HomeWidget.saveWidgetData<String>(
        'salah_maghrib',
        _formatTime(dailySalah.maghrib),
      );
      await HomeWidget.saveWidgetData<String>(
        'salah_isha',
        _formatTime(dailySalah.isha),
      );

      // Trigger widget update
      await HomeWidget.updateWidget(
        androidName: _androidWidgetName,
      );
    } catch (e) {
      // Handle error silently - widget might not be placed
      print('Error updating home widget: $e');
    }
  }

  /// Format DateTime to HH:mm string
  static String _formatTime(DateTime time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}

