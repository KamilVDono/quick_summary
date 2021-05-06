import 'dart:async';

import 'package:flutter/material.dart';
import 'package:quick_summary/data/summary.dart';
import 'package:quick_summary/pages/controls/save_button_control.dart';
import 'package:quick_summary/pages/controls/summary_text_field_control.dart';
import 'package:quick_summary/pages/controls/timer_control.dart';
import 'package:quick_summary/services/database_service.dart';
import 'package:quick_summary/utils/consts.dart';
import 'package:quick_summary/utils/summary_title_dialog.dart';

class AddSummaryPage extends StatefulWidget {
  @override
  _AddSummaryPageState createState() => _AddSummaryPageState();
}

class _AddSummaryPageState extends State<AddSummaryPage> {
  static const _updateDuration = const Duration(milliseconds: 10);
  final _summaryTextController = TextEditingController();

  Timer? _timer;
  double _leftTime = Consts.summaryMaxTime;

  get _canSave {
    var timeConstrain = _leftTime < Consts.minimumSaveTime;
    var notEmptyTextConstrain = _summaryTextController.text.isNotEmpty;
    return timeConstrain && notEmptyTextConstrain;
  }

  _save(BuildContext context) async {
    var summaryText = _summaryTextController.text;
    var summaryTitle = await _getSummaryTitle(context);

    if (summaryTitle.isNotEmpty) {
      var summary = Summary(summaryTitle, summaryText);
      await _addToDatabase(summary);
      _resetState(context);
    }
  }

  Future _addToDatabase(Summary summary) async {
    await DatabaseService().addSummary(summary);
  }

  void _resetState(BuildContext context) {
    setState(() {
      if (_timer?.isActive ?? false) {
        _timer!.cancel();
      }
      _timer = null;
      _leftTime = Consts.summaryMaxTime;
      FocusScope.of(context).unfocus();
      _summaryTextController.clear();
    });
  }

  Future<String> _getSummaryTitle(BuildContext context) async {
    String summaryTitle = "";
    await showDialog<String>(
      context: context,
      builder: (BuildContext context) => SummaryTitleDialog(
        callback: (t) => summaryTitle = t,
      ),
    );
    return summaryTitle;
  }

  _startTimer() {
    _timer = new Timer.periodic(
      _updateDuration,
      _updateTimer,
    );
  }

  void _updateTimer(Timer timer) {
    if (_leftTime <= 0) {
      setState(() {
        timer.cancel();
        _leftTime = 0;
      });
      return;
    }
    setState(() {
      _leftTime -= 0.01;
    });
  }

  @override
  Widget build(BuildContext context) {
    var saveAction = _canSave ? () => _save(context) : null;
    var onTap = _timer == null ? _startTimer : null;
    return Column(
      children: [
        TimerControl(leftTime: _leftTime),
        SummaryTextField(
          summaryTextController: _summaryTextController,
          onTap: onTap,
        ),
        SaveButton(saveAction: saveAction),
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
    if (_timer?.isActive ?? false) {
      _timer!.cancel();
      _timer = null;
    }
  }
}
