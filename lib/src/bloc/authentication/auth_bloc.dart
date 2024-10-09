import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_event.dart'; // Ensure you import the correct event definitions
import 'auth_state.dart'; // Ensure you import the correct state definitions
import '../../core/api-service.dart'; // Ensure you import your ApiService

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final ApiService userRepository;

  AuthBloc(this.userRepository) : super(AuthInitial()) {
    on<SignUpRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        await userRepository.signUp(event.email, event.password);
        emit(AuthSuccess(event.email)); // Make sure you pass the email here
      } catch (e) {
        emit(AuthFailure(e.toString()));
      }
    });

    on<SignInRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        await userRepository.signIn(event.email, event.password);
        emit(
            AuthSuccess(event.email)); // Pass the email upon successful sign in
      } catch (e) {
        emit(AuthFailure(e.toString()));
      }
    });
  }
}
