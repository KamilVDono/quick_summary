class Utils{
  static int currentDateMilliseconds() {
    return (new DateTime.now()).millisecondsSinceEpoch;
  }

  static DateTime dateTimeFromMilliseconds(int milliseconds) =>
      DateTime.fromMillisecondsSinceEpoch(milliseconds);
}