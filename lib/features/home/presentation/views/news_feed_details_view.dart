import 'package:azrobot/features/home/presentation/manager/cubits/get_user_point/cubit/getuserpoint_cubit.dart';
import 'package:azrobot/features/home/presentation/manager/cubits/post_view_specific_content/cubit/viewspecificcontent_cubit.dart';
import 'package:azrobot/features/home/presentation/views/widgets/Life_style_details_view_body.dart';
import 'package:azrobot/features/home/presentation/views/widgets/news_feed_details_view_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewsFeedDetailsView extends StatefulWidget {
  const NewsFeedDetailsView({super.key, required this.item});
  final Map<String, dynamic> item;

  @override
  State<NewsFeedDetailsView> createState() => _NewsFeedDetailsViewState();
}


class _NewsFeedDetailsViewState extends State<NewsFeedDetailsView> {


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<ViewspecificcontentCubit>().fetchContent(widget.item['id']);
  }
  @override
  Widget build(BuildContext context) {
    return BlocListener<ViewspecificcontentCubit, ViewspecificcontentState>(
      listener: (context, state)  async{
      if (state is ViewspecificcontentSuccess) {
          final prefs = await SharedPreferences.getInstance();

                  final userId = prefs.getString('userId');

            context.read<GetUserPointCubit>().getUserPoints(userId!);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Points Earned: ${state.content['points_earned']}'),),
        );
      }
      },
      child:    Scaffold(body: NewsFeedDetailsViewBody(item: widget.item)),
    );
  }
}
