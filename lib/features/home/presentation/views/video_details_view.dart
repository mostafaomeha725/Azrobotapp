import 'package:azrobot/features/home/presentation/manager/cubits/post_view_specific_content/cubit/viewspecificcontent_cubit.dart';
import 'package:azrobot/features/home/presentation/views/widgets/Life_style_details_view_body.dart';
import 'package:azrobot/features/home/presentation/views/widgets/home_view_body.dart';
import 'package:azrobot/features/home/presentation/views/widgets/medical_hub_details_view_body.dart';
import 'package:azrobot/features/home/presentation/views/widgets/video_details_view_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VideoDetailsView extends StatefulWidget {
  const VideoDetailsView({super.key, required this.item});
  final Map<String, dynamic> item;

  @override
  State<VideoDetailsView> createState() => _VideoDetailsViewState();
}


class _VideoDetailsViewState extends State<VideoDetailsView> {


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<ViewspecificcontentCubit>().fetchContent(widget.item['id']);
  }
  @override
  Widget build(BuildContext context) {
    return BlocListener<ViewspecificcontentCubit, ViewspecificcontentState>(
    listener: (context, state) async {
      if (state is ViewspecificcontentSuccess) {
        final pointsEarned = state.content['points_earned'] ?? 0;

        // الوصول إلى SharedPreferences
        final prefs = await SharedPreferences.getInstance();

        // قراءة النقاط الحالية
        final currentPointsStr = prefs.getString("point") ?? "0";
        final currentPoints = int.tryParse(currentPointsStr) ?? 0;

        // جمع النقاط
        final updatedPoints = currentPoints + pointsEarned;

        // حفظ النقاط الجديدة
        await prefs.setString("point", updatedPoints.toString());
final homeState = context.findAncestorStateOfType<HomeViewBodyState>();
homeState?.loadPoint();
        // عرض SnackBar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Points Earned: $pointsEarned')),
        );

        // (اختياري) إذا كان عندك متغير في الواجهة يعرض النقاط، يمكنك عمل setState هنا
        setState(() {});
      }
    },
      child:    Scaffold(body: VideoDetailsViewBody(item: widget.item)),
    );
  }
}
