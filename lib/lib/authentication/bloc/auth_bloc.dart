import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_shreya/authentication/data/auth_repo.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository repository;

  AuthBloc(this.repository) : super(AuthInitial()) {
    on<LoginEvent>(_handleLogin);
    on<SignUpEvent>(_handleSignup);
  }

  Future<void> _handleSignup(SignUpEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await repository.signUp(event.email, event.password);
      emit(AuthSuccess());
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> _handleLogin(LoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await repository.login(event.email, event.password);
      emit(AuthSuccess());
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }
}
