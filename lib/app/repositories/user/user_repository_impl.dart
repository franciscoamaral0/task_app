import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
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

  @override
  Future<User?> googleLogin() async {
    List<String>? loginMethods;
    try {
      final googleSignin = GoogleSignIn();
      final googleUser = await googleSignin.signIn();

      if (googleUser != null) {
        loginMethods =
            await _firebaseAuth.fetchSignInMethodsForEmail(googleUser.email);

        if (loginMethods.contains('password')) {
          throw AuthException(
              message:
                  "Você ja cadastrou email no aplicativo, caso tenha esquecido sua senha, clicar no link esqueci a senha");
        } else {
          final googleAuth = await googleUser.authentication;
          final firebaseCredential = GoogleAuthProvider.credential(
              accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

          final userCredential =
              await _firebaseAuth.signInWithCredential(firebaseCredential);

          return userCredential.user;
        }
      }
    } on FirebaseAuthException catch (e, s) {
      print(e);
      print(s);
      if (e.code == "account-exist-with-different-credential") {
        throw AuthException(message: '''
          Login invalido, você se registrou no App com os seguintes provedores:
          ${loginMethods?.join(',')}
          ''');
      } else {
        throw AuthException(message: "Erro ao realizer login");
      }
    }
  }

  @override
  Future<void> googleLogout() async {
    await GoogleSignIn().signOut();
    _firebaseAuth.signOut();
  }
}
