// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/cupertino.dart';
import 'package:todo_list_provider_project/app/exception/auth_exception.dart';

import 'package:todo_list_provider_project/app/services/user/user_service.dart';

class RegisterController extends ChangeNotifier {
  String? error;
  bool success = false;
  final UserService _userService;
  RegisterController({
    required UserService userService,
  }) : _userService = userService;

  Future<void> registerUser(String email, String password) async {
    try {
      error = null;
      success = false;
      notifyListeners();
      final user = await _userService.register(email, password);

      if (user != null) {
        success = true;
      } else {
        error = 'Erro ao registrar usuário';
      }
    } on AuthException catch (e) {
      error = e.message;
    } finally {
      notifyListeners();
    }
  }
}
