import 'package:flutter/material.dart';
import '../theme/colors.dart' as custom_colors;

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      titleSpacing: 20,
      backgroundColor: custom_colors.primaryBackground,
      elevation: 0,
      title: Row(
        children: [
          Container(
            width: 30,
            child: Image.asset(
              'assets/images/logo-transparent.png',
              fit: BoxFit.fitWidth,
            ),
          ),
          const SizedBox(
            width: 12,
          ),
          const Text(
            'ReClaim',
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white),
          ),
        ],
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 20.0),
          child: GestureDetector(
            child: const Icon(
              Icons.open_in_new_rounded,
              color: Colors.white,
            ),
            onTap: () {},
          ),
        )
      ],
    );
  }
}
