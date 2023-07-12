import 'package:flutter/material.dart';

class MyyButton extends StatelessWidget {
  final String text;
  VoidCallback onPressed;
  MyyButton({
    super.key,
    required this.onPressed,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed,
      color: Theme.of(context).primaryColorDark,
      child: Text(text),
    );
  }
}
