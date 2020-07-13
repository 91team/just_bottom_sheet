import 'package:flutter/material.dart';
import 'package:just_bottom_sheet/just_bottom_sheet.dart';

import 'widgets/background.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Just Bottom Sheet Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const JustBottomSheetExample(),
    );
  }
}

class JustBottomSheetExample extends StatefulWidget {
  const JustBottomSheetExample({Key key}) : super(key: key);

  @override
  _JustBottomSheetExampleState createState() => _JustBottomSheetExampleState();
}

class _JustBottomSheetExampleState extends State<JustBottomSheetExample> {
  JustBottomSheetController controller;

  @override
  void initState() {
    controller = JustBottomSheetController();

    Future.delayed(const Duration(seconds: 3), () {
      // controller.snapTo(2);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          const Background(),
          JustBottomSheet.singleChild(
            minHeight: 200,
            maxHeight: 600,
            anchors: const [0, 0.5, 1],
            onSnap: _onSnap,
            controller: controller,
            child: Column(
              children: <Widget>[
                Container(
                  width: 100,
                  height: 100,
                  margin: const EdgeInsets.all(16),
                  color: const Color(0xFFFF0000),
                ),
                Container(
                  width: 100,
                  height: 100,
                  margin: const EdgeInsets.all(16),
                  color: const Color(0xFFFF0000),
                ),
                Container(
                  width: 100,
                  height: 100,
                  margin: const EdgeInsets.all(16),
                  color: const Color(0xFFFF0000),
                ),
                Container(
                  width: 100,
                  height: 100,
                  margin: const EdgeInsets.all(16),
                  color: const Color(0xFFFF0000),
                ),
                Container(
                  width: 100,
                  height: 100,
                  margin: const EdgeInsets.all(16),
                  color: const Color(0xFFFF0000),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  void _onSnap(int snapPointIndex) {
    print(snapPointIndex);
  }
}
