import 'package:azrobot/core/utils/app_images.dart';
import 'package:azrobot/core/utils/app_text_styles.dart';
import 'package:azrobot/features/home/presentation/views/widgets/video_view_body.dart';
import 'package:flutter/material.dart';

class VideosView extends StatelessWidget {
  const VideosView({super.key});

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
              color: Color(0xFF0062CC), 
              borderRadius: BorderRadius.circular(10), 
            ),
            child: IconButton(
              icon: Icon(
                Icons.chevron_left_sharp, 
                color: Colors.white,
                size: 24,
              ),
              onPressed: () {
              
              },
            ),
          ),
        ),
        title: Padding(
          padding: const EdgeInsets.only(right: 50),
          child: Row(
            mainAxisAlignment:
                MainAxisAlignment.center, 
            children: [
              Image.asset(Assets.assetsazrobotlogoonly, height: 32),
              SizedBox(width: 8),
              Text(
                'Videos',
                style: TextStyles.bold20w600.copyWith(color: Color(0xFF0062CC)),
              ),
            ],
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),

      body: VideoViewBody(),
    );
  }
}
