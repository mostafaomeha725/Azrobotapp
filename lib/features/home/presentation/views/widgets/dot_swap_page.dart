import 'package:flutter/material.dart';

class DotSwapPage extends StatelessWidget {
  const DotSwapPage({
    super.key,
    required this.imageslength,
    required this.currentPage,
  });

  final int imageslength;
  final int currentPage;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(imageslength, (index) {
        return AnimatedContainer(
          duration: Duration(milliseconds: 200),
          margin: EdgeInsets.symmetric(horizontal: 5),
          height: 10,
          width: 10,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: currentPage == index ? Colors.blue : Colors.grey,
          ),
        );
      }),
    );
  }
}
