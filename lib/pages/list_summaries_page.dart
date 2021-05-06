import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:quick_summary/data/summary.dart';
import 'package:quick_summary/pages/controls/searchbar_control.dart';
import 'package:quick_summary/pages/controls/summaries_list_control.dart';
import 'package:quick_summary/services/summaries_fetcher.dart';

class ListSummariesPage extends StatefulWidget {
  final bool showSearchBar;

  const ListSummariesPage({Key? key, required this.showSearchBar})
      : super(key: key);

  @override
  _ListSummariesPageState createState() => _ListSummariesPageState();
}

class _ListSummariesPageState extends State<ListSummariesPage> {
  // TODO: Show loading indicator if not loaded
  DateFormat? _dateFormat;

  List<Summary> _summaries = <Summary>[];
  SummariesFetcher _fetcher = SummariesFetcher(5);
  bool _isLoading = true;
  bool _hasMore = true;

  String _searchText = "";

  @override
  void initState() {
    super.initState();
    _isLoading = true;
    _hasMore = true;
    _loadMore(initDataFormat: true);
  }

  void _loadMore({bool initDataFormat = false}) async {
    _isLoading = true;

    if (initDataFormat) {
      await initializeDateFormatting();
      String languageCode = Localizations.localeOf(context).languageCode;
      _dateFormat = DateFormat("dd.MM.yy HH:mm", languageCode);
    }

    _fetcher.fetch().then((List<Summary> summariesList) {
      if (mounted) {
        if (summariesList.isEmpty) {
          setState(() {
            _isLoading = false;
            _hasMore = false;
          });
        } else {
          setState(() {
            _isLoading = false;
            _summaries.addAll(summariesList);
          });
        }
      }
    });
  }

  _searchChanged(String searchString) {
    setState(() {
      _searchText = searchString.toLowerCase();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_dateFormat == null) {
      return Center(child: const CircularProgressIndicator());
    }

    if (!widget.showSearchBar) {
      _searchText = "";
    }
    if (widget.showSearchBar) {
      return Column(
        children: [
          SearchBar(
            onSearchChanged: _searchChanged,
          ),
          buildSummariesList(context),
        ],
      );
    } else {
      return Column(
        children: [
          buildSummariesList(context),
        ],
      );
    }
  }

  SummariesList buildSummariesList(BuildContext context) {
    return SummariesList(
      dateFormat: _dateFormat!,
      summaries: _filterSummaries(),
      expandedOnStart: (_searchText.isNotEmpty),
      canLoadMore: _hasMore,
      isLoading: _isLoading,
      loadMoreCallback: _loadMore,
    );
  }

  List<Summary> _filterSummaries() {
    return (_searchText.isNotEmpty)
        ? _summaries
            .where((s) =>
                s.summaryText.toLowerCase().contains(_searchText) ||
                s.title.toLowerCase().contains(_searchText))
            .toList()
        : _summaries;
  }
}
