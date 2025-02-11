import 'package:dio/dio.dart';
import 'package:zelio_social/chat/model/chat_model.dart';
import 'package:zelio_social/services/dio_instance.dart';

class ChatService {
  ChatService() {
    getUserChatList();
  }

  Future<List<ChatModel>> getUserChatList() async {
    try {
      final response = await DioSingleton.instance.dio.get("chat-app/chats");
      final body = response.data;
      final List<dynamic> jsonResponse = body['data'];
      return jsonResponse.map((e) => ChatModel.fromJson(e)).toList();
    } on DioException catch (e) {
      print("Error: $e");
      rethrow;
    }
  }

  Future<ChatModel> createOneToOneChat({String? receiverId}) async {
    try {
      final response = await DioSingleton.instance.dio
          .post("chat-app/chats/c/${receiverId}");
      final body = response.data;
      return ChatModel.fromJson(body["data"]);
    } catch (e) {
      print("Error while creating one to one chat : ${e.toString()}");
      rethrow;
    }
  }
}
