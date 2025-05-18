import 'package:azrobot/core/app_router/app_router.dart';
import 'package:azrobot/core/utils/app_images.dart';
import 'package:azrobot/features/auth/presentation/manager/cubits/reminder_cubit/cubit/reminder_cubit.dart';
import 'package:azrobot/features/home/presentation/manager/cubits/get_content_category/getcontentcategory_cubit.dart';
import 'package:azrobot/features/home/presentation/views/widgets/appbar_text_widget.dart';
import 'package:azrobot/features/home/presentation/views/widgets/card_today_tips.dart';
import 'package:azrobot/features/home/presentation/views/widgets/hard_card_home.dart';
import 'package:azrobot/features/home/presentation/views/widgets/horizontal_list_view.dart';
import 'package:azrobot/features/home/presentation/views/widgets/reminder_card_widget.dart';
import 'package:azrobot/features/home/presentation/views/widgets/upwidget_home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeViewBody extends StatefulWidget {
  const HomeViewBody({super.key});

  @override
  State<HomeViewBody> createState() => HomeViewBodyState();
}
class HomeViewBodyState extends State<HomeViewBody> {
  String? userId;
  String? point;

  @override
  void initState() {
    super.initState();
    context.read<GetContentByCategoryCubit>().getContentByCategory(5);
    _loadUserIdAndReminders();
  }

  Future<void> _loadUserIdAndReminders() async {
    final prefs = await SharedPreferences.getInstance();
    final fetchedUserId = prefs.getString("userId");
    final fetchedPoint = prefs.getString("point");

    if (mounted) {
      setState(() {
        userId = fetchedUserId;
        point = fetchedPoint;
      });
    }

    if (fetchedUserId != null) {
      context.read<ReminderCubit>().loadReminders(fetchedUserId);
    } else {
      debugPrint("userId not found");
    }
  }

  Future<void> loadPoint() async {
    final prefs = await SharedPreferences.getInstance();
    final newPoint = prefs.getString("point");
    if (mounted) {
      setState(() {
        point = newPoint;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
         SliverToBoxAdapter(child: UpwidgetHome(point: point??"0",)),
        const SliverToBoxAdapter(child: CardTodayTips()),
        SliverToBoxAdapter(
          child: SizedBox(
            child: BlocBuilder<GetContentByCategoryCubit,
                GetContentByCategoryState>(
              builder: (context, state) {
                if (state is GetContentByCategoryLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is GetContentByCategoryFailure) {
                  return Center(child: Text('Error: ${state.errMessage}'));
                } else if (state is GetContentByCategorySuccess) {
                  final contents =
                      state.data['contents']['contents'] as List<dynamic>;
                  return HorizontalListView(
                    contents: contents,
                    iscard: true,
                    onTap: () {
                      GoRouter.of(context).push(AppRouter.kNewsFeed,
                        
                      );
                    },
                  );
                }

                return const SizedBox(); // Default return for initial state
              },
            ),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 12)),
        SliverToBoxAdapter(
          child: AppbarTextWidget(
            text: "Reminders",
            onTap: () {
              GoRouter.of(context).go(AppRouter.kRemindersView);
            },
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 12)),
       SliverToBoxAdapter(
  child: Padding(
    padding: const EdgeInsets.symmetric(horizontal: 32),
    child: BlocBuilder<ReminderCubit, ReminderState>(
      builder: (context, state) {
        if (state is ReminderLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is ReminderFailure) {
          return Center(child: Text('Error: ${state.message}'));
        } else if (state is ReminderSuccess) {
          final reminders = state.reminders.reversed.toList(); // عرض الأحدث أولاً
          if (reminders.isEmpty) {
            return const Center(child: Text('No reminders yet.'));
          }

          // عرض أول تذكير فقط كمثال
          final reminder = reminders.first;

          return ReminderCardWidget(
            title: reminder.reminderText,
            repeat: reminder.repeat,
            dateTime: reminder.dateTime,
            index: 0,  userId: userId??"0",
            ishome: false,
          );
        } else {
          return const Center(child: Text('Unexpected state.'));
        }
      },
    ),
  ),
),

        const SliverToBoxAdapter(child: SizedBox(height: 24)),  
        SliverToBoxAdapter(
          child: AppbarTextWidget(
            text: "Promote your clinic",
            onTap: () {
              GoRouter.of(context).push(AppRouter.kPromoteClinicView);
            },
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 12)),
        SliverToBoxAdapter(
          child: HardCardHome(
            image: Assets.assetspromoteClinic,
            text: 'promote Your Clinic',
            onTap: () {
              GoRouter.of(context).push(AppRouter.kPromoteClinicView);
            },
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 12)),
        SliverToBoxAdapter(
          child: AppbarTextWidget(
            text: "medical Hub",
            onTap: () {
              GoRouter.of(context).push(AppRouter.kMedicalHubView);
            },
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 12)),
        SliverToBoxAdapter(
          child: HardCardHome(
            image: Assets.assetshub,
            text: 'medical Hub',
            onTap: () {
              GoRouter.of(context).push(AppRouter.kMedicalHubView);
            },
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 12)),
        SliverToBoxAdapter(
          child: AppbarTextWidget(
            text: "Life Style",
            onTap: () {
              GoRouter.of(context).push(AppRouter.kLifeStyleView);
            },
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 12)),
        SliverToBoxAdapter(
          child: HardCardHome(
            image: Assets.assetslifestyle,
            text: 'Life Style',
            onTap: () {
              GoRouter.of(context).push(AppRouter.kLifeStyleView);
            },
          ),
        ),
          const SliverToBoxAdapter(child: SizedBox(height: 12)),
          
        SliverToBoxAdapter(
          child: AppbarTextWidget(
            text: "Games",
            onTap: () {
              GoRouter.of(context).push(AppRouter.kGamesView);
            },
          ),
        ),
          const SliverToBoxAdapter(child: SizedBox(height: 12)),
        SliverToBoxAdapter(
          child: HardCardHome(
            image: Assets.assetsgames,
            text: 'Games',
            onTap: () {
              GoRouter.of(context).push(AppRouter.kGamesView);
            },
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 40)),
      ],
    );
  }
}
