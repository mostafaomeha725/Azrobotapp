import 'package:azrobot/core/utils/app_images.dart';
import 'package:azrobot/core/utils/app_text_styles.dart';
import 'package:azrobot/features/account/presentation/views/account_view.dart';
import 'package:azrobot/features/home/presentation/views/azrobot_view.dart';
import 'package:azrobot/features/home/presentation/views/home_view.dart';
import 'package:azrobot/features/home/presentation/views/reminders_view.dart';
import 'package:azrobot/features/home/presentation/views/videos_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart'; // Import the persistent_bottom_nav_bar package
 
class BersistentBottomNavBarView extends StatefulWidget {
  const BersistentBottomNavBarView({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _BersistentBottomNavBarViewState createState() =>
      _BersistentBottomNavBarViewState();
}

class _BersistentBottomNavBarViewState
    extends State<BersistentBottomNavBarView> {
  int _selectedIndex = 0; // This will store the selected tab index

  final PersistentTabController controller = PersistentTabController(
    initialIndex: 0,
  );

  List<Widget> _buildScreens() {
    return [
      const HomeView(),
      const RemindersView(),
      const AzrobotView(),
      const VideosView(),
      const AccountView(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: SvgPicture.asset(
            _selectedIndex == 0
                ? Assets.assetsHomecolor 
                : Assets.assetsHome, 
            // ignore: deprecated_member_use
            color: _selectedIndex == 0 ? Color(0xff134FA2) : Colors.grey,
          ),
        ),
        title: "Home",
        activeColorPrimary: Color(0xff134FA2),
        inactiveColorPrimary: Colors.grey,
        textStyle: TextStyles.bold13w400,
      ),
      PersistentBottomNavBarItem(
        icon: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: SvgPicture.asset(
            _selectedIndex == 1
                ? Assets.assetsNotificationcolor 
                : Assets.assetsNotification,
            // ignore: deprecated_member_use
            color: _selectedIndex == 1 ? Color(0xff134FA2) : Colors.grey,
          ),
        ),
        title: "Reminder",
        activeColorPrimary: Color(0xff134FA2),
        inactiveColorPrimary: Colors.grey,
        textStyle: TextStyles.bold13w400,
      ),
      PersistentBottomNavBarItem(
        icon: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _selectedIndex == 2
                ? Color(0xff134FA2)
                : Colors.white,
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              Assets.assetsazrobotlogoonly,
              color: _selectedIndex == 2 ? Colors.white : Color(0xff134FA2),
          
            ),
          ),
        ),
        activeColorPrimary: Colors.white,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: const Icon(Icons.play_circle_outline),
        ),
        title: ("Videos"),
        activeColorPrimary: Color(0xff134FA2),
        inactiveColorPrimary: Colors.grey,
        textStyle: TextStyles.bold13w400,
      ),
      PersistentBottomNavBarItem(
        icon: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: SvgPicture.asset(
            _selectedIndex == 4 ? Assets.assetsmore : Assets.assetsmorecolor,
           
          ),
        ),
        title: "More",
        textStyle: TextStyles.bold13w400,
        activeColorPrimary: Color(0xff134FA2),
        inactiveColorPrimary: Colors.grey,
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      controller: controller,
      screens: _buildScreens(),
      items: _navBarsItems(),
      navBarHeight: 70,
      padding: const EdgeInsets.symmetric(vertical: 3),
      backgroundColor: Colors.white,
      handleAndroidBackButtonPress: true,
      resizeToAvoidBottomInset: true,
      stateManagement: true,
      decoration: NavBarDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 10,
            spreadRadius: 5,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      navBarStyle: NavBarStyle.style15,
      onItemSelected: (index) {
        setState(() {
          _selectedIndex = index;
        });
      },
    );
  }
}
