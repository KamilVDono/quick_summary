import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quick_summary/data/summary.dart';
import 'package:quick_summary/services/database_service.dart';

class SummaryTile extends StatelessWidget {
  const SummaryTile({
    Key key,
    @required this.dateFormat,
    @required this.summary,
    @required this.expandedOnStart,
  }) : super(key: key);

  final DateFormat dateFormat;
  final Summary summary;
  final bool expandedOnStart;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: UniqueKey(),
      background: Container(color: Colors.red),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        DatabaseService().removeSummary(summary);
      },
      child: Card(
        child: ExpansionTile(
          initiallyExpanded: expandedOnStart,
          title: Text(
            summary.title,
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
          trailing: Text(
            dateFormat.format(summary.creationTime),
            style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w300),
          ),
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: 4,
                horizontal: 18,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(summary.summaryText),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}