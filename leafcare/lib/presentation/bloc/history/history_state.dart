import 'package:leafcare/data/models/history_model.dart';

abstract class HistoryState {}

class HistoryInitial extends HistoryState {}

class HistoryLoading extends HistoryState {}

class HistoryLoaded extends HistoryState {
  final List<ScanHistory> history;
  HistoryLoaded(this.history);
}
class HistoryError extends HistoryState {
  final String message;
  HistoryError(this.message);
}