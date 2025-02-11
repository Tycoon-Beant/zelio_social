import 'package:flutter/material.dart';

String imageBaseUrl = "http://192.168.1.6:8080/";
String baseUrl = "http://192.168.1.6:8080/api/v1/";
abstract class FontFamily {
  static String get w700 => "NunitoSans_10pt_Bold";
  static String get w800 => "NunitoSans_10pt_Black";
  static String get w500 => "NunitoSans_10pt_Medium";
  static String get w400 => "NunitoSans_10pt_Regular";
  static String get w300 => "NunitoSans_10pt_Light";
}

extension ThemeGetter on BuildContext {
  TextTheme get theme => Theme.of(this).textTheme;
   ColorScheme get colorScheme => Theme.of(this).colorScheme;
}


enum SocketEvents{
  newChat(event : "newChat"),
  joinChat(event: "joinChat"),
  leaveChat(event : "leaveChat");


  final String event;

  const SocketEvents({required this.event});
}