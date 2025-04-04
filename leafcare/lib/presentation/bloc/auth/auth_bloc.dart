import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leafcare/data/repositories/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;

  AuthBloc(this._authRepository) : super(AuthInitial()) {
    on<LoginRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        final response =
            await _authRepository.signIn(event.email, event.password);
        if (response != null) {
          emit(AuthSuccess());
        } else {
          emit(AuthFailure("Invalid credentials"));
        }
      } catch (e) {
        emit(AuthFailure("Login failed: ${e.toString()}"));
      }
    });

    on<GoogleLoginRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        final response = await _authRepository.googleSignIn();
        if (response != null) {
          emit(AuthSuccess());
        } else {
          emit(AuthFailure("Google login failed"));
        }
      } catch (e) {
        emit(AuthFailure(e.toString()));
      }
    });

    on<SignupRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        final response = await _authRepository.signUp(
            event.name, event.email, event.password);
        if (response != null) {
          emit(AuthSuccess());
        } else {
          emit(AuthFailure("Sign up failed"));
        }
      } catch (e) {
        emit(AuthFailure("Sign up error: ${e.toString()}"));
      }
    });
  }
}
