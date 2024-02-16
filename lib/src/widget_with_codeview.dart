library widget_with_codeview;

import 'package:flutter/material.dart';

import 'source_code_view.dart';
import 'utl.dart';

class WidgetWithCodeView extends SourceCodeView {

  const WidgetWithCodeView({
    super.key,
    required super.filePath,
    super.codeContent,
    super.child,
    super.tabChangeListener,
    super.codeLinkPrefix,
    super.showLabelText,
    super.iconBackgroundColor,
    super.iconForegroundColor,
    super.labelBackgroundColor,
    super.labelTextStyle,
    super.headerWidget,
    super.footerWidget,
    super.lightTheme,
    super.darkTheme,
    super.shareCode,
    super.overlayColor,
    super.overlayOpacity = 0.8,
    super.closeManually = true,
    super.tabIconColor,
    super.tabTextStyle,
  });

  @override
  WidgetWithCodeViewState createState() => WidgetWithCodeViewState();
}

//? Need to override SourceCodeViewState rather than State<WidgetWithCodeView>.
//! otherwise won't compile, because WidgetWithCodeView extends SourceCodeView.
//! I use this inheritance to use "parameter forwarding" feature in dart 2.17.
class WidgetWithCodeViewState extends SourceCodeViewState with SingleTickerProviderStateMixin {
  late TabController _tabController;

  WidgetWithCodeViewState();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    if (widget.tabChangeListener != null) {
      _tabController.addListener(
        () => widget.tabChangeListener!(_tabController),
      );
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  String get routeName => '/WidgetWithCodeViewState()';

  @override
  Widget build(BuildContext context) {
    final Widget sourceCodeView = super.build(context);
    return Scaffold(
      appBar: (widget.child == null)
          ? null
          : _ColoredTabBar(
              color: Theme.of(context).primaryColor,
              tabBar: TabBar(
                controller: _tabController,
                tabs: generateTabs(),
              ),
            ),
      body: (widget.child == null)
          ? sourceCodeView
          : TabBarView(
              controller: _tabController,
              children: <Widget>[
                _AlwaysAliveWidget(child: widget.child!),
                _AlwaysAliveWidget(child: sourceCodeView),
              ],
            ),
    );
  }

  List<Widget> generateTabs() {
    final List<Widget> tabs = <Widget>[];
    for (final Tab1 tab in Tab1.values) {
      tabs.add(
        ListTile(
          leading: Icon(
            tab.iconData,
            color: widget.tabIconColor,
          ),
          title: Text(
            tab.label,
            style: widget.tabTextStyle,
          ),
        ),
      );
    }
    return tabs;
  }
}

// This widget is always kept alive, so that when tab is switched back, its
// child's state is still preserved.
class _AlwaysAliveWidget extends StatefulWidget {
  final Widget child;

  const _AlwaysAliveWidget({Key? key, required this.child}) : super(key: key);

  @override
  _AlwaysAliveWidgetState createState() => _AlwaysAliveWidgetState();
}

class _AlwaysAliveWidgetState extends State<_AlwaysAliveWidget> with AutomaticKeepAliveClientMixin<_AlwaysAliveWidget> {
  @override
  Widget build(BuildContext context) {
    super.build(context); // This build method is annotated "@mustCallSuper".
    return widget.child;
  }

  @override
  bool get wantKeepAlive => true;
}

class _ColoredTabBar extends Container implements PreferredSizeWidget {
  final TabBar tabBar;

  _ColoredTabBar({Key? key, Color? color, required this.tabBar}) : super(key: key, color: color);

  @override
  Size get preferredSize => tabBar.preferredSize;

  @override
  Widget build(BuildContext context) => Material(
        elevation: 4.0,
        color: color,
        child: tabBar,
      );
}
