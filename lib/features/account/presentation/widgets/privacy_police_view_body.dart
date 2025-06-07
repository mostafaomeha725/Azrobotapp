import 'package:flutter/material.dart';

class PrivacyPolicyViewBody extends StatelessWidget {
  const PrivacyPolicyViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  '''
This Privacy Policy explains how we collect, use, disclose, and safeguard your information when you use our application.

**1. Information We Collect**  
We may collect personal information such as name, email address, usage data, and device information.

**2. Use of Information**  
We use your information to improve the user experience, provide support, and enhance app features.

**3. Sharing of Information**  
We do not share your personal data with third parties without your consent, except as required by law.

**4. Data Security**  
We implement security measures to protect your personal information from unauthorized access or disclosure.

**5. Your Rights**  
You can access, correct, or delete your personal data at any time by contacting support.

**6. Updates**  
We may update this policy from time to time. Continued use of the app constitutes acceptance of the updated policy.

If you have any questions about this Privacy Policy, feel free to contact us.
                  ''',
                  style: const TextStyle(fontSize: 16, height: 1.5),
                ),
              ),
            ),
            const SizedBox(height: 10),
            // Optional Agree Button (if needed)
            // SizedBox(
            //   width: double.infinity,
            //   child: ElevatedButton(
            //     onPressed: () {
            //       // Navigate or store agreement
            //     },
            //     child: const Text('Agree & Continue'),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
