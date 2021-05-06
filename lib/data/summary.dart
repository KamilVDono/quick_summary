import 'package:quick_summary/services/database_service.dart';
import 'package:quick_summary/utils/consts.dart';
import 'package:quick_summary/utils/utils.dart';

class Summary {
  final int id;
  String _title;
  String _summaryText;

  int _timeStamp = 0;

  get creationTime => Utils.dateTimeFromMilliseconds(_timeStamp);
  String get title => _title;
  String get summaryText => _summaryText;
  set summaryText(String value) {
    if(_summaryText != value) {
      _summaryText = value;
      DatabaseService().updateSummary(this);
    }
  }

  Summary(this._title, this._summaryText) : id = -1 {
    _timeStamp = Utils.currentDateMilliseconds();
  }
  Summary.fromDatabase(Map<String, dynamic> databaseEntry)
      : id = databaseEntry[Consts.databaseID],
        _title = databaseEntry[Consts.databaseSummaryTitle],
        _summaryText = databaseEntry[Consts.databaseSummaryText],
        _timeStamp = databaseEntry[Consts.databaseSummaryTime];

  dump() {
    return {
      Consts.databaseSummaryTitle: _title,
      Consts.databaseSummaryText: _summaryText,
      Consts.databaseSummaryTime: _timeStamp
    };
  }
}
