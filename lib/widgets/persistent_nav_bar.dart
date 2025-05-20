import 'package:eje/widgets/costum_icons_icons.dart';
import 'package:eje/widgets/pages/settings/einstellungen.dart';
import 'package:eje/widgets/pages/eje/eje.dart';
import 'package:eje/widgets/pages/camps/camps.dart';
import 'package:eje/widgets/pages/news/news_page.dart';
import 'package:eje/widgets/pages/events/events.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';

class EjePersistentNavBar extends StatelessWidget {
  final int initialIndex;
  const EjePersistentNavBar({super.key, this.initialIndex = 0});

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      resizeToAvoidBottomInset: false,
      controller: PersistentTabController(initialIndex: initialIndex),
      tabs: [
        PersistentTabConfig(
          screen: NewsPage(),
          item: ItemConfig(
            icon: Icon(MdiIcons.newspaper),
            iconSize: 26.0,
            title: ("Aktuelles"),
            activeForegroundColor: Colors.white,
            activeColorSecondary: Theme.of(context).colorScheme.primary,
            inactiveForegroundColor: Theme.of(context).colorScheme.secondary,
          ),
        ),
        PersistentTabConfig(
            screen: Eje(),
            item: ItemConfig(
              icon: Icon(CostumIcons.eje),
              iconSize: 26.0,
              title: ("Das eje"),
              activeForegroundColor: Colors.white,
              activeColorSecondary: Theme.of(context).colorScheme.primary,
              inactiveForegroundColor: Theme.of(context).colorScheme.secondary,
            )),
        PersistentTabConfig(
            screen: Events(),
            item: ItemConfig(
              icon: Icon(Icons.today),
              iconSize: 26.0,
              title: ("Events"),
              activeForegroundColor: Colors.white,
              activeColorSecondary: Theme.of(context).colorScheme.primary,
              inactiveForegroundColor: Theme.of(context).colorScheme.secondary,
            )),
        PersistentTabConfig(
            screen: Camps(),
            item: ItemConfig(
              icon: Icon(MdiIcons.terrain),
              iconSize: 26.0,
              title: ("Freizeiten"),
              activeForegroundColor: Colors.white,
              activeColorSecondary: Theme.of(context).colorScheme.primary,
              inactiveForegroundColor: Theme.of(context).colorScheme.secondary,
            )),
        PersistentTabConfig(
            screen: Einstellungen(),
            item: ItemConfig(
              icon: Icon(Icons.settings),
              iconSize: 26.0,
              title: ("Einstellungen"),
              activeForegroundColor: Colors.white,
              activeColorSecondary: Theme.of(context).colorScheme.primary,
              inactiveForegroundColor: Theme.of(context).colorScheme.secondary,
            )),
      ],
      handleAndroidBackButtonPress: true,
      stateManagement: true,
      //!Good looking alternatives: sytle3, style6, style7, style 15
      navBarBuilder: (navbarConfig) => Style2BottomNavBar(
        navBarConfig: navbarConfig,
        itemAnimationProperties: ItemAnimation(
          duration: Duration(milliseconds: 400),
          curve: Curves.ease,
        ),
        navBarDecoration: NavBarDecoration(
          color: Theme.of(context).colorScheme.background,
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
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      screenTransitionAnimation: ScreenTransitionAnimation(
        curve: Curves.ease,
        duration: Duration(milliseconds: 200),
      ),
    );
  }
}
