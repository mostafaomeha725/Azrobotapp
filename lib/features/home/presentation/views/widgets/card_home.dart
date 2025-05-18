import 'package:azrobot/core/utils/app_images.dart';
import 'package:azrobot/core/utils/app_text_styles.dart';
import 'package:flutter/material.dart';

class CardHome extends StatelessWidget {
  const CardHome({
    super.key,
    required this.numtop,
    required this.image,
    this.onTap,
    required this.title,
    required this.discription,
  });

  final int numtop;
  final String image;
  final void Function()? onTap;
  final String title;
  final String discription;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: GestureDetector(
        onTap: onTap,
        child: Card(
          elevation: 5,
          margin: const EdgeInsets.symmetric(horizontal: 26),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            children: [
              // صورة الخلفية من الإنترنت مع لودينغ وصورة بديلة
              Positioned.fill(
                child: Image.network(
                  image,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return const Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    );
                  },
                  errorBuilder: (_, __, ___) => Image.asset(
                    Assets.assetshub,
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              // تدرج لوني لتحسين النص
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black.withOpacity(0.7),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),

              // الجزء العلوي - عنوان
           Positioned(
  left: 0,
  top: numtop.toDouble(),
  right: 0,
  child: Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center, // تغيير من start إلى center
      children: [
        Container(
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
          ),
          padding: const EdgeInsets.all(6.0),
          child: Image.asset(
            Assets.assetsazrobotlogoonly,
            height: 25,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Align( // إضافة Align لمحاذاة النص مع الصورة
            alignment: Alignment.centerLeft,
            child: Text(
              title,
              style: TextStyles.bold14w600.copyWith(color: Colors.white),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ],
    ),
  ),
),
              // الجزء السفلي - وصف وزر See More
              Positioned(
                bottom: 5,
                left: 20,
                right: 20,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        discription,
                        style: const TextStyle(fontSize: 10, color: Colors.white),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    TextButton(
                      onPressed: onTap,
                      child: const Text(
                        'See More',
                        style: TextStyle(color: Color(0xff40d4c9), fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
