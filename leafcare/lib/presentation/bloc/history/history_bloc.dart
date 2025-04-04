// Bloc
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leafcare/data/models/history_model.dart';
import 'package:leafcare/data/repositories/database_repository.dart';
import 'package:leafcare/presentation/bloc/history/history_even.dart';
import 'package:leafcare/presentation/bloc/history/history_state.dart';

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  final DatabaseRepository _databaseRepository = DatabaseRepository();

  HistoryBloc() : super(HistoryInitial()) {
    on<LoadHistory>((event, emit) async {
      emit(HistoryLoading());

      try {
        List<ScanHistory> history =
            await _databaseRepository.getScanHistory(event.userId);

        emit(HistoryLoaded(history));
      } catch (e) {
        emit(HistoryError("Failed to load history: $e"));
      }
    });
  }
}
