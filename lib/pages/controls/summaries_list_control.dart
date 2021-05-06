import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quick_summary/data/summary.dart';
import 'package:quick_summary/pages/controls/summary_tile_control.dart';

class SummariesList extends StatelessWidget {
  const SummariesList({
    Key? key,
    required this.dateFormat,
    required this.summaries,
    required this.expandedOnStart,
    required this.canLoadMore,
    required this.isLoading,
    required this.loadMoreCallback,
  }) : super(key: key);

  final DateFormat dateFormat;
  final List<Summary> summaries;
  final bool expandedOnStart;
  final bool canLoadMore;
  final bool isLoading;
  final Function loadMoreCallback;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: canLoadMore ? summaries.length + 1 : summaries.length,
        itemBuilder: (BuildContext context, int index) {
          if (index >= summaries.length) {
            // Don't trigger if one async loading is already under way
            if (!isLoading) {
              loadMoreCallback();
            }
            return Center(
              child: SizedBox(
                child: CircularProgressIndicator(),
                height: 24,
                width: 24,
              ),
            );
          }
          
          Summary item = summaries[index];
          return SummaryTile(
            dateFormat: dateFormat,
            summary: item,
            expandedOnStart: expandedOnStart,
          );
        },
      ),
    );
  }
}
