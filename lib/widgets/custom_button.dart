import 'package:flutter/material.dart';

Widget customButton({
  required String title,
  required Color bgColor,
  required VoidCallback onTap,
  double height = 50,
  double width = 120,
}) {
  double br = 10;

  return Material(
    color: bgColor,
    borderRadius: BorderRadius.circular(br),
    child: InkWell(
      borderRadius: BorderRadius.circular(br),
      overlayColor: WidgetStatePropertyAll(Colors.white.withValues(alpha: 0.3)),
      // hoverColor: Colors.red,
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(br),
          // color: bgColor,
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: Colors.white.withValues(alpha: 0.9),
            ),
          ),
        ),
      ),
    ),
  );
}
