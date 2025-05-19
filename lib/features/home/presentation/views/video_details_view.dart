import 'package:azrobot/features/home/presentation/manager/cubits/get_user_point/cubit/getuserpoint_cubit.dart';
import 'package:azrobot/features/home/presentation/manager/cubits/post_view_specific_content/cubit/viewspecificcontent_cubit.dart';

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
    super.initState();
    context.read<ViewspecificcontentCubit>().fetchContent(widget.item['id']);
  }
  @override
  Widget build(BuildContext context) {
    return BlocListener<ViewspecificcontentCubit, ViewspecificcontentState>(
    listener: (context, state) async {
      if (state is ViewspecificcontentSuccess) {
            final prefs = await SharedPreferences.getInstance();

                  final userId = prefs.getString('userId');

            context.read<GetUserPointCubit>().getUserPoints(userId!);
        final pointsEarned = state.content['points_earned'] ?? 0;

       

        final currentPointsStr = prefs.getString("point") ?? "0";
        final currentPoints = int.tryParse(currentPointsStr) ?? 0;

        final updatedPoints = currentPoints + pointsEarned;

        await prefs.setString("point", updatedPoints.toString());


        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Points Earned: $pointsEarned')),
        );

        setState(() {});
      }
    },
      child:    Scaffold(body: VideoDetailsViewBody(item: widget.item)),
    );
  }
}
