import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';
import 'dart:async';

import './shimmer.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  AnimationController _animationController;
  Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 750),
    );

    _animation =
        Tween<double>(begin: 0.2, end: 1.0).animate(_animationController);

    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    Timer(
        Duration(milliseconds: 751),
        () => Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => Splashscreen())));
    return Container(
      child: ScaleTransition(
        scale: _animation,
        child: Container(
          height: 100,
          width: 100,
          color: Colors.amber,
        ),
      ),
    );
  }
}
