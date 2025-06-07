import 'package:azrobot/core/utils/app_text_styles.dart';
import 'package:azrobot/core/widgets/can_pop_widgets.dart';
import 'package:azrobot/features/account/presentation/widgets/privacy_police_view_body.dart';
import 'package:flutter/material.dart';

class PrivacyPoliceView extends StatelessWidget {
  const PrivacyPoliceView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      CanPopWidgets(). handleBackButton(context);
                },
              ),
            ),
          ),
            title: const Text("privacy policy",
             style: TextStyles.bold22w600,
            
            ),
            centerTitle: true,
          ),
      body: PrivacyPolicyViewBody(),
    );
  }
}