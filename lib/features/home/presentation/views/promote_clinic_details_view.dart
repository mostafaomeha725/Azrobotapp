import 'package:azrobot/features/home/presentation/manager/cubits/post_view_specific_content/cubit/viewspecificcontent_cubit.dart';
import 'package:azrobot/features/home/presentation/views/widgets/Life_style_details_view_body.dart';
import 'package:azrobot/features/home/presentation/views/widgets/medical_hub_details_view_body.dart';
import 'package:azrobot/features/home/presentation/views/widgets/promote_clinic_details_view_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PromoteClinicDetailsView extends StatefulWidget {
  const PromoteClinicDetailsView({super.key, required this.item});
  final Map<String, dynamic> item;

  @override
  State<PromoteClinicDetailsView> createState() => _PromoteClinicDetailsViewState();
}


class _PromoteClinicDetailsViewState extends State<PromoteClinicDetailsView> {


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
      child:    Scaffold(body: PromoteClinicDetailsViewBody(item: widget.item)),
    );
  }
}
