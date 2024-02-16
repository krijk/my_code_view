import 'dart:math';

import 'package:flutter/material.dart';
import 'package:my_code_view/my_code_view.dart';

void main() {
  runApp(const MyApp());
}

/// ! Ensure the files in [fileList] are included in pubspec.yaml
/// In this example the codeViewer will display this file's code
/// by pointing to the main.dart file
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final Color? colorTabWidget = Theme.of(context).primaryTextTheme.labelLarge!.color;
    return MaterialApp(
      theme: ThemeData.dark(),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Example1'),
        ),
        body: WidgetWithCodeView(
          filePath: 'lib/main.dart',
          // iconBackgroundColor: Colors.white,
          iconBackgroundColor: Colors.transparent,
          // iconForegroundColor: Colors.pink,
          // labelBackgroundColor: Theme.of(context).canvasColor.withOpacity(0.4),
          labelBackgroundColor: Colors.grey.withOpacity(0.4),
          labelTextStyle: TextStyle(color: Theme.of(context).textTheme.bodyLarge!.color),
          showLabelText: true,
          shareCode: true,
          overlayColor: Colors.transparent,
          overlayOpacity: 0.2,
          // headerWidget: Text('Header'),
          tabIconColor: colorTabWidget,
          tabTextStyle: TextStyle(color: colorTabWidget),
          child: const SomeWidget(),
        ),
      ),
    );
  }
}

class SomeWidget extends StatelessWidget {
  const SomeWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Stack(
    children: [
      Center(
        child: Transform.rotate(
          angle: Random().nextDouble(),
          child: const Text(
            'Example',
            textScaler: TextScaler.linear(2),
          ),
        ),
      ),
      Wrap(
        children: List.generate(
          100,
              (_) => SizedBox(
            width: MediaQuery.of(context).size.width * .25,
            height: MediaQuery.of(context).size.width * .25,
            child: Placeholder(
              color: Colors.accents[Random().nextInt(
                Colors.accents.length,
              )],
            ),
          ),
        ),
      ),
    ],
  );
}
