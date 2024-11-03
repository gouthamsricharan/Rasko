import 'package:flutter/material.dart' show immutable;
import 'package:notesapp/services/auth/auth_user.dart';

@immutable
abstract class AuthState {
  const AuthState();
}

class AuthStateLoading extends AuthState {
  const AuthStateLoading();
}

class AuthStateLoggedIn extends AuthState {
  final AuthUser user;
  const AuthStateLoggedIn(this.user);
}

class AuthStateLoggedOut extends AuthState {
  final Exception? exception;
  const AuthStateLoggedOut(this.exception);
}

class AuthStateNeedsVerificaton extends AuthState {
  const AuthStateNeedsVerificaton();
}
class AuthStateLogOutFailure extends AuthState {
  final Exception exception;
  const AuthStateLogOutFailure(this.exception);
}
