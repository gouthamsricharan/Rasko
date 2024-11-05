import 'package:flutter/material.dart' show immutable;
import 'package:notesapp/services/auth/auth_user.dart';
import 'package:equatable/equatable.dart';

@immutable
abstract class AuthState {
  final bool isLoading;
  final String? loadingText;
  const AuthState({
    required this.isLoading,
    this.loadingText = 'Please wait a moment..',
  });
}

class AuthStateLoggedIn extends AuthState {
  final AuthUser user;
  const AuthStateLoggedIn({required this.user, required super.isLoading});
}

class AuthStateNeedsVerificaton extends AuthState {
  const AuthStateNeedsVerificaton({required super.isLoading});
}

class AuthStateUnInitialized extends AuthState {
  const AuthStateUnInitialized({required super.isLoading});
}

class AuthStateRegistering extends AuthState {
  final Exception? exception;
  const AuthStateRegistering({
    required this.exception,
    required super.isLoading,
  });
}

class AuthStateLoggedOut extends AuthState with EquatableMixin {
  final Exception? exception;
  const AuthStateLoggedOut({
    required this.exception,
    required super.isLoading,
    required super.loadingText,
  });

  @override
  List<Object?> get props => [exception, isLoading];
}
