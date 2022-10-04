import 'package:f_chat_template/data/services/iauthentication_service.dart';

class AuthenticationRepository {
  const AuthenticationRepository(this._authService);
  final IAuthenticationService _authService;

  Future<void> login({ required String email, required String password }) async {
    await _authService.signIn(email: email, password: password);
  }

  Future<void> signUp({ required String email, required String password }) async {
    await _authService.signUp(email: email, password: password);
  }

  void logout() {

  }
}