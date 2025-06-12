import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:intl/intl.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> initNotifications() async {
  try {
    // Initialize timezone
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Africa/Cairo'));
    print('🔔 Local timezone: ${tz.local.name}');

    // Configure Android notification channel
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'reminder_channel',
      'Reminders',
      description: 'Reminder notifications',
      importance: Importance.max,
      playSound: true,
      enableVibration: true,
      showBadge: true,
    );

    // Create notification channel
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    // Android initialization settings
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    // Initialize plugin
    bool? initialized = await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        print('🔔 Notification received: ${response.payload}');
      },
    );
    print('🔔 Notification initialization: ${initialized == true ? "Successful" : "Failed"}');

    // Request notification permission for Android 13+
    final androidPlugin = flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    bool? permissionGranted = await androidPlugin?.requestNotificationsPermission();
    print('🔔 Notification permission: ${permissionGranted == true ? "Granted" : "Denied"}');
  } catch (e) {
    print('❌ Error initializing notifications: $e');
  }
}

Future<void> scheduleReminderNotification({
  required int id,
  required String title,
  required String body,
  required String dateStringFromUI,
  String repeat = 'Once',
}) async {
  try {
    // Cancel any previous notification with the same ID
    await flutterLocalNotificationsPlugin.cancel(id);
    print('🔔 Cancelled previous notification with ID: $id');

    // Parse the date string
    final dateFormat = DateFormat('MM/dd/yyyy hh:mm a');
    final parsedDate = dateFormat.parse(dateStringFromUI);

    // Ensure the date is in the future
    if (parsedDate.isBefore(DateTime.now())) {
      print('❌ Scheduled date is in the past: $dateStringFromUI');
      return;
    }

    // Convert to timezone-aware date
    final tzDateTime = tz.TZDateTime.from(parsedDate, tz.local);
    print('📅 Scheduling notification for: $tzDateTime');

    // Set repeat components
    DateTimeComponents? matchDateTimeComponents;
    if (repeat == 'Daily') {
      matchDateTimeComponents = DateTimeComponents.time;
      print('🔄 Setting repeat to Daily');
    } else if (repeat == 'Monthly') {
      matchDateTimeComponents = DateTimeComponents.dayOfMonthAndTime;
      print('🔄 Setting repeat to Monthly');
    } else {
      print('🔄 Setting repeat to Once');
    }

    // Schedule the notification
    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tzDateTime,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'reminder_channel',
          'Reminders',
          channelDescription: 'Reminder notifications',
          importance: Importance.max,
          priority: Priority.high,
          ticker: 'reminder',
          enableVibration: true,
          playSound: true,
          icon: '@mipmap/ic_launcher',
          showWhen: true,
        ),
      ),
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: matchDateTimeComponents,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );

    print('✅ Notification scheduled successfully with ID: $id');
  } catch (e) {
    print('❌ Error scheduling notification: $e');
  }
}