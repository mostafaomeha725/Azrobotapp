import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:intl/intl.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

int generateUniqueId() {
  return DateTime.now().millisecondsSinceEpoch % 1000000;
}

Future<void> initNotifications() async {
  try {
    // تهيئة المنطقة الزمنية
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Africa/Cairo'));
    print('🔔 المنطقة الزمنية: ${tz.local.name}');

    // إعداد قناة الإشعارات
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'reminder_channel',
      'Reminders',
      description: 'إشعارات التذكير',
      importance: Importance.max,
      playSound: true,
      enableVibration: true,
      enableLights: true,
      showBadge: true,
    );

    // إنشاء القناة
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    // إعدادات أندرويد
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    // تهيئة الإشعارات
    bool? initialized = await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        print('🔔 تم استلام الإشعار: ${response.payload}');
      },
    );
    print('🔔 تهيئة الإشعارات: ${initialized == true ? "نجحت" : "فشلت"}');

    // طلب إذن الإشعارات
    final androidPlugin = flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    bool? permissionGranted = await androidPlugin?.requestNotificationsPermission();
    print('🔔 إذن الإشعارات: ${permissionGranted == true ? "تم منحه" : "تم رفضه"}');
  } catch (e) {
    print('❌ خطأ في تهيئة الإشعارات: $e');
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
    // إلغاء الإشعار السابق بنفس المعرف
    await flutterLocalNotificationsPlugin.cancel(id);
    print('🔔 تم إلغاء الإشعار السابق بمعرف: $id');

    // تحليل التاريخ
    final dateFormat = DateFormat('MM/dd/yyyy hh:mm a');
    final parsedDate = dateFormat.parse(dateStringFromUI);

    // التأكد من أن التاريخ في المستقبل
    if (parsedDate.isBefore(DateTime.now())) {
      print('❌ التاريخ في الماضي: $dateStringFromUI');
      return;
    }

    // تحويل التاريخ إلى توقيت منطقة زمنية
    final tzDateTime = tz.TZDateTime.from(parsedDate, tz.local);
    print('📅 جدولة الإشعار لتاريخ: $tzDateTime مع المعرف: $id');

    // إعداد التكرار
    DateTimeComponents? matchDateTimeComponents;
    if (repeat == 'Daily') {
      matchDateTimeComponents = DateTimeComponents.time;
      print('🔄 التكرار: يومي');
    } else if (repeat == 'Monthly') {
      matchDateTimeComponents = DateTimeComponents.dayOfMonthAndTime;
      print('🔄 التكرار: شهري');
    } else {
      print('🔄 التكرار: مرة واحدة');
    }

    // إعدادات الإشعار
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'reminder_channel',
      'Reminders',
      channelDescription: 'إشعارات التذكير',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'reminder',
      enableVibration: true,
      playSound: true,
      enableLights: true,
      showWhen: true,
    );
    const NotificationDetails notificationDetails = NotificationDetails(android: androidDetails);

    // جدولة الإشعار
    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tzDateTime,
      notificationDetails,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: matchDateTimeComponents,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );

    print('✅ تم جدولة الإشعار بنجاح بمعرف: $id');
  } catch (e) {
    print('❌ خطأ في جدولة الإشعار: $e');
  }
}