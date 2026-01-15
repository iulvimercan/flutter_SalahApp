package com.example.salah_app

import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.SharedPreferences
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetPlugin
import java.text.SimpleDateFormat
import java.util.*
import android.content.Intent
import android.app.PendingIntent
import android.app.AlarmManager
import android.content.ComponentName
import android.os.Build
import android.util.Log

class SalahTimerWidgetProvider : AppWidgetProvider() {

    companion object {
        private const val TAG = "SalahTimerWidget"
        private const val ACTION_UPDATE = "com.example.salah_app.ACTION_UPDATE_WIDGET"
        private const val UPDATE_INTERVAL = 30_000L // Update every minute

        // Salah time keys
        private val SALAH_NAMES = listOf("fajr", "sunrise", "dhuhr", "asr", "maghrib", "isha")
        private val SALAH_DISPLAY_NAMES = mapOf(
            "fajr" to "İmsak",
            "sunrise" to "Güneş",
            "dhuhr" to "Öğle",
            "asr" to "İkindi",
            "maghrib" to "Akşam",
            "isha" to "Yatsı"
        )

        fun updateAllWidgets(context: Context) {
            try {
                val intent = Intent(context, SalahTimerWidgetProvider::class.java).apply {
                    action = AppWidgetManager.ACTION_APPWIDGET_UPDATE
                }
                val appWidgetManager = AppWidgetManager.getInstance(context)
                val appWidgetIds = appWidgetManager.getAppWidgetIds(
                    ComponentName(context, SalahTimerWidgetProvider::class.java)
                )
                intent.putExtra(AppWidgetManager.EXTRA_APPWIDGET_IDS, appWidgetIds)
                context.sendBroadcast(intent)
            } catch (e: Exception) {
                Log.e(TAG, "Error updating all widgets", e)
            }
        }
    }

    override fun onReceive(context: Context, intent: Intent) {
        try {
            super.onReceive(context, intent)
            if (intent.action == ACTION_UPDATE) {
                val appWidgetManager = AppWidgetManager.getInstance(context)
                val appWidgetIds = appWidgetManager.getAppWidgetIds(
                    ComponentName(context, SalahTimerWidgetProvider::class.java)
                )
                for (appWidgetId in appWidgetIds) {
                    updateAppWidget(context, appWidgetManager, appWidgetId)
                }
                scheduleNextUpdate(context)
            }
        } catch (e: Exception) {
            Log.e(TAG, "Error in onReceive", e)
        }
    }

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        try {
            for (appWidgetId in appWidgetIds) {
                updateAppWidget(context, appWidgetManager, appWidgetId)
            }
            scheduleNextUpdate(context)
        } catch (e: Exception) {
            Log.e(TAG, "Error in onUpdate", e)
        }
    }

    override fun onEnabled(context: Context) {
        super.onEnabled(context)
        try {
            scheduleNextUpdate(context)
        } catch (e: Exception) {
            Log.e(TAG, "Error in onEnabled", e)
        }
    }

    override fun onDisabled(context: Context) {
        super.onDisabled(context)
        try {
            cancelUpdates(context)
        } catch (e: Exception) {
            Log.e(TAG, "Error in onDisabled", e)
        }
    }

    private fun scheduleNextUpdate(context: Context) {
        try {
            val alarmManager = context.getSystemService(Context.ALARM_SERVICE) as? AlarmManager
            if (alarmManager == null) {
                Log.e(TAG, "AlarmManager is null")
                return
            }

            val intent = Intent(context, SalahTimerWidgetProvider::class.java).apply {
                action = ACTION_UPDATE
            }
            val pendingIntent = PendingIntent.getBroadcast(
                context,
                0,
                intent,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )

            // Schedule update in 1 second
            val triggerTime = System.currentTimeMillis() + UPDATE_INTERVAL

            // Use setExactAndAllowWhileIdle for Android 6.0+ or set for older versions
            // Wrap in try-catch for permission issues on Android 12+
            when {
                Build.VERSION.SDK_INT >= Build.VERSION_CODES.S -> {
                    // Android 12+ - check if we can schedule exact alarms
                    if (alarmManager.canScheduleExactAlarms()) {
                        alarmManager.setExactAndAllowWhileIdle(AlarmManager.RTC, triggerTime, pendingIntent)
                    } else {
                        // Fall back to inexact alarm
                        alarmManager.set(AlarmManager.RTC, triggerTime, pendingIntent)
                    }
                }
                Build.VERSION.SDK_INT >= Build.VERSION_CODES.M -> {
                    alarmManager.setExactAndAllowWhileIdle(AlarmManager.RTC, triggerTime, pendingIntent)
                }
                else -> {
                    alarmManager.setExact(AlarmManager.RTC, triggerTime, pendingIntent)
                }
            }
        } catch (e: SecurityException) {
            Log.e(TAG, "SecurityException scheduling alarm - permission denied", e)
            // Try with inexact alarm as fallback
            try {
                val alarmManager = context.getSystemService(Context.ALARM_SERVICE) as? AlarmManager
                val intent = Intent(context, SalahTimerWidgetProvider::class.java).apply {
                    action = ACTION_UPDATE
                }
                val pendingIntent = PendingIntent.getBroadcast(
                    context,
                    0,
                    intent,
                    PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
                )
                alarmManager?.set(AlarmManager.RTC, System.currentTimeMillis() + UPDATE_INTERVAL, pendingIntent)
            } catch (e2: Exception) {
                Log.e(TAG, "Fallback alarm scheduling also failed", e2)
            }
        } catch (e: Exception) {
            Log.e(TAG, "Error scheduling next update", e)
        }
    }

    private fun cancelUpdates(context: Context) {
        try {
            val alarmManager = context.getSystemService(Context.ALARM_SERVICE) as? AlarmManager
            val intent = Intent(context, SalahTimerWidgetProvider::class.java).apply {
                action = ACTION_UPDATE
            }
            val pendingIntent = PendingIntent.getBroadcast(
                context,
                0,
                intent,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )
            alarmManager?.cancel(pendingIntent)
        } catch (e: Exception) {
            Log.e(TAG, "Error canceling updates", e)
        }
    }

    private fun updateAppWidget(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetId: Int
    ) {
        try {
            val views = RemoteViews(context.packageName, R.layout.salah_timer_widget)

            // Get salah times from HomeWidget shared preferences
            val widgetData = HomeWidgetPlugin.getData(context)

            val nextSalah = getNextSalah(widgetData)
            val remainingTime = calculateRemainingTime(nextSalah?.second)
            val isKerahatTime = checkKerahatTime(widgetData)

            // Update text views
            views.setTextViewText(R.id.salah_name, nextSalah?.first ?: "---")
            views.setTextViewText(R.id.remaining_time, remainingTime)

            // Update background based on kerahat time
            val backgroundResource = if (isKerahatTime) {
                R.drawable.widget_background_kerahat
            } else {
                R.drawable.widget_background
            }
            views.setInt(R.id.widget_container, "setBackgroundResource", backgroundResource)

            // Set click action to open app
            val intent = Intent(context, MainActivity::class.java).apply {
                flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP
            }
            val pendingIntent = PendingIntent.getActivity(
                context,
                0,
                intent,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )
            views.setOnClickPendingIntent(R.id.widget_container, pendingIntent)

            appWidgetManager.updateAppWidget(appWidgetId, views)
        } catch (e: Exception) {
            Log.e(TAG, "Error updating widget $appWidgetId", e)
        }
    }

    private fun getNextSalah(prefs: SharedPreferences): Pair<String, Date>? {
        val now = Date()
        val dateFormat = SimpleDateFormat("yyyy-MM-dd HH:mm", Locale.getDefault())
        val todayDate = SimpleDateFormat("yyyy-MM-dd", Locale.getDefault()).format(now)

        for (salahName in SALAH_NAMES) {
            val timeStr = prefs.getString("salah_$salahName", null) ?: continue
            try {
                val salahTime = dateFormat.parse("$todayDate $timeStr") ?: continue
                if (salahTime.after(now)) {
                    return Pair(SALAH_DISPLAY_NAMES[salahName] ?: salahName, salahTime)
                }
            } catch (e: Exception) {
                continue
            }
        }

        // If no salah found today, return tomorrow's fajr
        val fajrTimeStr = prefs.getString("salah_fajr", null)
        if (fajrTimeStr != null) {
            try {
                val tomorrow = Calendar.getInstance()
                tomorrow.add(Calendar.DAY_OF_YEAR, 1)
                val tomorrowDate = SimpleDateFormat("yyyy-MM-dd", Locale.getDefault()).format(tomorrow.time)
                val fajrTime = dateFormat.parse("$tomorrowDate $fajrTimeStr")
                if (fajrTime != null) {
                    return Pair(SALAH_DISPLAY_NAMES["fajr"] ?: "İmsak", fajrTime)
                }
            } catch (e: Exception) {
                // Ignore
            }
        }

        return null
    }

    private fun calculateRemainingTime(targetTime: Date?): String {
        if (targetTime == null) return "0:00"

        val now = Date()
        val diffMillis = targetTime.time - now.time

        if (diffMillis <= 0) return "0:00"

        val hours = diffMillis / (1000 * 60 * 60)
        val minutes = (diffMillis / (1000 * 60)) % 60

        return String.format("%d:%02d", hours, minutes)
    }

    private fun checkKerahatTime(prefs: SharedPreferences): Boolean {
        val now = Date()
        val dateFormat = SimpleDateFormat("yyyy-MM-dd HH:mm", Locale.getDefault())
        val todayDate = SimpleDateFormat("yyyy-MM-dd", Locale.getDefault()).format(now)

        try {
            val sunriseStr = prefs.getString("salah_sunrise", null) ?: return false
            val dhuhrStr = prefs.getString("salah_dhuhr", null) ?: return false
            val maghribStr = prefs.getString("salah_maghrib", null) ?: return false

            val sunrise = dateFormat.parse("$todayDate $sunriseStr") ?: return false
            val dhuhr = dateFormat.parse("$todayDate $dhuhrStr") ?: return false
            val maghrib = dateFormat.parse("$todayDate $maghribStr") ?: return false

            // Kerahat times: 45 mins after sunrise, 45 mins before dhuhr, 45 mins before maghrib
            val sunriseKerahatEnd = Calendar.getInstance().apply {
                time = sunrise
                add(Calendar.MINUTE, 45)
            }.time

            val dhuhrKerahatStart = Calendar.getInstance().apply {
                time = dhuhr
                add(Calendar.MINUTE, -45)
            }.time

            val maghribKerahatStart = Calendar.getInstance().apply {
                time = maghrib
                add(Calendar.MINUTE, -45)
            }.time

            return (now.after(sunrise) && now.before(sunriseKerahatEnd)) ||
                   (now.after(dhuhrKerahatStart) && now.before(dhuhr)) ||
                   (now.after(maghribKerahatStart) && now.before(maghrib))
        } catch (e: Exception) {
            return false
        }
    }
}
