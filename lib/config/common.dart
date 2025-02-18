import 'package:flutter/material.dart';

String imageBaseUrl = "http://192.168.1.20:8080/";
String baseUrl = "${imageBaseUrl}api/v1/";
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
  updateGroupName(event: "updateGroupName"),
  typing(event: "typing"),
  stopTyping(event: "stopTyping"),
  messageReceived(event: "messageReceived"),
  leaveChat(event : "leaveChat");


  final String event;

  const SocketEvents({required this.event});
}