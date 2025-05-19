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
    return PopScope(
      canPop: false, 
      // ignore: deprecated_member_use
      onPopInvoked: (didPop) async {
        if (!didPop) {
         
          _handleBackButton(context);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                color: const Color(0xFF0062CC),
                borderRadius: BorderRadius.circular(10),
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.chevron_left_sharp,
                  color: Colors.white,
                  size: 24,
                ),
                onPressed: () {
                  _handleBackButton(context);
                },
              ),
            ),
          ),
          title: Padding(
            padding: const EdgeInsets.only(right: 50),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Offers History',
                  style: TextStyles.bold20w600.copyWith(color: const Color(0xFF0062CC)),
                ),
              ],
            ),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: BlocProvider(
          create: (context) => GetUserVoucherCubit(ApiService()),
          child: const OffersHistoryViewBody(),
        ),
      ),
    );
  }

  void _handleBackButton(BuildContext context) {
    if (context.canPop()) {
      context.pop();
    } else {
      context.pushReplacement(AppRouter.kBersistentBottomNavBarView);
    }
  }
}