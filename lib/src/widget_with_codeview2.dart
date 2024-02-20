library widget_with_codeview;

import 'package:flutter/material.dart';

import 'source_code_view.dart';
import 'utl.dart';

/// Tabs 2nd level
/// Limited numbers
enum _Tab2 {
  one,
  two,
  three,
  four,
  five,
  six,
  seven,
  eight,
  nine,
  ;

  TabInfo get info => TabInfo(name, iconData);

  IconData get iconData {
    switch (this) {
      case one:
        return Icons.filter_1;  // looks_one_rounded;
      case two:
        return Icons.filter_2;
      case three:
        return Icons.filter_3;
      case four:
        return Icons.filter_4;
      case five:
        return Icons.filter_5;
      case six:
        return Icons.filter_6;
      case seven:
        return Icons.filter_7;
      case eight:
        return Icons.filter_8;
      case nine:
        return Icons.filter_9;
    }
  }

  /// Get enum name using extension
  String get name {
    return toString().split('.').last;
  }

  /// Get enum by specified index
  static _Tab2? getEnum(int idx) {
    for (final _Tab2 tab in _Tab2.values) {
      if (tab.index == idx) {
        return tab;
      }
    }
    return null;
  }
}

class WidgetWithCodeView2 extends StatefulWidget {
  // If not given, will just show the SourceCodeView (see https://github.com/X-Wei/widget_with_codeview/issues/10).
  final Widget? child;
  // Can be used to add a hook when switching tabs.
  final void Function(TabController)? tabChangeListener;

  final List<String> fileList;
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

  const WidgetWithCodeView2({
    super.key,
    required this.fileList,
    this.codeContent,
    this.child,
    this.tabChangeListener,
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
    this.overlayColor,
    this.overlayOpacity = 0.8,
    this.shareCode = false,
    this.closeManually = true,
    this.tabIconColor,
    this.tabTextStyle,
  })  : assert(fileList.length > 0);

  @override
  WidgetWithCodeView2State createState() => WidgetWithCodeView2State();
}

//? Need to override SourceCodeViewState rather than State<WidgetWithCodeView>.
//! otherwise won't compile, because WidgetWithCodeView extends SourceCodeView.
//! I use this inheritance to use "parameter forwarding" feature in dart 2.17.
class WidgetWithCodeView2State extends State<WidgetWithCodeView2> with SingleTickerProviderStateMixin {
  List<Widget> tabs = <Widget>[];
  List<Widget> sources = <Widget>[];
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    tabs = generateTabs();
    sources = generateView();
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

  String get routeName => '/WidgetWithCodeViewState2()}';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: (widget.child == null)
          ? null
          : _ColoredTabBar(
              color: Theme.of(context).primaryColor,
              tabBar: TabBar(
                controller: _tabController,
                tabs: tabs,
              ),
            ),
      body: (widget.child == null)
          ? getCodeTab()
          : TabBarView(
              controller: _tabController,
              children: <Widget>[
                _AlwaysAliveWidget(child: widget.child!),
                _AlwaysAliveWidget(child: getCodeTab()),
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

  Widget getCodeTab() {
    if (sources.length > 1) {
      return _TabPageCodeMulti(
        sourceCodeView: sources,
      );
    }
    return sources[0];
  }

  List<Widget> generateView() {
    final List<Widget> sources = <Widget>[];
    for (int i = 0; i < widget.fileList.length; i++) {
      final SourceCodeView sourceCodeView = SourceCodeView(
        filePath: widget.fileList[i],
        codeContent: widget.codeContent,
        codeLinkPrefix: widget.codeLinkPrefix,
        showLabelText: widget.showLabelText,
        iconBackgroundColor: widget.iconBackgroundColor,
        iconForegroundColor: widget.iconForegroundColor,
        labelBackgroundColor: widget.labelBackgroundColor,
        labelTextStyle: widget.labelTextStyle,
        headerWidget: widget.headerWidget,
        footerWidget: widget.footerWidget,
        lightTheme: widget.lightTheme,
        darkTheme: widget.darkTheme,
        shareCode: widget.shareCode,
        overlayColor: widget.overlayColor,
        overlayOpacity: widget.overlayOpacity,
        closeManually: widget.closeManually,
      );
      sources.add(sourceCodeView);
    }
    return sources;
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

class _MyPageParent2 extends StatefulWidget {
  final int tabs;
  final List<Widget> sourceCodeView;

  const _MyPageParent2({required this.tabs, required this.sourceCodeView}) : assert(tabs <= _Tab2.values.length);

  @override
  _MyPageState2 createState() => _MyPageState2();
}

class _MyPageState2 extends State<_MyPageParent2> with SingleTickerProviderStateMixin {
  late TabController? _tabController2;
  late List<Tab> _tab02;

  @override
  void initState() {
    super.initState();
    _tab02 = generateTabs();
    _tabController2 = TabController(vsync: this, length: _tab02.length);
    _tabController2!.addListener(_handleTabSelection);
    _tabController2!.animation!.addListener(() {});
  }

  @override
  void dispose() {
    _tabController2!.dispose();
    super.dispose();
  }

  List<Tab> generateTabs() {
    final List<Tab> list = <Tab>[];

    for (final _Tab2 tab in _Tab2.values) {
      list.add(
        Tab(
          icon: Icon(tab.iconData),
        ),
      );

      if (tab.index + 1 >= widget.tabs) {
        break;
      }
    }
    return list;
  }

  void _handleTabSelection() {
    if (!_tabController2!.indexIsChanging) {
      final _Tab2? tab = _Tab2.getEnum(_tabController2!.index);
      if (tab != null) {
        // _showSnackBar(tab.name);
      }
    }
  }

  /*
  void _showSnackBar(String content) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(content),
        duration: const Duration(milliseconds: 500),
      ),
    );
  }
   */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TabBar(
        controller: _tabController2,
        tabs: _tab02,
      ),
      body: TabBarView(
        controller: _tabController2,
        children: widget.sourceCodeView,
      ),
    );
  }
}

/// Multi Tab Parent page
class _TabPageCodeMulti extends StatelessWidget {
  final List<Widget> sourceCodeView;

  /// Tab page
  const _TabPageCodeMulti({Key? key, required this.sourceCodeView}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _MyPageParent2(
      tabs: sourceCodeView.length,
      sourceCodeView: sourceCodeView,
    );
  }
}
