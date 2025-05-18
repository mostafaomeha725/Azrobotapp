import 'package:azrobot/core/utils/app_text_styles.dart';
import 'package:azrobot/features/account/presentation/widgets/active_offer_history.dart';
import 'package:azrobot/features/account/presentation/widgets/expired_offer_history.dart';
import 'package:azrobot/features/account/presentation/widgets/used_offer_history.dart';

import 'package:flutter/material.dart';

class OffersHistoryViewBody extends StatefulWidget {
  const OffersHistoryViewBody({super.key});

  @override
  State<OffersHistoryViewBody> createState() => _OffersHistoryViewBodyState();
}

class _OffersHistoryViewBodyState extends State<OffersHistoryViewBody>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // TabBar داخل body
        Container(
          color: Colors.white,
          child: TabBar(
            controller: _tabController,
            labelColor: const Color(0xff134FA2),
            labelStyle: TextStyles.bold14w500,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.blue,
            tabs: const [
              Tab(text: "Active"),
              Tab(text: "Used"),
          
            ],
          ),
        ),

        // TabBarView
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              ActiveOfferHistory(),

              UsedOfferHistory(),
         
            ],
          ),
        ),
      ],
    );
  }
}

// Placeholder widgets for Appointment screens
