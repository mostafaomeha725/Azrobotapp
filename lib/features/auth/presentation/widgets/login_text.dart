import 'package:flutter/material.dart';

class LoginText extends StatelessWidget {
  const LoginText({
    super.key,
    required this.text,
    required this.textClick,
    this.onTap,
  });
  final String text;
  final String textClick;
  final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          text,
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey,
            decoration: TextDecoration.underline,
            decorationColor: Colors.grey,
          ),
        ),
        // SizedBox(height: 8),
        GestureDetector(
          onTap: onTap,
          child: Text(
            textClick,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.underline,
              decorationColor: Colors.grey,
            ),
          ),
        ),
      ],
    );
  }
}
