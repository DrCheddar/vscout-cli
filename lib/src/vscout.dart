import 'package:flutter/material.dart';
import './views/initial_profile_view.dart';
import './views/vscout_view.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import './themes.dart';
import './views/vscout_list_view.dart';
import 'package:vscout/database.dart';
import 'dart:async';
import 'package:vscout/src/database/filterHandler.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
void main() async { 
  Directory appDocDir = await getApplicationDocumentsDirectory();
  String appDocPath = appDocDir.path;
  String databaseDir = appDocPath + "/database/vscout.db";
await Directory(appDocPath + "/database").create(recursive: true);
  await MainDatabaseHandler().initializeDatabase(databaseDir);
    await MainDatabaseHandler().setStore(storeName: "vscout_main");
  await FilterHandler().initializeDatabase(databaseDir);
  await FilterHandler().setStore();
  return runApp(Vscout());}

class Vscout extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    
    return DynamicTheme(
        defaultBrightness: Brightness.light,
        data: (brightness) =>
            build_light_theme().copyWith(brightness: brightness),
        themedWidgetBuilder: (context, theme) {
          return MaterialApp(
            title: 'vscout',
            theme: theme,
            darkTheme: build_dark_theme(),
            initialRoute: '/create_profile',
            routes: {
              '/': (context) => VscoutView(),
              '/create_profile': (context) => CreateProfileView(),
              '/list_view': (context) => VscoutListView(),
              
            },
          );
        });
  }
}
