import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list_provider_project/app/core/ui/theme_extensions.dart';
import 'package:todo_list_provider_project/app/core/widgets/todo_list_field.dart';
import 'package:todo_list_provider_project/app/core/widgets/todo_list_logo.dart';
import 'package:todo_list_provider_project/app/modules/auth/register/register_controller.dart';
import 'package:validatorless/validatorless.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailEC = TextEditingController();
  final _passwordEC = TextEditingController();
  final _confirmPasswordEC = TextEditingController();

  @override
  void initState() {
    context.read<RegisterController>().addListener(() {
      final controller = context.read<RegisterController>();
      var success = controller.success;
      var error = controller.error;
      if (success) {
        Navigator.of(context).pop();
      } else if (error != null && error.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(error),
          backgroundColor: Colors.red,
        ));
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: ClipOval(
                child: Container(
                  color: context.primaryColor.withAlpha(20),
                  padding: const EdgeInsets.all(8),
                  child: Icon(
                    Icons.arrow_back_ios_new_outlined,
                    size: 20,
                    color: context.primaryColor,
                  ),
                ),
              )),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Todo List",
                style: TextStyle(fontSize: 12, color: context.primaryColor),
              ),
              Text("Cadastro",
                  style: TextStyle(fontSize: 15, color: context.primaryColor))
            ],
          )),
      body: ListView(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.width * .5,
            child: const FittedBox(
              fit: BoxFit.fitHeight,
              child: TodoListLogo(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20.0),
            child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TodoListField(
                      label: 'E-mail',
                      controller: _emailEC,
                      validator: Validatorless.multiple(
                        [
                          Validatorless.email("Isira um e-mail válido"),
                          Validatorless.required("E-mail obrigatório")
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    TodoListField(
                      validator: Validatorless.multiple([
                        Validatorless.required("Senha obrigatória"),
                        Validatorless.min(
                            6, "Senha deve ter no mínimo 6 caracteres"),
                        Validatorless.compare(_confirmPasswordEC,
                            "Senhas nao coincidem, por favor verificar")
                      ]),
                      label: "Senha",
                      obscureText: true,
                      controller: _passwordEC,
                    ),
                    const SizedBox(height: 20),
                    TodoListField(
                      label: "Confirma senha",
                      obscureText: true,
                      controller: _confirmPasswordEC,
                      validator: Validatorless.multiple([
                        Validatorless.required("Senha obrigatória"),
                        Validatorless.compare(_passwordEC,
                            "Senhas nao coincidem, por favor verificar")
                      ]),
                    ),
                    const SizedBox(height: 20),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: ElevatedButton(
                        onPressed: () {
                          final formValid =
                              _formKey.currentState?.validate() ?? false;

                          if (formValid) {
                            final email = _emailEC.text;
                            final password = _passwordEC.text;
                            context
                                .read<RegisterController>()
                                .registerUser(email, password);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: const Text("Salvar"),
                      ),
                    )
                  ],
                )),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    _emailEC.dispose();
    _passwordEC.dispose();
    _confirmPasswordEC.dispose();
    context.read<RegisterController>().removeListener(() {});
    super.dispose();
  }
}
