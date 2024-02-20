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
    Color? colorTabWidget = Theme.of(context).primaryTextTheme.labelLarge!.color;
    return MaterialApp(
      theme: ThemeData.dark(),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Example2'),
        ),
        body: WidgetWithCodeView2(
          fileList: const [
            'lib/main.dart',
            'assets/code/native/my_native_ad02.xml',
            'assets/code/native/NativeAdFactoryExample.java',
            'assets/code/native/NativeAdFactoryExample.java',
            'assets/code/source05.dart',
            'assets/code/source06.dart',
            'assets/code/source07.dart',
            'assets/code/source08.dart',
            'assets/code/source09.dart',
          ],

          // In case to show on a web browser
          // codeLinkPrefix: 'https://raw.githubusercontent.com/flutter/flutter/master/examples/hello_world',

          // In case to show text code contents
          // codeContent: 'code content',

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
