import 'package:flutter/material.dart';

class SummaryTextField extends StatelessWidget {
  const SummaryTextField({
    Key? key,
    required TextEditingController summaryTextController,
    this.onTap,
  })  : _summaryTextController = summaryTextController,
        super(key: key);

  final TextEditingController _summaryTextController;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: 0,
          horizontal: 8,
        ),
        child: TextField(
          controller: _summaryTextController,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: "Start new summary",
            labelText: "Summary",
            floatingLabelBehavior: FloatingLabelBehavior.always,
          ),
          onTap: onTap,
          expands: true,
          maxLines: null,
        ),
      ),
    );
  }
}
