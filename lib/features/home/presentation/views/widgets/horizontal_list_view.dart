import 'package:azrobot/features/home/presentation/views/widgets/card_home.dart';
import 'package:azrobot/features/home/presentation/views/widgets/dot_swap_page.dart';
import 'package:flutter/material.dart';

class HorizontalListView extends StatefulWidget {
  const HorizontalListView({
    super.key,
    required this.contents,
    this.iscard = false,
    this.onTap,
  });

  final List<dynamic> contents;
  final bool iscard;
  final void Function()? onTap;

  @override
  State<HorizontalListView> createState() => _HorizontalListViewState();
}

class _HorizontalListViewState extends State<HorizontalListView> {
  late final PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController()
      ..addListener(() {
        int newPage = _pageController.page?.round() ?? 0;
        if (newPage != _currentPage) {
          setState(() {
            _currentPage = newPage;
          });
        }
      });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 200,
          child: PageView.builder(
            controller: _pageController,
            itemCount: widget.contents.length,
            itemBuilder: (context, index) {
              final item = widget.contents[index];
              return CardHome(
                numtop: 80,
                image: item['image_url'] ?? '',
                title: item['title'] ?? '',
                discription: item['description'] ?? '',
                onTap: widget.onTap,
              );
            },
          ),
        ),
        const SizedBox(height: 10),
        widget.iscard
            ? DotSwapPage(
                imageslength: widget.contents.length,
                currentPage: _currentPage,
              )
            : const SizedBox(),
      ],
    );
  }
}
