import 'package:flutter/material.dart';

double getPercentScreenHeigth(BuildContext context, double percent){
  final screenSize = MediaQuery.of(context).size;
  return screenSize.height * percent;
}

double getPercentScreenWidth(BuildContext context, double percent){
  final screenSize = MediaQuery.of(context).size;
  return screenSize.width * percent;
}