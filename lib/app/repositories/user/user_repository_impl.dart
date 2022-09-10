import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:todo_list_provider_project/app/exception/auth_exception.dart';

import './user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  FirebaseAuth _firebaseAuth;

  UserRepositoryImpl({required FirebaseAuth firebaseAuth})
      : _firebaseAuth = firebaseAuth;
  @override
  Future<User?> register(String email, String password) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      return userCredential.user;
    } on FirebaseAuthException catch (e, s) {
      print(e);
      print(s);
      //!! email-already-exists - verificar se foi alterado mensagme de erro
      if (e.code == 'email-already-in-use') {
        final logginTypes =
            await _firebaseAuth.fetchSignInMethodsForEmail(email);
        if (logginTypes.contains("password")) {
          throw AuthException(
              message: 'E-mail já utilizado, por favor escolha outro e-mail');
        } else {
          throw AuthException(
              message:
                  "Você logou através da sua conta Google, por favor utilize ele como forma de login");
        }
      } else {
        throw AuthException(message: e.message ?? 'Erro ao registrar usuário');
      }
    }
  }

  @override
  Future<User?> login(String email, String password) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);

      return userCredential.user;
    } on PlatformException catch (e, s) {
      print(e);
      print(s);
      throw AuthException(message: e.message ?? "Erro ao realizar login");
    } on FirebaseAuthException catch (e, s) {
      print(e);
      print(s);
      if (e.code == "wrong-password") {
        throw AuthException(message: "Login ou senha inválidos");
      } else if (e.code == "user-not-found") {
        throw AuthException(message: "Usuário não encontrado");
      }
      throw AuthException(message: e.message ?? "Erro ao realizar login");
    }
  }

  @override
  Future<void> forgotPassword(String email) async {
    try {
      final userForgotEmail =
          await _firebaseAuth.fetchSignInMethodsForEmail(email);
      if (userForgotEmail.contains('password')) {
        await _firebaseAuth.sendPasswordResetEmail(email: email);
      } else if (userForgotEmail.contains("google")) {
        throw AuthException(
            message:
                "Cadastro realizado com google, verifique a autenticação com o google");
      } else {
        throw AuthException(message: "Email não cadastrado");
      }
    } on PlatformException catch (e, s) {
      print(e);
      print(s);
      throw AuthException(message: "Erro ao resetar senha");
    }
  }
}
