import 'package:azrobot/features/home/presentation/manager/cubits/post_view_specific_content/cubit/viewspecificcontent_cubit.dart';
import 'package:azrobot/features/home/presentation/views/widgets/Life_style_details_view_body.dart';
import 'package:azrobot/features/home/presentation/views/widgets/medical_hub_details_view_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MedicalHubDetailsView extends StatefulWidget {
  const MedicalHubDetailsView({super.key, required this.item});
  final Map<String, dynamic> item;

  @override
  State<MedicalHubDetailsView> createState() => _MedicalHubDetailsViewState();
}


class _MedicalHubDetailsViewState extends State<MedicalHubDetailsView> {


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<ViewspecificcontentCubit>().fetchContent(widget.item['id']);
  }
  @override
  Widget build(BuildContext context) {
    return BlocListener<ViewspecificcontentCubit, ViewspecificcontentState>(
      listener: (context, state) {
      if (state is ViewspecificcontentSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Points Earned: ${state.content['points_earned']}'),),
        );
      }
      },
      child:    Scaffold(body: MedicalHubDetailsViewBody(item: widget.item)),
    );
  }
}
