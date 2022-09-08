import 'package:firebase_auth/firebase_auth.dart';
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
}
