import 'package:azrobot/core/utils/app_text_styles.dart';
import 'package:azrobot/features/home/presentation/manager/cubits/get_user_vouchers/cubit/getuservouchers_cubit.dart';
import 'package:azrobot/features/on_boarding/view/widgets/line_border_painter.dart';
import 'package:azrobot/features/on_boarding/view/widgets/score_point_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UsedOfferHistory extends StatefulWidget {
  const UsedOfferHistory({super.key});

  @override
  State<UsedOfferHistory> createState() => _UsedOfferHistoryState();
}

class _UsedOfferHistoryState extends State<UsedOfferHistory> {
  @override
  void initState() {
    super.initState();
    // Replace '4' with your actual user ID from Auth or global state
_loadUserIdAndFetchVouchers();
  }
  Future<void> _loadUserIdAndFetchVouchers() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString("userId");

    if (userId != null) {
      // ignore: use_build_context_synchronously
      context.read<GetUserVoucherCubit>().getUserVouchers(userId);
    } else {
      // التعامل مع حالة عدم وجود userId
      debugPrint("User ID not found in SharedPreferences");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
      child: LayoutBuilder(
        builder: (context, constraints) {
          double aspectRatio = constraints.maxWidth > 600 ? 0.65 : 0.8;
          return BlocBuilder<GetUserVoucherCubit, GetUserVoucherState>(
            builder: (context, state) {
              if (state is GetUserVoucherLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is GetUserVoucherFailure) {
                return Center(child: Text(state.errMessage));
              } else if (state is GetUserVoucherSuccess) {
                final offers = state.vouchers;

                return GridView.builder(
                  itemCount: offers.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: aspectRatio,
                  ),
                  itemBuilder: (context, index) {
                    final offer = offers[index];
                    return Card(
                      color: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: CustomPaint(
                        painter: DashedBorderPainter(),
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  ScorePointWidgets(point: offer['points'] ?? '0'),
                                  const Spacer(),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Center(
                                child: Image.network(
                                  offer ['logo'] ?? '',
                                  height: constraints.maxWidth > 600 ? 70 : 50,
                                  errorBuilder: (context, error, stackTrace) => const Icon(Icons.image_not_supported),
                                ),
                              ),
                              Text(
                                offer["name"] ?? '',
                                style: TextStyles.bold16w600.copyWith(color: Colors.black),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 12),
                                child: Text(
                                  offer["description"] ?? '',
                                  style: TextStyles.bold12w400.copyWith(color: Colors.grey),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              }
              return const SizedBox.shrink();
            },
          );
        },
      ),
    );
  }
}
