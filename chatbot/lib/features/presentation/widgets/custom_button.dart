import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  const CustomButton({super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity, // Ensure it expands to the available width
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: theme.primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
            side: BorderSide(
              color: theme.colorScheme.onPrimary.withOpacity(
                0.2,
              ), // light border
              width: 1.5,
            ),
          ),
          minimumSize: const Size(double.infinity, 70),
        ),

        child: Text(
          text,
          style: TextStyle(
            fontSize: theme.textTheme.labelLarge!.fontSize,
            color: theme.textTheme.bodyLarge!.color,
          ),
        ),
      ),
    );
  }
}
