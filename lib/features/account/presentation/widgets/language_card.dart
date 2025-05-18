import 'package:azrobot/core/utils/app_text_styles.dart';
import 'package:flutter/material.dart';

class LanguageCard extends StatefulWidget {
  const LanguageCard({super.key});

  @override
  _LanguageCardState createState() => _LanguageCardState();
}

class _LanguageCardState extends State<LanguageCard> {
  // Variable to track selected language
  String? selectedLanguage = 'English';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 1,

        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(height: 16),
              // Language label with icon
              Row(
                children: [
                  Icon(Icons.language, size: 20, color: Color(0xff134FA2)),
                  SizedBox(width: 10),
                  Text(
                    'Language:',
                    style: TextStyles.bold14w400.copyWith(color: Colors.grey),
                  ),
                ],
              ),
              SizedBox(height: 8),
              // Arabic Language Option
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'العربية',
                      style: TextStyles.bold14w400.copyWith(color: Colors.grey),
                    ),
                    Radio<String>(
                      activeColor: Color(0xff134FA2),
                      value: 'العربية',
                      groupValue: selectedLanguage,
                      onChanged: (value) {
                        setState(() {
                          selectedLanguage = value;
                        });
                      },
                    ),
                  ],
                ),
              ),

              // English Language Option
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'English',
                      style: TextStyles.bold14w400.copyWith(color: Colors.grey),
                    ),
                    Radio<String>(
                      value: 'English',
                      activeColor: Color(0xff134FA2),
                      groupValue: selectedLanguage,
                      onChanged: (value) {
                        setState(() {
                          selectedLanguage = value;
                        });
                      },
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
