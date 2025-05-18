import 'package:azrobot/core/utils/app_images.dart';
import 'package:azrobot/core/utils/app_text_styles.dart';
import 'package:azrobot/features/home/presentation/views/widgets/news_feed_view_body.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NewsFeedView extends StatelessWidget {
  const NewsFeedView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: 40, // الحجم الذي تريده
            width: 40, // الحجم الذي تريده
            decoration: BoxDecoration(
              color: Color(0xFF0062CC), // اللون الأزرق
              borderRadius: BorderRadius.circular(10), // تحديد الحواف الدائرية
            ),
            child: IconButton(
              icon: Icon(
                Icons.chevron_left_sharp, // أيقونة العودة
                color: Colors.white, // لون الأيقونة الأبيض
                size: 24, // حجم الأيقونة
              ),
              onPressed: () {
                GoRouter.of(context).pop();
              },
            ),
          ),
        ),
        title: Padding(
          padding: const EdgeInsets.only(right: 50),
          child: Row(
            mainAxisAlignment:
                MainAxisAlignment.center, // لجعل النص والشعار في الوسط
            children: [
              Image.asset(Assets.assetsazrobotlogoonly, height: 32),
              SizedBox(width: 8),
              Text(
                'News Feed',
                style: TextStyles.bold20w600.copyWith(color: Color(0xFF0062CC)),
              ),
            ],
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: NewsFeedViewBody(),
    );
  }
}