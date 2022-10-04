
import 'package:f_chat_template/data/repository/authentication_repository.dart';

class LoginUseCase {
  const LoginUseCase(this._authRepository);
  final AuthenticationRepository _authRepository;

  Future<void> invoke({ required String email, required String password }) async {
    await _authRepository.login(email: email, password: password);
  }
}