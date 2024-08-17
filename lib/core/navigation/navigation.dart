import 'package:flutter/material.dart';
import 'package:reclaim/core/models/app_user.dart';
import 'package:reclaim/core/navigation/accesss_camera_fab.dart';
import '../../features/dashboard/presentation/screens/dashboard_screen.dart';
import '../widgets/custom_app_bar.dart';
import '../theme/colors.dart' as custom_colors;
import 'package:firebase_auth/firebase_auth.dart';



class Navigation extends StatefulWidget {
  final AppUser user;
  Navigation({required this.user});

  @override
  State<Navigation> createState() => NavigationState();
}

class NavigationState extends State<Navigation> {
  static GlobalKey<NavigationState> globalKey =
      GlobalKey<NavigationState>();
  int currentIndex = 0;

  late List<Widget> screens;

  @override
  void initState() {
    super.initState();
    // Initialize the screens list with the user parameter
    screens = [DashboardScreen(user: widget.user )];
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
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
            // setState(() {
            //   currentIndex = newIndex;
            // });
          },
          items: [
            BottomNavigationBarItem(
                label: '',
                icon: Icon(
                  Icons.bar_chart_rounded,
                  color: currentIndex == 0
                      ? custom_colors.accentGreen
                      : Colors.white.withOpacity(0.5),
                  size: 28,
                )),
            BottomNavigationBarItem(
                label: '',
                icon: Icon(Icons.diversity_1_rounded,
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
