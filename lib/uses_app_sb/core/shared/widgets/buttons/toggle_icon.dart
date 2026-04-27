import 'package:flutter/material.dart';

class ToggleIcon extends StatelessWidget {
  const ToggleIcon({
    Key? key,
    required this.value,
    required this.onPressed,
    required this.onIcon,
    required this.offIcon,
  }) : super(key: key);

  final bool value;
  final Function() onPressed;
  final Widget onIcon;
  final Widget offIcon;

  @override
  Widget build(BuildContext context) => Material(
        type: MaterialType
            .transparency, // or MaterialType.canvas for the default background

        child: IconButton(
          onPressed: onPressed,
          icon: value ? onIcon : offIcon,
        ),
      );
}

class ToggleIconWithouIconButton extends StatelessWidget {
  const ToggleIconWithouIconButton({
    Key? key,
    required this.value,
    required this.onPressed,
    required this.onIcon,
    required this.offIcon,
  }) : super(key: key);

  final bool value;
  final Function() onPressed;
  final Widget onIcon;
  final Widget offIcon;

  @override
  Widget build(BuildContext context) => Material(
        type: MaterialType
            .transparency, // or MaterialType.canvas for the default background

        child: GestureDetector(
          onTap: onPressed,
          child: value ? onIcon : offIcon,
        ),
      );
}
