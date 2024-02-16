<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages).
-->

TODO: Put a short description of the package here that helps potential users
know whether this package might be useful for them.

## my_code_view

A widget with side-by-side **Multi** source code view.
Inspired by [widget_with_codeview](https://pub.dev/packages/widget_with_codeview)
and [flutter-catalog](https://github.com/X-Wei/flutter_catalog/) open-source app.

![overview](https://github.com/krijk/my_code_view/assets/73879645/348ec395-bee0-4cfc-a16c-7d4bb9077056)

## Getting started

TODO: List prerequisites and provide or point to information on how to
start using the package.


## Usage

First make sure to add the source file to the app's assets by editing `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  my_code_view:
flutter:
  assets:
    # Include a single source code file:
    - lib/my_awesome_source_code.dart
    # Include all files under a subfoler by adding trailing "/":
    - lib/my_awesome_source_code_subdir/
    # Include all files under the assets folder
    - assets/code/
    - ...
```

Then wrap the widget from that source file by a `WidgetWithCodeView`:

```dart
WidgetWithCodeView(
  child: MyAwesomeWidget(), // ⚡️ If null, will only show the source code view.
  filePath: 'lib/my_awesome_source_code.dart',
  /// [codeLinkPrefix] is optional. When it's specified, two more buttons
  /// (open-code-in-browser, copy-code-link) will be added in the code view.
  codeLinkPrefix: 'https://github.com/<my_username>/<my_project>/blob/master/',
),
```

For multiple source code view by a 'WidgetWithCodeView2':

```dart
WidgetWithCodeView2(
  child: MyAwesomeWidget(),
  fileList: const [
    'lib/main.dart',
    'assets/code/my_awesome_code.xml',
    'assets/code/my_awesome_code.java',
  ],
  /// [codeLinkPrefix] is optional. When it's specified, two more buttons
  /// (open-code-in-browser, copy-code-link) will be added in the code view.
  codeLinkPrefix: 'https://github.com/<my_username>/<my_project>/blob/master/',
),
```

You can also choose to only show the code by not setting the `child` argument.

See `example/lib/main.dart` for a concrete example.
