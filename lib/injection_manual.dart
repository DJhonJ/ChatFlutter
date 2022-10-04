import 'package:f_chat_template/data/repository/authentication_repository.dart';
import 'package:f_chat_template/data/services/iauthentication_service.dart';
import 'package:f_chat_template/framework/infraestructure/services/authentication_firebase.dart';
import 'package:f_chat_template/use_cases/login_usecase.dart';
import 'package:f_chat_template/use_cases/signup_usecase.dart';

//clase proveedora de dependencias necesarias en la app
class InjectionManual {
  late final IAuthenticationService _authService;
  late final AuthenticationRepository _authRepository;

  InjectionManual() {
    _authService = AuthenticationFirebase();
    _authRepository = AuthenticationRepository(_authService);
  }

  LoginUseCase get loginUseCase => LoginUseCase(_authRepository);
  SignUpUseCase get signupUseCase => SignUpUseCase(_authRepository);
}