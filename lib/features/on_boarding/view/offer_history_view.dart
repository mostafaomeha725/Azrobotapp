import 'package:azrobot/core/api_services/api_service.dart';
import 'package:azrobot/core/app_router/app_router.dart';
import 'package:azrobot/core/utils/app_text_styles.dart';
import 'package:azrobot/features/home/presentation/manager/cubits/get_user_vouchers/cubit/getuservouchers_cubit.dart';
import 'package:azrobot/features/on_boarding/view/widgets/offer_history_view_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class OfferHistoryView extends StatelessWidget {
  const OfferHistoryView({super.key});

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
                if (context.canPop()) {
                  context.pop();
                } else {
                  context.go(
                    AppRouter.kBersistentBottomNavBarView,
                  ); // or wherever you want
                }
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
                'Offers History',
                style: TextStyles.bold20w600.copyWith(color: Color(0xFF0062CC)),
              ),
            ],
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: BlocProvider(
        create: (context) => GetUserVoucherCubit(
          ApiService(),
        ),
        child: OffersHistoryViewBody(),
      ),
    );
  }
}
