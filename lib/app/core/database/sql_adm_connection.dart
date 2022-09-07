import 'package:flutter/cupertino.dart';
import 'package:todo_list_provider_project/app/core/database/sqlite_connection_factory.dart';

class SqlAdmConnection with WidgetsBindingObserver {
  final connectionDatabase = SqliteConnectionFactory();
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
        connectionDatabase.closeConnection();
        break;
    }
    super.didChangeAppLifecycleState(state);
  }
}
