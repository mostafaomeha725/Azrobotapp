import 'package:flutter/material.dart';

class TermsConditionViewBody extends StatefulWidget {
  const TermsConditionViewBody({super.key});

  @override
  _TermsConditionViewBodyState createState() => _TermsConditionViewBodyState();
}

class _TermsConditionViewBodyState extends State<TermsConditionViewBody> {
  bool _isAccepted = false;

  void _onContinue() {
    if (_isAccepted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Terms accepted. Proceeding...')),
      );
      // TODO: Navigate to the next screen or perform further logic
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please accept the terms and conditions.')),
      );
    }
  }

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
Welcome to our app!

Please read these Terms and Conditions ("Terms", "Terms and Conditions") carefully before using our application.

1. **Acceptance**  
By accessing or using the app, you agree to be bound by these Terms.

2. **Privacy Policy**  
We are committed to protecting your privacy. Please review our Privacy Policy to understand how we collect, use, and safeguard your information.

3. **User Conduct**  
You agree not to misuse the services or access unauthorized parts of the system.

4. **Modifications**  
We reserve the right to modify these terms at any time. Continued use of the app indicates acceptance of the updated terms.

By accepting, you confirm that you have read, understood, and agreed to all of the terms above.
                  ''',
                  style: const TextStyle(fontSize: 16, height: 1.5),
                ),
              ),
            ),
            const SizedBox(height: 12),
          
          ],
        ),
      ),
    );
  }
}
