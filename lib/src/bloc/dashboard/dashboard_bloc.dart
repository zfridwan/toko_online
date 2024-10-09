import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:toko_online/src/core/api-service.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  DashboardBloc(ApiService apiService) : super(DashboardInitial()) {
    on<DashboardEvent>((event, emit) {
      if (event is NavBack) {
        emit(DashboardNav());
      }
    });
  }
}
