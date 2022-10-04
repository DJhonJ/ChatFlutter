import 'package:f_chat_template/data/repository/authentication_repository.dart';

class SignUpUseCase {
  const SignUpUseCase(this._repository);
  final AuthenticationRepository _repository;

  Future<void> invoke({ required String email, required String password }) async {
    await _repository.signUp(email: email, password: password);
  }
}