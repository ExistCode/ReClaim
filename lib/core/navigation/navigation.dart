import 'package:flutter/material.dart';
import 'package:reclaim/core/navigation/accesss_camera_fab.dart';
import '../../features/dashboard/presentation/screens/dashboard_screen.dart';
import '../widgets/custom_app_bar.dart';
import '../theme/colors.dart' as custom_colors;

class Navigation extends StatefulWidget {
  @override
  State<Navigation> createState() => NavigationState();
}

class NavigationState extends State<Navigation> {
  static GlobalKey<NavigationState> globalKey =
      new GlobalKey<NavigationState>();
  int currentIndex = 0;
  List<Widget> screens = [DashboardScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(56), child: CustomAppBar()),
      floatingActionButton: AccessCameraFab(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: screens[currentIndex],
      bottomNavigationBar: Container(
        height: 70,
        color: custom_colors.darkGray,
        child: BottomNavigationBar(
          key: globalKey,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          backgroundColor: custom_colors.navbarBackground,
          currentIndex: currentIndex,
          onTap: (int newIndex) {
            {
              setState(() {
                currentIndex = newIndex;
              });
            }
          },
          items: [
            BottomNavigationBarItem(
                label: '',
                icon: Icon(
                  Icons.home_rounded,
                  color: currentIndex == 0
                      ? custom_colors.accentGreen
                      : Colors.white.withOpacity(0.5),
                  size: 28,
                )),
            BottomNavigationBarItem(
                label: '',
                icon: Icon(Icons.bar_chart_rounded,
                    color: currentIndex == 1
                        ? custom_colors.accentGreen
                        : Colors.white.withOpacity(0.5),
                    size: 28)),
          ],
        ),
      ),
    );
  }
}
