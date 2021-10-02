import 'dart:math';

import 'package:background_animation/Animations/background_animation.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Background Animation - Day 4'),
          elevation: 0,
        ),
        body: BackgroundAnimation(
          child: const Text(
            'Hello Flutter Dev',
            style: TextStyle(
                fontSize: 32, fontWeight: FontWeight.w600, color: Colors.white),
          ),
          backgroundColor: Color((Random().nextDouble() * 0xFFFFFF).toInt())
              .withOpacity(1.0),
        ),
      ),
    );
  }
}
