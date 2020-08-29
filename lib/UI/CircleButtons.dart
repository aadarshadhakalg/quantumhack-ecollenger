import 'package:flutter/material.dart';

class CircleButtons extends StatelessWidget {
  final Function onTap;
  final IconData icon;
  final Color iconColor;

  CircleButtons({this.icon, this.iconColor, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.green, width: 2.0),
        borderRadius: BorderRadius.circular(100),
      ),
      child: IconButton(
          icon: Icon(
            icon,
            color: iconColor,
          ),
          onPressed: onTap),
    );
  }
}
