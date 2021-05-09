import 'package:flutter/material.dart';
import 'package:quick_summary/pages/add_summary_page.dart';
import 'package:quick_summary/pages/list_summaries_page.dart';
import 'package:quick_summary/services/database_service.dart';
import 'package:quick_summary/utils/consts.dart';

class AppNavigation extends StatefulWidget {
  @override
  _AppNavigationState createState() => _AppNavigationState();
}

class _AppNavigationState extends State<AppNavigation> {
  var _pageIndex = 1;
  var _visibleSearchBar = false;

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
        IconButton(
          icon: Icon(Icons.info),
          onPressed: () {
            _showToast(context);
          },
        ),
      ];
    }
    return null;
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

  void _showToast(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: FutureBuilder<String>(
          future: DatabaseService().databasePath,
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            if (snapshot.hasData) {
              return Text(snapshot.data!);
            } else {
              return Text("Waiting");
            }
          },
        ),
      ),
    );
  }
}
