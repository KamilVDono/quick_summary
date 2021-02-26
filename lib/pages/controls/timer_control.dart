import 'package:flutter/material.dart';

class TimerControl extends StatelessWidget {
  const TimerControl({
    Key key,
    @required double leftTime,
  }) : _leftTime = leftTime, super(key: key);

  final double _leftTime;

  @override
  Widget build(BuildContext context) {
    return Padding(
      child: SizedBox(
        width: double.infinity,
        child: Card(
          child: Center(
            child: Text(
              _leftTime.toStringAsFixed(2),
              style: TextStyle(fontSize: 24),
            ),
          ),
        ),
      ),
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
    );
  }
}