import 'package:flutter/material.dart';

class FlowerProgressIndicator extends StatelessWidget {
  final double size;
  final Color backgroundColor;
  final String imagePath;

  const FlowerProgressIndicator({
    Key? key,
    this.size = 50.0,
    this.backgroundColor = Colors.transparent,
    required this.imagePath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(size / 2),
        image: DecorationImage(
          image: AssetImage(imagePath,package: 'flower_app'),
          fit: BoxFit.fitWidth,
        )
      ),
    );
  }
}