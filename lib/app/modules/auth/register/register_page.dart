import 'package:flutter/material.dart';
import 'package:todo_list_provider_project/app/core/ui/theme_extensions.dart';
import 'package:todo_list_provider_project/app/core/widgets/todo_list_field.dart';
import 'package:todo_list_provider_project/app/core/widgets/todo_list_logo.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({Key? key}) : super(key: key);

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
                child: Column(
              children: [
                TodoListField(label: 'E-mail'),
                const SizedBox(height: 20),
                TodoListField(label: "Senha", obscureText: true),
                const SizedBox(height: 20),
                TodoListField(label: "Confirma senha", obscureText: true),
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.bottomRight,
                  child: ElevatedButton(
                    onPressed: () {},
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
}
