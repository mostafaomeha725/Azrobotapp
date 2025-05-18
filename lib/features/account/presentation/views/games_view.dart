import 'package:azrobot/core/utils/app_text_styles.dart';
import 'package:azrobot/features/account/presentation/widgets/Games_view_body.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class GamesView extends StatelessWidget {
  const GamesView({super.key});

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
              Text(
                'Games',
                style: TextStyles.bold20w600.copyWith(color: Color(0xFF0062CC)),
              ),
            ],
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: GamesViewBody(),
    );
  }
}
