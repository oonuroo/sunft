import 'package:flutter/material.dart';

class AnimatedGradient extends StatefulWidget {
  const AnimatedGradient({Key? key}) : super(key: key);

  @override
  AnimatedGradientState createState() => AnimatedGradientState();
}

class AnimatedGradientState extends State<AnimatedGradient> {
  List<Color> colorList = [
    Colors.cyan.shade900,
    Colors.deepPurple.shade900,
    Colors.pink.shade900,
  ];
  List<Alignment> alignmentList = [
    Alignment.bottomLeft,
    Alignment.bottomRight,
    Alignment.topRight,
    Alignment.topLeft,
  ];
  int index = 0;
  Color bottomColor = Colors.pink.shade900;
  Color topColor = Colors.cyan.shade900;
  Alignment begin = Alignment.bottomLeft;
  Alignment end = Alignment.topRight;

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(milliseconds: 10), () {
      setState(() {
        bottomColor = Colors.deepPurple.shade900;
      });
    });
    return Scaffold(
        body: Stack(
          children: [
            AnimatedContainer(
              duration: const Duration(seconds: 5),
              onEnd: () {
                setState(() {
                  index = index + 1;
                  // animate the color
                  bottomColor = colorList[index % colorList.length];
                  topColor = colorList[(index + 1) % colorList.length];

                  //// animate the alignment
                  // begin = alignmentList[index % alignmentList.length];
                  // end = alignmentList[(index + 2) % alignmentList.length];
                });
              },
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: begin, end: end, colors: [bottomColor, topColor])),
            ),
          ],
        ));
  }
}
