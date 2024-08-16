import 'package:flutter/material.dart';
import '../theme/colors.dart' as custom_colors;

class AccessCameraFab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      width: 64,
      child: FloatingActionButton(
        backgroundColor: custom_colors.navbarBackground,
        onPressed: () {
          Navigator.of(context).pushNamed('/main-camera-screen');
        },
        child: Icon(
          Icons.camera_alt_rounded,
          size: 32,
          color: Colors.white,
        ),
      ),
    );
  }
}
