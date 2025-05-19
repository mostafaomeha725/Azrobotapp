import 'package:azrobot/core/utils/app_images.dart';
import 'package:azrobot/core/utils/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

class MedicalHubDetailsViewBody extends StatelessWidget {
  const MedicalHubDetailsViewBody({super.key, required this.item});

  final Map<String, dynamic> item;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                child: Image.network(
                  item['image_url'] ?? Assets.assetshub,
                  width: double.infinity,
                  height: 220,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Image.asset(
                    Assets.assetshub,
                    width: double.infinity,
                    height: 220,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
             Positioned(
  top: 0,
  bottom: 0,
  left: 0,
  right: 0,
  child: Center(
    child: GestureDetector(
      onTap: () async {
       final youtubeUrl = item['video'];

  if (youtubeUrl == null || youtubeUrl.isEmpty) {
    debugPrint('Video URL is empty or null');
    return;
  }

  final uri = Uri.parse(youtubeUrl);

  try {
    final launched = await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    );

    if (!launched) {
      debugPrint('Could not launch $youtubeUrl');
    }
  } catch (e) {
    debugPrint('Error launching URL: $e');
  }
      },
      child: const Icon(
        Icons.play_circle_fill,
        color: Colors.white,
        size: 50,
      ),
    ),
  ),
),

              Positioned(
                top: 20,
                left: 16,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 4.0, vertical: 16),
                  child: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.chevron_left_sharp,
                          color: Colors.black, size: 24),
                      onPressed: () => GoRouter.of(context).pop(),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 20,
                right: 16,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 4.0, vertical: 16),
                  child: Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Image.asset(
                        Assets.assetsazrobotlogoonly,
                        height: 30,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(32),
                topRight: Radius.circular(32),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  const SizedBox(height: 24),
                  Align(
                    alignment: Alignment.topRight,
                    child: Text('Date: ${item['date'] ?? item['updated_at']}',
                        style:
                            TextStyles.bold12w500.copyWith(color: Colors.grey)),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(item['title'] ?? 'No title available',
                        style: TextStyles.bold24w600),
                  ),
                  const SizedBox(height: 8),
                  Column(
                    children: [
                      Text(
                        item['source'] != null ? 'Source: ${item['source']}' : '',
                        style:
                            TextStyles.bold13w400.copyWith(color: Colors.grey),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                        item['description'] ?? 'No description available',
                        style: TextStyles.bold16w400),
                  ),
                  const SizedBox(height: 16),
                 
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
