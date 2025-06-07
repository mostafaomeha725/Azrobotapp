import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:intl/intl.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> initNotifications() async {
  // Initialize timezone data
  tz.initializeTimeZones();
  // Set the local timezone to Africa/Cairo
  tz.setLocalLocation(tz.getLocation('Africa/Cairo'));
  print('🔔 المنطقة الزمنية المحلية: ${tz.local.name}');

  // Android notification channel
  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'reminder_channel',
    'الإشعارات',
    description: 'إشعارات التذكير',
    importance: Importance.max,
    playSound: true,
    enableVibration: true,
  );

  // Create the notification channel
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  // Android initialization settings
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);

  // Initialize the plugin
  bool? initialized = await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: (NotificationResponse response) {
      print('🔔 تم استلام إشعار: ${response.payload}');
    },
  );
  print('🔔 تهيئة الإشعارات: ${initialized == true ? "نجحت" : "فشلت"}');

  // Request notification permissions for Android 13+
  final androidPlugin = flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
  bool? permissionGranted = await androidPlugin?.requestNotificationsPermission();
  print('🔔 إذن الإشعارات: ${permissionGranted == true ? "ممنوح" : "مرفوض"}');
}
Future<void> scheduleReminderNotification({
  required int id,
  required String title,
  required String body,
  required String dateStringFromUI,
  String repeat = 'Once', // إضافة معامل التكرار
}) async {
  try {
    // ✅ إلغاء أي إشعار سابق بنفس المعرف
    await flutterLocalNotificationsPlugin.cancel(id);
    
    final dateFormat = DateFormat('MM/dd/yyyy hh:mm a');
    final parsedDate = dateFormat.parse(dateStringFromUI);
    
    // ✅ التأكد من أن التاريخ في المستقبل
    if (parsedDate.isBefore(DateTime.now())) {
      print('❌ التاريخ المحدد في الماضي');
      return;
    }
    
    final tzDateTime = tz.TZDateTime.from(parsedDate, tz.local);
    
    print('📅 جدولة الإشعار للوقت: $tzDateTime');

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
          // ✅ إضافة خصائص مهمة للإشعارات
          ticker: 'reminder',
          enableVibration: true,
          playSound: true,
        ),
      ),
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      // ✅ إزالة matchDateTimeComponents للإشعارات غير المتكررة
      matchDateTimeComponents: repeat == 'Daily' ? DateTimeComponents.time : null,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
    
    print('✅ تم جدولة الإشعار بنجاح');
  } catch (e) {
    print('❌ خطأ في جدولة الإشعار: $e');
  }
}
