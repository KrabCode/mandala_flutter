import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      home: DrawableCanvas(),
    );
  }
}

// stateful widget that allows drawing paths on a custom canvas
class DrawableCanvas extends StatefulWidget {
  const DrawableCanvas({super.key});

  @override
  State<DrawableCanvas> createState() => _DrawingCanvasState();
}

class _DrawingCanvasState extends State<DrawableCanvas> {
  List<Line> paths = <Line>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Drawable Canvas'),
        ),
        body: GestureDetector(
          onTapUp: (details) => setState(() {
            paths.add(Line()
              ..add(details.localPosition)
              ..add(details.localPosition));
          }),
          onPanStart: (details) => setState(() {
            paths.add(Line());
          }),
          onPanUpdate: (details) {
            setState(() {
              getLastPath().add(details.localPosition);
            });
          },
          onPanEnd: (details) => setState(() {}),
          child: CustomPaint(
            // pass the gesture detector listenable to child DrawableCanvasPainter
            painter: DrawableCanvasPainter(paths: paths),

            size: Size.infinite,
            child: Container(),
          ),
        ));
  }

  getLastPath() {
    if (paths.isEmpty) {
      paths.add(Line());
    }
    return paths[paths.length - 1];
  }
}

class DrawableCanvasPainter extends CustomPainter {
  DrawableCanvasPainter({required this.paths});

  final List<Line> paths;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.translate(size.width / 2, size.height / 2);
    for (Line line in paths) {
      for (int i = 0; i < line.points.length - 1; i++) {
        final pathPaint = Paint()
          ..color = const Color.fromARGB(50, 255, 255, 255)
          ..strokeCap = StrokeCap.round
          ..strokeWidth = 5.0
          ..style = PaintingStyle.stroke;
        for (int rot = 0; rot < 8; rot++) {
          canvas.save();
          canvas.rotate(2 * 3.14 * rot / 8);
          canvas.translate(size.width / -2, size.height / -2);
          canvas.drawLine(
              line.points[i].offset, line.points[i + 1].offset, pathPaint);
          canvas.restore();
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class Line {
  final List<LinePoint> _points = [];

  void add(Offset offset) {
    points.add(LinePoint(offset: offset));
  }

  List<LinePoint> get points => _points;
}

class LinePoint {
  Offset offset;

  LinePoint({required this.offset});
}
