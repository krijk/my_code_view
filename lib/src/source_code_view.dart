import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/atom-one-dark.dart';
import 'package:flutter_highlight/themes/atom-one-light.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:selectable/selectable.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;

class SourceCodeView extends StatefulWidget {
  // Path of source file (relative to project root). The file's content will be
  // shown in the "Code" tab.
  final String? filePath;
  final String? codeContent;
  final String? codeLinkPrefix;
  // Fine tune the menu appearance.
  final bool showLabelText;
  final Color? iconBackgroundColor;
  final Color? iconForegroundColor;
  final Color? labelBackgroundColor;
  final TextStyle? labelTextStyle;
  // Widget to put before/after the code content.
  final Widget? headerWidget;
  final Widget? footerWidget;
  // Code highlighter theme for light/dark theme, defaults to "atomOne" themes.
  final Map<String, TextStyle>? lightTheme;
  final Map<String, TextStyle>? darkTheme;

  final Color? overlayColor;
  final double overlayOpacity;

  final bool shareCode;
  final bool closeManually;
  final Color? tabIconColor;
  final TextStyle? tabTextStyle;

  // If not given, will just show the SourceCodeView (see https://github.com/X-Wei/widget_with_codeview/issues/10).
  final Widget? child;
  // Can be used to add a hook when switching tabs.
  final void Function(TabController)? tabChangeListener;

  const SourceCodeView({
    Key? key,
    required this.filePath,
    this.codeContent,
    this.codeLinkPrefix,
    this.showLabelText = false,
    this.iconBackgroundColor,
    this.iconForegroundColor,
    this.labelBackgroundColor,
    this.labelTextStyle,
    this.headerWidget,
    this.footerWidget,
    this.lightTheme,
    this.darkTheme,
    this.shareCode = false,
    this.overlayColor,
    this.overlayOpacity = 0.8,
    this.closeManually = true,
    this.tabIconColor,
    this.tabTextStyle,
    this.child,
    this.tabChangeListener,
  }) : super(key: key);

  String? get codeLink => codeLinkPrefix == null ? null : '$codeLinkPrefix/$filePath';

  @override
  SourceCodeViewState createState() {
    return SourceCodeViewState();
  }
}

class SourceCodeViewState extends State<SourceCodeView> {
  double _textScaleFactor = 1.0;
  ScrollController scrollController = ScrollController();
  String myCodeContent = '';

  Widget _getCodeView(String codeContent, BuildContext context) {
    myCodeContent = codeContent.replaceAll('\r\n', '\n');
    return Container(
      constraints: const BoxConstraints.expand(),
      child: Scrollbar(
        controller: scrollController,
        child: SingleChildScrollView(
          controller: scrollController,
          child: Column(
            children: <Widget>[
              if (widget.headerWidget != null) ...<Widget>[
                widget.headerWidget!,
                const Divider(),
              ],
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Selectable(
                  child: HighlightView(
                    codeContent,
                    language: 'dart',
                    theme: Theme.of(context).brightness == Brightness.light
                        ? widget.lightTheme ?? atomOneLightTheme
                        : widget.darkTheme ?? atomOneDarkTheme,
                    textStyle: GoogleFonts.notoSansMono(fontSize: 12).apply(fontSizeFactor: _textScaleFactor),
                  ),
                ),
              ),
              if (widget.footerWidget != null) ...<Widget>[
                const Divider(),
                widget.footerWidget!,
              ],
            ],
          ),
        ),
      ),
    );
  }

  List<SpeedDialChild> _buildFloatingButtons({
    TextStyle? labelTextStyle,
    Color? iconBackgroundColor,
    Color? iconForegroundColor,
    Color? labelBackgroundColor,
    required bool showLabelText,
  }) =>
      <SpeedDialChild>[
        if (widget.codeLink != null)
          SpeedDialChild(
            child: const Icon(Icons.content_copy),
            label: showLabelText ? 'Copy code to clipboard' : null,
            backgroundColor: iconBackgroundColor,
            foregroundColor: iconForegroundColor,
            labelBackgroundColor: labelBackgroundColor,
            labelStyle: labelTextStyle,
            onTap: () async {
              if (widget.codeContent != null) {
                Clipboard.setData(ClipboardData(text: widget.codeContent!));
              } else if (widget.filePath?.isNotEmpty ?? false) {
                Clipboard.setData(
                    ClipboardData(text: await DefaultAssetBundle.of(context).loadString(widget.filePath ?? '')),);
              }
              // final showSnackBar = ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              //   content: Text('Code copied to clipboard!'),
              // ),);
            },
          ),
        if (widget.codeLink != null)
          SpeedDialChild(
            child: const Icon(Icons.open_in_new),
            label: showLabelText ? 'View code in browser' : null,
            backgroundColor: iconBackgroundColor,
            foregroundColor: iconForegroundColor,
            labelBackgroundColor: labelBackgroundColor,
            labelStyle: labelTextStyle,
            onTap: () => url_launcher.launchUrl(Uri.parse(widget.codeLink!)),
          ),
        SpeedDialChild(
          child: const Icon(Icons.zoom_out),
          label: showLabelText ? 'Zoom out' : null,
          backgroundColor: iconBackgroundColor,
          foregroundColor: iconForegroundColor,
          labelBackgroundColor: labelBackgroundColor,
          labelStyle: labelTextStyle,
          onTap: () => setState(() {
            _textScaleFactor = max(0.8, _textScaleFactor - 0.1);
          }),
        ),
        SpeedDialChild(
          child: const Icon(Icons.zoom_in),
          label: showLabelText ? 'Zoom in' : null,
          backgroundColor: iconBackgroundColor,
          foregroundColor: iconForegroundColor,
          labelBackgroundColor: labelBackgroundColor,
          labelStyle: labelTextStyle,
          onTap: () => setState(() {
            _textScaleFactor += 0.1;
          }),
        ),
        if (widget.shareCode)
          SpeedDialChild(
            child: const Icon(Icons.share),
            label: showLabelText ? 'Share' : null,
            backgroundColor: iconBackgroundColor,
            foregroundColor: iconForegroundColor,
            labelBackgroundColor: labelBackgroundColor,
            labelStyle: labelTextStyle,
            onTap: doShare,
          ),
      ];

  Future<void> doShare() async {
    await Share.share(
      myCodeContent,
      subject: widget.filePath,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: widget.codeContent != null
          ? Future<String>.value(widget.codeContent)
          : DefaultAssetBundle.of(context).loadString(widget.filePath ?? ''),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        if (snapshot.hasData) {
          return Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(4.0),
              child: _getCodeView(snapshot.data!, context),
            ),
            floatingActionButton: SpeedDial(
              closeManually: widget.closeManually,
              overlayColor: widget.overlayColor,
              overlayOpacity: widget.overlayOpacity,
              backgroundColor: Colors.grey,
              foregroundColor: Colors.blueGrey,
              // activeBackgroundColor: Colors.red,
              // activeForegroundColor: Colors.white,
              animatedIcon: AnimatedIcons.menu_close,
              children: _buildFloatingButtons(
                labelTextStyle: widget.labelTextStyle,
                iconBackgroundColor: widget.iconBackgroundColor,
                iconForegroundColor: widget.iconForegroundColor,
                labelBackgroundColor: widget.labelBackgroundColor,
                showLabelText: widget.showLabelText,
              ),
            ),
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
