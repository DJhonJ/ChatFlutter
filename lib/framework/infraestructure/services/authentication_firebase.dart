import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:f_chat_template/data/services/iauthentication_service.dart';

import '../../../domain/app_user.dart';

class AuthenticationFirebase extends IAuthenticationService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Future<void> signIn({required String email, required String password}) async {
    await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  @override
  Future<void> signUp({required String email, required String password}) async {
    await _auth.createUserWithEmailAndPassword(email: email, password: password);
  }

  @override
  Future<void> logout() async {
    // TODO: implement logout
  }

  //metodo para saber si un usuario esta logueado o no
  /*Stream<AppUser?> loggedIn() {
    final StreamController<AppUser> streamController = StreamController();
    final AppUser? appUser = null;

    _auth.authStateChanges().listen((event) {
      if (event?.email != null) {
        appUser = AppUser(key, event?.email, event!.uid, true);
        streamController.sink.add();
      }
    });

    return streamController.stream;
  }*/
}