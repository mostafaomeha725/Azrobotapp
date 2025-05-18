import 'package:azrobot/core/utils/app_images.dart';
import 'package:azrobot/core/utils/app_text_styles.dart';
import 'package:azrobot/core/widgets/Custom_buttom.dart';

import 'package:flutter/material.dart';

class ShowSuccessSheet {
  static void showSuccessDialog(
    BuildContext context,
    String message, {
    required VoidCallback onPressed,
    required String buttonText,
    String? text,
     bool isvoucher = true ,
  }) {
    showDialog(
      context: context,
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Dialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(36.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.blue.shade100,
                    ),
                    child: Image.asset(Assets.assetsSuccessful),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Success',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    message,
                    textAlign: TextAlign.center,
                    style: TextStyles.bold16w500.copyWith(
                      color: Colors.grey[700],
                    ),
                  ),
                  SizedBox(height: 20),
               isvoucher?   Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: CustomButtom(text:text?? 'Login', onPressed: onPressed),
                  ):SizedBox(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }



  
}
