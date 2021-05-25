import 'package:flutter/material.dart';
import 'package:just_bottom_sheet/just_bottom_sheet.dart';

import 'widgets/background.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

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
  const JustBottomSheetExample({Key? key}) : super(key: key);

  @override
  _JustBottomSheetExampleState createState() => _JustBottomSheetExampleState();
}

class _JustBottomSheetExampleState extends State<JustBottomSheetExample> {
  final controller = JustBottomSheetController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          const Background(),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: JustBottomSheet.custom(
              panelDecoration: const BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                color: Colors.white,
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: Colors.black26,
                    spreadRadius: 1,
                    blurRadius: 10,
                  )
                ],
              ),
              minHeight: 200,
              maxHeight: 600,
              snapPoints: const [0, 0.5, 1],
              onSnap: _onSnap,
              controller: controller,
              borderRadius: BorderRadius.circular(16),
              builder: (context, scrollController) {
                return ListView(
                  controller: scrollController,
                  children: [
                    for (int i = 0; i < 100; i++)
                      Container(
                        width: 100,
                        height: 100,
                        margin: const EdgeInsets.all(16),
                        color: Colors.green,
                      ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _onSnap(int snapPointIndex) {
    print(snapPointIndex);
  }
}
