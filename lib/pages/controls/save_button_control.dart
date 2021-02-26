import 'package:flutter/material.dart';
import 'package:quick_summary/utils/consts.dart';

class SaveButton extends StatelessWidget {
  const SaveButton({
    Key key,
    @required this.saveAction,
  }) : super(key: key);

  final Function() saveAction;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 0, horizontal: 2),
        child: RaisedButton(
          child: Text(Consts.saveTitle),
          onPressed: saveAction,
        ),
      ),
    );
  }
}
