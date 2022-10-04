
abstract class IAuthenticationService {
    Future<void> signIn({ required String email, required String password });
    Future<void> signUp({ required String email, required String password });
    Future<void> logout();
}