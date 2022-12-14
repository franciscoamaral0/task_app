import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list_provider_project/app/auth/auth_provider.dart';
import 'package:todo_list_provider_project/app/modules/home/widgets/home_drawer.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: HomeDrawer(),
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: Center(
        child: TextButton(
          onPressed: () {
            context.read<AuthProvider>().logout();
          },
          child: Text("Logout"),
        ),
      ),
    );
  }
}
