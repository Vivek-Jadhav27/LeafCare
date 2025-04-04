// Events
abstract class HistoryEvent {}

class LoadHistory extends HistoryEvent {
  final String userId;
  LoadHistory(this.userId);
}
