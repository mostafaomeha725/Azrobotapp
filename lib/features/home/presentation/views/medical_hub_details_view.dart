import 'package:azrobot/features/home/presentation/manager/cubits/get_user_point/cubit/getuserpoint_cubit.dart';
import 'package:azrobot/features/home/presentation/manager/cubits/post_view_specific_content/cubit/viewspecificcontent_cubit.dart';
import 'package:azrobot/features/home/presentation/views/widgets/medical_hub_details_view_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MedicalHubDetailsView extends StatefulWidget {
  const MedicalHubDetailsView({super.key, required this.item});
  final Map<String, dynamic> item;

  @override
  State<MedicalHubDetailsView> createState() => _MedicalHubDetailsViewState();
}


class _MedicalHubDetailsViewState extends State<MedicalHubDetailsView> {


  @override
  void initState() {
    super.initState();
    context.read<ViewspecificcontentCubit>().fetchContent(widget.item['id']);
  }
  @override
  Widget build(BuildContext context) {
    return BlocListener<ViewspecificcontentCubit, ViewspecificcontentState>(
      listener: (context, state)  async{
    if (state is ViewspecificcontentSuccess)  {
        final prefs = await SharedPreferences.getInstance();

                  final userId = prefs.getString('userId');

            context.read<GetUserPointCubit>().getUserPoints(userId!);
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Points Earned: ${state.content['points_earned']}')),
  );

  final pointsEarned = double.tryParse(state.content['points_earned'].toString()) ?? 0;

  double current = double.tryParse(prefs.getString("point") ?? "0") ?? 0;
  double updated = current + pointsEarned;
   await prefs.setString("point", updated.toString());
   maxPoints = prefs.getString('point');

  
}

      },
      child:    Scaffold(body: MedicalHubDetailsViewBody(item: widget.item)),
    );
  }
}

String? maxPoints;
