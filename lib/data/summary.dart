import 'package:quick_summary/utils/consts.dart';
import 'package:quick_summary/utils/utils.dart';

class Summary {
  final int id;
  String title;
  String summaryText;

  int _timeStamp = 0;

  get creationTime => Utils.dateTimeFromMilliseconds(_timeStamp);

  Summary(this.title, this.summaryText) : id = -1 {
    _timeStamp = Utils.currentDateMilliseconds();
  }
  Summary.fromDatabase(Map<String, dynamic> databaseEntry)
      : id = databaseEntry[Consts.databaseID],
        title = databaseEntry[Consts.databaseSummaryTitle],
        summaryText = databaseEntry[Consts.databaseSummaryText],
        _timeStamp = databaseEntry[Consts.databaseSummaryTime];

  dump() {
    return {
      Consts.databaseSummaryTitle: title,
      Consts.databaseSummaryText: summaryText,
      Consts.databaseSummaryTime: _timeStamp
    };
  }
}
