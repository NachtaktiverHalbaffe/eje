import 'package:eje/widgets/costum_icons_icons.dart';
import 'package:eje/widgets/pages/settings/einstellungen.dart';
import 'package:eje/widgets/pages/eje/eje.dart';
import 'package:eje/widgets/pages/camps/camps.dart';
import 'package:eje/widgets/pages/news/news_page.dart';
import 'package:eje/widgets/pages/events/events.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';

class EjePersistentNavBar extends StatelessWidget {
  final int initialIndex;
  const EjePersistentNavBar({super.key, this.initialIndex = 0});

  // List of Widgetscreens for navigation bart
  List<Widget> _buildScreens() {
    return [NewsPage(), Eje(), Events(), Camps(), Einstellungen()];
  }

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      resizeToAvoidBottomInset: false,
      controller: PersistentTabController(initialIndex: initialIndex),
      items: [
        PersistentBottomNavBarItem(
          icon: Icon(MdiIcons.newspaper),
          iconSize: 26.0,
          title: ("Aktuelles"),
          activeColorPrimary: Theme.of(context).colorScheme.secondary,
          activeColorSecondary: Colors.white,
          inactiveColorPrimary: Theme.of(context).colorScheme.secondary,
        ),
        PersistentBottomNavBarItem(
          icon: Icon(CostumIcons.eje),
          iconSize: 26.0,
          title: ("Das eje"),
          activeColorPrimary: Theme.of(context).colorScheme.secondary,
          activeColorSecondary: Colors.white,
          inactiveColorPrimary: Theme.of(context).colorScheme.secondary,
        ),
        PersistentBottomNavBarItem(
          icon: Icon(Icons.today),
          iconSize: 26.0,
          title: ("Events"),
          activeColorPrimary: Theme.of(context).colorScheme.secondary,
          activeColorSecondary: Colors.white,
          inactiveColorPrimary: Theme.of(context).colorScheme.secondary,
        ),
        PersistentBottomNavBarItem(
          icon: Icon(MdiIcons.terrain),
          iconSize: 26.0,
          title: ("Freizeiten"),
          activeColorPrimary: Theme.of(context).colorScheme.secondary,
          activeColorSecondary: Colors.white,
          inactiveColorPrimary: Theme.of(context).colorScheme.secondary,
        ),
        PersistentBottomNavBarItem(
          icon: Icon(Icons.settings),
          iconSize: 26.0,
          title: ("Einstellungen"),
          activeColorPrimary: Theme.of(context).colorScheme.secondary,
          activeColorSecondary: Colors.white,
          inactiveColorPrimary: Theme.of(context).colorScheme.secondary,
        ),
      ],
      screens: _buildScreens(),
      handleAndroidBackButtonPress: true,
      stateManagement: true,
      backgroundColor: Theme.of(context).colorScheme.background,
      navBarStyle: NavBarStyle
          .style7, //!Good looking alternatives: sytle3, style6, style7, style 15
      itemAnimationProperties: ItemAnimationProperties(
        duration: Duration(milliseconds: 400),
        curve: Curves.ease,
      ),
      screenTransitionAnimation: ScreenTransitionAnimation(
        animateTabTransition: true,
        curve: Curves.ease,
        duration: Duration(milliseconds: 200),
      ),
      decoration: NavBarDecoration(
        boxShadow: GetStorage().read("nightmode_off") == true ||
                (GetStorage().read("nightmode_auto") == true &&
                    MediaQuery.of(context).platformBrightness ==
                        Brightness.light)
            ? [
                BoxShadow(
                  color: Colors.black,
                  blurRadius: 10,
                  spreadRadius: 0,
                ),
              ]
            : [],
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10), topRight: Radius.circular(10)),
        colorBehindNavBar: Theme.of(context).colorScheme.background,
      ),
      popAllScreensOnTapOfSelectedTab: true,
      // Choose the nav bar style with this property
      onItemSelected: (index) {},
    );
  }
}
