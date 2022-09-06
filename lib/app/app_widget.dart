import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:todo_list_provider_project/app/core/database/sql_adm_connection.dart';
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
    return const MaterialApp(
      title: "Todo List Provider",
      home: SplashPage(),
    );
  }
}
