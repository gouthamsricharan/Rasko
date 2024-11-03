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
  const AuthStateLoggedOut();
}

class AuthStateNeedsVerificaton extends AuthState {
  const AuthStateNeedsVerificaton();
}

class AuthStataLoginFailure extends AuthState {
  final Exception exception;
  const AuthStataLoginFailure(this.exception);
}

class AuthStataLogOutFailure extends AuthState {
  final Exception exception;
  const AuthStataLogOutFailure(this.exception);
}
