import 'package:flutter/material.dart';

class SummaryTitleDialog extends StatelessWidget {
  final Function(String) callback;
  final _titleTextController = TextEditingController();

  SummaryTitleDialog({Key? key, required this.callback})
      : super(key: key);

  void save(BuildContext context) {
    callback(_titleTextController.text);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.all(16.0),
      content: new Row(
        children: <Widget>[
          new Expanded(
            child: new TextField(
              controller: _titleTextController,
              autofocus: true,
              decoration: new InputDecoration(
                labelText: "Title",
                hintText: "Enter title",
              ),
            ),
          )
        ],
      ),
      actions: <Widget>[
        ElevatedButton(
          child: const Text("Save"),
          onPressed: () => save(context),
        ),
      ],
    );
  }
}
