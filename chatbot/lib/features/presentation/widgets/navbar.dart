import 'package:chatbot/features/presentation/screens/home.dart';
import 'package:chatbot/features/presentation/screens/profile.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

class MyNavBar extends StatelessWidget {
  const MyNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    List<PersistentBottomNavBarItem> _navBarItems() {
      return [
        PersistentBottomNavBarItem(
          icon: const Icon(Icons.home),
          title: "Home",
          activeColorPrimary: Colors.blue,
          inactiveColorPrimary: theme.colorScheme.primary, 
        ),
        PersistentBottomNavBarItem(
          icon: const Icon(Icons.person),
          title: "Profile",
          activeColorPrimary: Colors.blue,
          inactiveColorPrimary: theme.colorScheme.primary, 
        ),
      ];
    }

    List<Widget> _screens() {
      return [const Home(), const Profile()];
    }

    return PersistentTabView(
      context,
      controller: PersistentTabController(initialIndex: 0),
      screens: _screens(),
      items: _navBarItems(),
      navBarStyle: NavBarStyle.style1, 
      backgroundColor: theme.colorScheme.tertiary,
      decoration: NavBarDecoration(
        borderRadius: BorderRadius.circular(10.0),
      ),
      navBarHeight: 60,
    );
  }
}