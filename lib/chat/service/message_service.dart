import 'dart:io';

import 'package:dio/dio.dart';
import 'package:zelio_social/chat/model/add_message_model.dart';
import 'package:zelio_social/services/dio_exceptions.dart';
import 'package:zelio_social/services/dio_instance.dart';

class MessageService {
  MessageService();

  Future<List<MessageModel>> getAllMessages({String? chatId}) async {
    try {
      final response =
          await DioSingleton.instance.dio.get("chat-app/messages/${chatId}");
      final body = response.data;
      final List<dynamic> jsonResponse = body['data'];
      return jsonResponse.map((e) => MessageModel.fromJson(e)).toList();
    } catch (e) {
      print("Error getting messages : ${e.toString()}");
      rethrow;
    }
  }

  Future<MessageModel> addMessage(
      {String? chatId, String? content, List<File>? images}) async {
    Map<String, dynamic> data = {};

    final image = await Future.wait(
        images!.map((e) => MultipartFile.fromFile(e.path)).toList());

    data["images"] = image;

    try {
      final response = await DioSingleton.instance.dio.post(
        "chat-app/messages/${chatId}",
        data: FormData.fromMap(data),
      );
      final body = response.data;
      return MessageModel.fromJson(body["data"]);
    } on DioException catch (e) {
      print("Error while adding message : $e");
      throw DioExceptions.fromDioError(e);
    }
  }
}
