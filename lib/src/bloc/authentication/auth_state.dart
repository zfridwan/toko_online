import 'package:equatable/equatable.dart';

abstract class AuthState extends Equatable {
  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final String email; // Include email in AuthSuccess

  AuthSuccess(this.email); // Constructor to accept email
}

class AuthFailure extends AuthState {
  final String error;

  AuthFailure(this.error);
}
