import 'dart:io';
import 'package:flutter/material.dart';
import 'package:quick_summary/data/kebab_menu_item.dart';
import 'package:quick_summary/pages/add_summary_page.dart';
import 'package:quick_summary/pages/file_pick_page.dart';
import 'package:quick_summary/pages/list_summaries_page.dart';
import 'package:quick_summary/services/database_service.dart';
import 'package:quick_summary/utils/consts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:quick_summary/utils/utils.dart';

class AppNavigation extends StatefulWidget {
  @override
  _AppNavigationState createState() => _AppNavigationState();
}

class _AppNavigationState extends State<AppNavigation> {
  late List<KebabMenuItem> _kebabMenuItems;

  var _pageIndex = 1;
  var _visibleSearchBar = false;

  Future<String> get cacheDirectory async {
    Directory rootPath = (await getExternalCacheDirectories())![0];
    return rootPath.path;
  }

  @override
  void initState() {
    super.initState();
    _kebabMenuItems = [
      KebabMenuItem("Export", Icons.arrow_circle_up_rounded, _onExport),
      KebabMenuItem("Import", Icons.arrow_circle_down_rounded, _onImport)
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Consts.appTitle),
        actions: _actions(context),
      ),
      body: _currentPageWidget(),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: Consts.allSummariesTitle,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.edit),
            label: Consts.newSummaryTitle,
          ),
        ],
        currentIndex: _pageIndex,
        selectedItemColor: Theme.of(context).accentColor,
        onTap: _onNavigation,
      ),
    );
  }

  Widget _currentPageWidget() {
    if (_pageIndex == 0) {
      return ListSummariesPage(
        showSearchBar: _visibleSearchBar,
      );
    }
    return AddSummaryPage();
  }

  List<Widget>? _actions(BuildContext context) {
    if (_pageIndex == 0) {
      return [
        IconButton(
          icon: _visibleSearchBar ? Icon(Icons.cancel) : Icon(Icons.search),
          onPressed: _onSearch,
        ),
      ];
    } else {
      return [
        PopupMenuButton<KebabMenuItem>(
          onSelected: (item) {
            _onMenuOption(context, item);
          },
          itemBuilder: (BuildContext context) {
            return _kebabMenuItems.map((item) {
              return item.build();
            }).toList();
          },
        ),
      ];
    }
  }

  void _onNavigation(int newIndex) {
    if (newIndex == _pageIndex) {
      return;
    }
    setState(() {
      _pageIndex = newIndex;
      _visibleSearchBar = false;
    });
  }

  void _onSearch() {
    setState(() {
      _visibleSearchBar = !_visibleSearchBar;
    });
  }

  void _onMenuOption(BuildContext context, KebabMenuItem menuItem) {
    menuItem.onSelected(context);
  }

  void _onExport(BuildContext context) async {
    var targetPath = await cacheDirectory;

    var databasePath = await DatabaseService().databasePath;
    var databaseFile = File(databasePath);

    var time = new DateTime.now();
    var year = time.year;
    var month = time.month;
    var day = time.day;
    var hour = time.hour;
    var minute = time.minute;
    var second = time.second;
    var newFile = databaseFile.copySync(
        '$targetPath/export_${day}_${month}_${year}_$hour:$minute:$second.db');
    String filePath = newFile.path;
    Utils.showToast(context, 'Exported to $filePath');
  }

  void _onImport(BuildContext context) async {
    // TODO: Move it to own route and page
    var exportDirectory = Directory(await cacheDirectory);
    final String? path = (await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FilePickPage(
          rootDirectory: exportDirectory,
        ),
      ),
    ));
    if (path == null) {
      return;
    }

    final loadedSummaries = await DatabaseService.allSummariesFromFile(path);
    final defaultSummaries = await DatabaseService().allSummaries();

    var missingSummaries = loadedSummaries
        .where((ls) => !defaultSummaries.any((ds) => ds.valueEqual(ls)))
        .toList();

    missingSummaries.forEach((summary) async {
      await DatabaseService().addSummary(summary);
    });
  }
}
