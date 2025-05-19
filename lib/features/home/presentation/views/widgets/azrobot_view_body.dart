import 'package:azrobot/core/utils/app_text_styles.dart';
import 'package:azrobot/features/account/presentation/widgets/active_offer_history.dart';
import 'package:azrobot/features/home/presentation/views/widgets/safeare_home.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AzrobotViewBody extends StatefulWidget {
  const AzrobotViewBody({super.key});

  @override
  State<AzrobotViewBody> createState() => _AzrobotViewBodyState();
}

class _AzrobotViewBodyState extends State<AzrobotViewBody> {

  String? point;
    // ignore: must_call_super, annotate_overrides
    initState() {
     _loadpoint();
    }
 Future<void> _loadpoint() async {
  final prefs = await SharedPreferences.getInstance();
  final storedPoint = prefs.getString('point');

  setState(() {
    point = storedPoint ;
  });
}
  @override
  Widget build(BuildContext context) {
  
 

    final size = MediaQuery.of(context).size;
    final double headerHeight = size.height * 0.35; 

    return SingleChildScrollView(
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                height: headerHeight,
                decoration: const BoxDecoration(
                  color: Color(0xFF0062CC),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.circular(20),
                  ),
                ),
              ),
               SafeareHome(isPlaying: true,),
            ],
          ),
          Text(
            "Offers",
            style: TextStyles.bold18w600,
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: size.height * 0.5, 
            child: ActiveOfferHistory(),
          ),
        ],
      ),
    );
  }
}
