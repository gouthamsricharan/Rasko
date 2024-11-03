import 'package:bloc/bloc.dart';
import 'package:notesapp/services/auth/auth_provider.dart';
import 'package:notesapp/services/auth/bloc/auth_event.dart';
import 'package:notesapp/services/auth/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(AuthProvider provider) : super(const AuthStateLoading()) {
    on<AuthEventInitialize>((event, emit) async {
      await provider.initialize();
      final user = provider.currentUser;
      if (user == null) {
        emit(const AuthStateLoggedOut());
      } else if (!user.isEmailVerified) {
        emit(const AuthStateNeedsVerificaton());
      } else {
        emit(AuthStateLoggedIn(user));
      }
    });

    on<AuthEventLogIn>((event, emit) async {
      emit(const AuthStateLoading());
      final email = event.email;
      final password = event.password;
      try {
        final user = await provider.logIn(
          email: email,
          password: password,
        );
        emit(AuthStateLoggedIn(user));
      } on Exception catch (e) {
        emit(AuthStataLoginFailure(e));
      }
    });

    on<AuthEventLogOut>((event, emit) async {
      try {
        emit(const AuthStateLoading());
        await provider.logOut();
      } on Exception catch (e) {
        emit(AuthStataLogOutFailure(e));
      }
    });
  }
}
