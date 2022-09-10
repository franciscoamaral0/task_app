import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:provider/provider.dart';
import 'package:todo_list_provider_project/app/core/notifier/default_listener_notifier.dart';
import 'package:todo_list_provider_project/app/core/ui/messages.dart';
import 'package:todo_list_provider_project/app/core/widgets/todo_list_field.dart';
import 'package:todo_list_provider_project/app/core/widgets/todo_list_logo.dart';
import 'package:todo_list_provider_project/app/modules/auth/login/login_controller.dart';
import 'package:todo_list_provider_project/app/modules/splash/splash_page.dart';
import 'package:validatorless/validatorless.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailEC = TextEditingController();
  final _senhaEC = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _emailFocus = FocusNode();

  @override
  void initState() {
    DefaultListenerNotifier(changeNotifier: context.read<LoginController>())
        .listener(
      context: context,
      sucessCallback: (notifier, listenerInstance) {
        print("login efetuado com sucesso");
      },
      everCallback: (notifier, listenerInstance) {
        if (notifier is LoginController) {
          if (notifier.hasInfo) {
            Messages.of(context).showInfo(notifier.infoMessage!);
          }
        }
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
                maxWidth: constraints.maxWidth,
              ),
              child: IntrinsicHeight(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 10),
                    const TodoListLogo(),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40.0, vertical: 20),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TodoListField(
                              controller: _emailEC,
                              focusNode: _emailFocus,
                              label: "E-mail",
                              validator: Validatorless.multiple([
                                Validatorless.required(
                                    "Por favor, informe um e-mail válida")
                              ]),
                            ),
                            const SizedBox(height: 20),
                            TodoListField(
                              controller: _senhaEC,
                              label: "Senha",
                              obscureText: true,
                              validator: Validatorless.multiple([
                                Validatorless.required(
                                    "Por favor, informe uma senha válida"),
                                Validatorless.min(
                                    6, "Senha com no mínimo 6 caracteres")
                              ]),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    if (_emailEC.text.isNotEmpty) {
                                      context
                                          .read<LoginController>()
                                          .fogotPassword(_emailEC.text);
                                    } else {
                                      _emailFocus.requestFocus();
                                      Messages.of(context)
                                          .showError("Digite um e-mail válido");
                                    }
                                  },
                                  child: const Text("Esqueceu sua senha?"),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    final formValidade =
                                        _formKey.currentState?.validate() ??
                                            false;

                                    if (formValidade) {
                                      final login = _emailEC.text;
                                      final password = _senhaEC.text;
                                      context
                                          .read<LoginController>()
                                          .login(login, password);
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                  child: const Padding(
                                    padding: EdgeInsets.all(10.0),
                                    child: Text("Login"),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xfff0f3f7),
                          border: Border(
                            top: BorderSide(
                              width: 2,
                              color: Colors.grey.withAlpha(50),
                            ),
                          ),
                        ),
                        child: Column(
                          children: [
                            const SizedBox(height: 30),
                            SignInButton(
                              Buttons.Google,
                              onPressed: () {},
                              text: "Continue com o Google",
                              padding: const EdgeInsets.all(5),
                              shape: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Não tem conta?"),
                                TextButton(
                                    onPressed: () {
                                      Navigator.of(context)
                                          .pushNamed("/register");
                                    },
                                    child: Text("Cadastre-se"))
                              ],
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
