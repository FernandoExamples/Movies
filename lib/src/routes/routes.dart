import 'package:flutter/material.dart';
import 'package:movies/src/pages/details_page.dart';
import 'package:movies/src/pages/home_page.dart';

Map getRoutes(){
  return <String, WidgetBuilder>{
    "home" : (context) => HomePage(),
    "details" : (context) => DetailsPage(),
  };
}