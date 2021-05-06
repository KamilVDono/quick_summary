import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quick_summary/data/summary.dart';
import 'package:quick_summary/services/database_service.dart';

class SummaryTile extends StatefulWidget {
  SummaryTile({
    Key? key,
    required this.dateFormat,
    required this.summary,
    required this.expandedOnStart,
  })   : textEditingController = new TextEditingController(),
        super(key: key) {
    textEditingController.text = summary.summaryText;
    textEditingController.addListener(() {
      summary.summaryText = textEditingController.text;
    });
  }

  final DateFormat dateFormat;
  final Summary summary;
  final bool expandedOnStart;
  final TextEditingController textEditingController;

  @override
  _SummaryTileState createState() => _SummaryTileState(expandedOnStart);
}

class _SummaryTileState extends State<SummaryTile> {
  bool _isExpanded;
  bool _editing = false;

  _SummaryTileState(this._isExpanded);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: UniqueKey(),
      background: Container(color: Colors.red),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        DatabaseService().removeSummary(widget.summary);
      },
      child: Card(
        child: ExpansionTile(
          initiallyExpanded: _isExpanded,
          title: Text(
            widget.summary.title,
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            widget.dateFormat.format(widget.summary.creationTime),
            style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w300),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(_editing ? Icons.check_sharp : Icons.edit),
                onPressed: _isExpanded
                    ? () {
                        setState(() {
                          _editing = !_editing;
                        });
                      }
                    : null,
              ),
            ],
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
                    child: _editing
                        ? TextField(
                            autofocus: true,
                            controller: widget.textEditingController,
                            maxLines: null,
                          )
                        : Text(widget.summary.summaryText),
                  ),
                ],
              ),
            )
          ],
          onExpansionChanged: (isExpanded) {
            setState(() {
              _isExpanded = isExpanded;
            });
          },
        ),
      ),
    );
  }
}
