import 'package:flutter/material.dart';
import '../theme/colors.dart' as custom_colors;

class AccessCameraFab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      width: 70,
      child: FloatingActionButton(
        backgroundColor: custom_colors.navbarBackground,
        onPressed: () {
          Navigator.of(context).pushNamed('/main-camera-screen');
        },
        child: Icon(
          Icons.add_rounded,
          size: 40,
          color: Colors.white,
        ),
      ),
    );
  }
}
