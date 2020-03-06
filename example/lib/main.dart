import 'package:flutter/material.dart';
import 'package:just_bottom_sheet/just_bottom_sheet.dart';

import 'widgets/background.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Just Bottom Sheet Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: JustBottomSheetExample(),
    );
  }
}

class JustBottomSheetExample extends StatefulWidget {
  JustBottomSheetExample({Key key}) : super(key: key);

  @override
  _JustBottomSheetExampleState createState() => _JustBottomSheetExampleState();
}

class _JustBottomSheetExampleState extends State<JustBottomSheetExample> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Background(),
          JustBottomSheet.singleChild(
            minHeight: 200,
            maxHeight: 600,
            anchors: [0, 0.5, 1],
            onSnap: _onSnap,
            child: Column(
              children: <Widget>[
                Container(
                  width: 100,
                  height: 100,
                  margin: EdgeInsets.all(16),
                  color: Color(0xFFFF0000),
                ),
                Container(
                  width: 100,
                  height: 100,
                  margin: EdgeInsets.all(16),
                  color: Color(0xFFFF0000),
                ),
                Container(
                  width: 100,
                  height: 100,
                  margin: EdgeInsets.all(16),
                  color: Color(0xFFFF0000),
                ),
                Container(
                  width: 100,
                  height: 100,
                  margin: EdgeInsets.all(16),
                  color: Color(0xFFFF0000),
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
