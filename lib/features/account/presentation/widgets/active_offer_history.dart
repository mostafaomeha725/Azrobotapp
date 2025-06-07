import 'package:azrobot/core/utils/app_text_styles.dart';
import 'package:azrobot/core/widgets/show_success_sheet.dart';
import 'package:azrobot/features/account/presentation/widgets/custom_widget_buttom.dart';
import 'package:azrobot/features/home/presentation/manager/cubits/get_all_vouchers/cubit/get_voucher_cubits_cubit.dart';
import 'package:azrobot/features/home/presentation/manager/cubits/get_user_point/cubit/getuserpoint_cubit.dart';
import 'package:azrobot/features/home/presentation/manager/cubits/purchase_vouchers/cubit/purchase_vouchers_cubit.dart';
import 'package:azrobot/features/on_boarding/view/widgets/line_border_painter.dart';
import 'package:azrobot/features/on_boarding/view/widgets/score_point_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ActiveOfferHistory extends StatefulWidget {
  const ActiveOfferHistory({super.key});

  @override
  State<ActiveOfferHistory> createState() => _ActiveOfferHistoryState();
}

class _ActiveOfferHistoryState extends State<ActiveOfferHistory> {
  int? loadingVoucherId;

  @override
  void initState() {
    super.initState();
    context.read<GetVoucherCubit>().getAllVouchers();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 42.0,right: 16,left: 16
      ),
      child: MultiBlocListener(
        listeners: [
          BlocListener<GetVoucherCubit, GetVoucherState>(
            listener: (context, state) {
              if (state is GetVoucherFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.errMessage)),
                );
              }
            },
          ),
          BlocListener<PurchaseVouchersCubit, VoucherPurchaseState>(
            listener: (context, state)async {
              if (state is VoucherPurchaseSuccess) {
                final prefs = await SharedPreferences.getInstance();
      final remainingPoints = state.voucherData['remaining_points'];
      if (remainingPoints != null) {
        await prefs.setString('point', remainingPoints.toString());
      }
          final userId = prefs.getString('userId');

            context.read<GetUserPointCubit>().getUserPoints(userId!);

                ShowSuccessSheet.showSuccessDialog(
                  context,
                  "",
                  text: "Success",
                 // isvoucher: false,
                  onPressed: () {
                    GoRouter.of(context).pop();
                  },
                  buttonText: '',
                );
                
                context.read<GetVoucherCubit>().getAllVouchers();
                setState(() {
                  loadingVoucherId = null;
                });
              } else if (state is VoucherPurchaseFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message)),
                );
                setState(() {
                  loadingVoucherId = null;
                });
              }
            },
          ),
        ],
        child: BlocBuilder<GetVoucherCubit, GetVoucherState>(
          builder: (context, state) {
            if (state is GetVoucherLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is GetVoucherSuccess) {
              final vouchers = state.vouchers;
              final isLoading = state.isLoading;
              final error = state.error;

              if (vouchers.isEmpty) {
                return const Center(child: Text("There are no offers currently."));
              }

              return Stack(
                children: [
                  LayoutBuilder(
                    builder: (context, constraints) {
                      double aspectRatio = constraints.maxWidth > 600 ? 0.5 : 0.60;
                      return GridView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: vouchers.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: aspectRatio,
                        ),
                        itemBuilder: (context, index) {
                          final offer = vouchers[index];
                          final isButtonLoading = loadingVoucherId == offer["voucher_id"];

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
                                        ScorePointWidgets(point: offer["voucher_points"] ?? 0),
                                        const Spacer(),
                                      ],
                                    ),
                                    const Spacer(),
                                    Center(
                                      child: Image.network(
                                        offer["voucher_logo"] ?? "",
                                        height: constraints.maxWidth > 600 ? 70 : 50,
                                        errorBuilder: (_, __, ___) => const Icon(Icons.image),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      offer["voucher_name"] ?? "",
                                      style: TextStyles.bold16w600.copyWith(color: Colors.black),
                                      textAlign: TextAlign.center,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 12),
                                      child: Text(
                                        offer["voucher_description"] ?? "",
                                        style: TextStyles.bold12w400.copyWith(color: Colors.grey),
                                        textAlign: TextAlign.center,
                                        maxLines: 3,
                                      ),
                                    ),
                                    const Spacer(),

                                    CustomWidgetButtom(
                                      text: isButtonLoading ? "Loading..." : "Get Offer",
                                      onTap: () {
                                        final voucherId = offer['voucher_id'];
                                        if (voucherId != null && !isButtonLoading) {
                                          setState(() {
                                            loadingVoucherId = voucherId;
                                          });
                                          context.read<PurchaseVouchersCubit>().purchaseVoucher(voucherId);
                                        }
                                      },
                                    ),
                                    const SizedBox(height: 6),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                  if (isLoading)
                    const Positioned.fill(
                      child: ColoredBox(
                        color: Colors.black12,
                        child: Center(child: CircularProgressIndicator()),
                      ),
                    ),
                  if (error != null)
                    Positioned(
                      bottom: 16,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.red.shade100,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            error,
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),
                      ),
                    ),
                ],
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
