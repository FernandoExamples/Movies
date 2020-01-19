import 'package:flutter/material.dart';
import 'package:movies/src/routes/routes.dart';
 
void main() => runApp(MyApp());
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      routes: getRoutes(),
      initialRoute: "home",
    );
  }
}