import 'package:quick_summary/data/summary.dart';
import 'package:quick_summary/services/database_service.dart';

class SummariesFetcher{
  SummariesFetcher(this.itemsPerPage);
  
  final int itemsPerPage;
  int _currentPage = 0;
  
  Future<List<Summary>> fetch() async {
    var results = DatabaseService().summariesForPage(itemsPerPage, _currentPage);
    _currentPage++;
    return results;
  }
}
