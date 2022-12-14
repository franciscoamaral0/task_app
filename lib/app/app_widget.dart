import 'package:flutter/material.dart';

import 'package:todo_list_provider_project/app/core/database/sql_adm_connection.dart';
import 'package:todo_list_provider_project/app/core/navigator/todo_list_navigator.dart';
import 'package:todo_list_provider_project/app/core/ui/todo_list_ui_config.dart';
import 'package:todo_list_provider_project/app/modules/auth/auth_module.dart';
import 'package:todo_list_provider_project/app/modules/home/home_module.dart';
import 'package:todo_list_provider_project/app/modules/splash/splash_page.dart';

class AppWidget extends StatefulWidget {
  const AppWidget({Key? key}) : super(key: key);

  @override
  State<AppWidget> createState() => _AppWidgetState();
}

class _AppWidgetState extends State<AppWidget> {
  SqlAdmConnection sqlAdmConnection = SqlAdmConnection();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(sqlAdmConnection);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(sqlAdmConnection);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Todo List Provider",
      theme: TodoListUiConfig.theme,
      navigatorKey: TodoListNavigator.navigatorKey,
      routes: {
        ...AuthModule().routers,
        ...HomeModule().routers,
      },
      home: const SplashPage(),
    );
  }
}
