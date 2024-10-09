import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_event.dart';
import 'auth_state.dart';
import '../../core/api-service.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final ApiService userRepository;

  AuthBloc(this.userRepository) : super(AuthInitial()) {
    on<SignUpRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        await userRepository.signUp(event.email, event.password);
        emit(AuthSuccess(event.email));
      } catch (e) {
        emit(AuthFailure(e.toString()));
      }
    });

    on<SignInRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        await userRepository.signIn(event.email, event.password);
        emit(AuthSuccess(event.email));
      } catch (e) {
        emit(AuthFailure(e.toString()));
      }
    });
  }
}
