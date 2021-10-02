import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

class BackgroundAnimation extends StatelessWidget {
  const BackgroundAnimation(
      {Key? key, this.backgroundColor = Colors.indigo, required this.child})
      : super(key: key);

  final Color backgroundColor;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constrain) {
        return Stack(
          children: [
            Container(
              color: backgroundColor.withOpacity(0.8),
            ),
            ItemMoving(
              size: Size(constrain.maxWidth, constrain.maxHeight),
              color: Color((Random().nextDouble() * 0xFFFFFF).toInt())
                  .withOpacity(1.0),
            ),
            ItemMoving(
              size: Size(constrain.maxWidth, constrain.maxHeight),
              color: Color((Random().nextDouble() * 0xFFFFFF).toInt())
                  .withOpacity(1.0),
            ),
            ItemMoving(
              size: Size(constrain.maxWidth, constrain.maxHeight),
            ),
            ItemMoving(
              size: Size(constrain.maxWidth, constrain.maxHeight),
              color: Color((Random().nextDouble() * 0xFFFFFF).toInt())
                  .withOpacity(1.0),
            ),
            ItemMoving(
              size: Size(constrain.maxWidth, constrain.maxHeight),
              color: Color((Random().nextDouble() * 0xFFFFFF).toInt())
                  .withOpacity(1.0),
            ),
            ItemMoving(
              size: Size(constrain.maxWidth, constrain.maxHeight),
              color: Color((Random().nextDouble() * 0xFFFFFF).toInt())
                  .withOpacity(1.0),
            ),
            ItemMoving(
              size: Size(constrain.maxWidth, constrain.maxHeight),
              color: Color((Random().nextDouble() * 0xFFFFFF).toInt())
                  .withOpacity(1.0),
            ),
            ItemMoving(
              size: Size(constrain.maxWidth, constrain.maxHeight),
              color: Color((Random().nextDouble() * 0xFFFFFF).toInt())
                  .withOpacity(1.0),
            ),
            ItemMoving(
              size: Size(constrain.maxWidth, constrain.maxHeight),
            ),
            Center(
              child: child,
            ),
          ],
        );
      },
    );
  }
}

class ItemMoving extends StatefulWidget {
  ItemMoving(
      {Key? key,
      required this.size,
      this.color = Colors.purple,
      this.listColors})
      : super(key: key);

  final Size size;
  final Color color;
  final List<Color>? listColors;

  @override
  _ItemMovingState createState() => _ItemMovingState();
}

class _ItemMovingState extends State<ItemMoving> with TickerProviderStateMixin {
  late AnimationController _controllerX;
  late AnimationController _controllerY;

  final _widthItem = 100.0;
  final _heightItem = 100.0;

  late var limiter = 0;
  final isLimit = false;

  @override
  void initState() {
    super.initState();
    _controllerX = AnimationController.unbounded(vsync: this);
    _controllerY = AnimationController.unbounded(vsync: this);
    // // should start random
    _controllerX.value = 0;
    _controllerY.value = 0;

    onCompleteBoth(widget.size, isFirstRun: true);

    _controllerX.addListener(() {
      onCompleteBoth(widget.size);
    });

    _controllerY.addListener(() {
      onCompleteBoth(widget.size);
    });
  }

  @override
  void didUpdateWidget(covariant ItemMoving oldWidget) {
    super.didUpdateWidget(oldWidget);
    print('didUpdateWidget');

    limiter = 0;
    onCompleteBoth(widget.size, isFirstRun: true);
  }

  @override
  void dispose() {
    _controllerX.dispose();
    _controllerY.dispose();
    super.dispose();
  }

  int randomNumber(int max) {
    return Random().nextInt(max);
  }

  Offset _lastPoint = Offset(0, 0);
  Offset _targetPoint = Offset(0, 0);
  final speed = 150.0; // 5 ps per second

  void onCompleteBoth(Size size, {bool isFirstRun = false}) {
    if (isLimit && limiter > 10) return;
    if (isFirstRun || _controllerX.isCompleted && _controllerY.isCompleted) {
      limiter++;
      // store lastX
      _lastPoint = Offset(_targetPoint.dx, _targetPoint.dy);

      // update targetX
      _targetPoint = Offset(randomNumber(size.width.toInt()).toDouble(),
          randomNumber(size.height.toInt()).toDouble());

      final seconDuration = (_targetPoint - _lastPoint).distance / speed;
      // debugPrint(
      // 'seconDuration: ${seconDuration}, _targetPoint: ${_targetPoint.dx},${_targetPoint.dy}, size: ${size.width},${size.height}');
      _controllerX.animateTo(_targetPoint.dx,
          duration: Duration(milliseconds: (seconDuration * 1000).toInt()));

      _controllerY.animateTo(_targetPoint.dy,
          duration: Duration(milliseconds: (seconDuration * 1000).toInt()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_controllerX, _controllerY]),
      builder: (context, child) {
        return Positioned(
          top: _controllerY.value,
          left: _controllerX.value,
          width: _widthItem,
          height: _heightItem,
          child: CustomPaint(
            painter: CircleBlurPainter(
                blurSigma: 20,
                color: widget.color,
                listColors: widget.listColors),
          ),
        );
      },
    );
  }
}

class CircleBlurPainter extends CustomPainter {
  CircleBlurPainter(
      {required this.blurSigma, this.color = Colors.purple, this.listColors});

  double blurSigma;
  Color color;
  List<Color>? listColors;

  @override
  void paint(Canvas canvas, Size size) {
    Offset center = Offset(size.width / 2, size.height / 2);
    double radius = min(size.width / 2, size.height / 2);
    var rect = Offset.zero & size;
    Paint line = Paint()
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = radius * 2
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, blurSigma);

    listColors != null
        ? line.shader = LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
                Colors.blue[900] ?? Colors.white,
                Colors.blue[500] ?? Colors.white,
              ]).createShader(rect)
        : line.color = color;

    canvas.drawCircle(center, radius, line);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
