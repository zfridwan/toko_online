import 'package:equatable/equatable.dart';

abstract class AuthState extends Equatable {
  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final String email;

  AuthSuccess(this.email);
}

class AuthFailure extends AuthState {
  final String error;

  AuthFailure(this.error);
}
