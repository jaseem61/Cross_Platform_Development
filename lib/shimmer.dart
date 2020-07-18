import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'dart:async';
import './homescreen.dart';

class Splashscreen extends StatefulWidget {
  @override
  _SplashscreenState createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Timer(
        Duration(milliseconds: 2750),
        () => Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => Homescreen())));
    return Container(
      color: Colors.amber,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Shimmer.fromColors(
              child: (Container(
                child: Image.asset(
                    'image/Pngtreenatural_hills_and_mountains_4103445.png'),
              )),
              baseColor: Colors.amber,
              highlightColor: Colors.cyan[50]),
        ],
      ),
    );
  }
}
