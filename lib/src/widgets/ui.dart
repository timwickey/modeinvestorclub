import 'package:flutter/material.dart';

import '../data/globals.dart';

class SquaredButton extends StatelessWidget {
  final String text;
  final Icon icon;
  final VoidCallback? onPressed;
  final double maxHeight;
  final double maxWidth;
  final Map<String, Color> color;

  const SquaredButton({
    super.key,
    required this.text,
    required this.icon,
    required this.onPressed,
    this.maxHeight = 60.0,
    this.maxWidth = 200.0,
    this.color = colorButton,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: maxHeight,
        maxWidth: maxWidth,
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color['leftColor']!, color['rightColor']!],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(maxHeight / 6),
          border: Border.all(
              color: color['borderColor']!,
              width: buttonBorderThickness), // Add border color
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onPressed,
            borderRadius: BorderRadius.circular(maxHeight / 6),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Text(
                      text,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8), // Space between text and icon
                  icon,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class RoundedButton extends StatelessWidget {
  final String text;
  final Icon icon;
  final VoidCallback? onPressed;
  final double maxHeight;
  final double maxWidth;
  final Map<String, Color> color;

  const RoundedButton({
    super.key,
    required this.text,
    required this.icon,
    required this.onPressed,
    this.maxHeight = 40.0,
    this.maxWidth = 200.0,
    this.color = colorButton,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: maxHeight,
        maxWidth: maxWidth,
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color['leftColor']!, color['rightColor']!],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(maxHeight / 2),
          border: Border.all(
              color: color['borderColor']!,
              width: buttonBorderThickness), // Add border color
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onPressed,
            borderRadius: BorderRadius.circular(maxHeight / 2),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Text(
                      text,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8), // Space between text and icon
                  icon,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
