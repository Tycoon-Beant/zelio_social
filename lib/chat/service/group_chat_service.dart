import 'package:dio/dio.dart';
import 'package:zelio_social/chat/model/chat_model.dart';
import 'package:zelio_social/services/dio_instance.dart';

class GroupChatService {
  GroupChatService() {
    getGroupChatDetail();
  }

  Future<ChatModel> getGroupChatDetail({String? chatId}) async {
    try {
      final response = await DioSingleton.instance.dio
          .get("/chat-app/chats/group/${chatId}");
      final body = response.data;
      return ChatModel.fromJson(body["data"]);
    } on DioException catch (e) {
      print("Error: $e");
      rethrow;
    }
  }

  Future<ChatModel> addParticpantInGroup(
      {String? chatId, String? participantId}) async {
    try {
      final response = await DioSingleton.instance.dio
          .post("chat-app/chats/group/${chatId}/${participantId}");
      final body = response.data;
      return ChatModel.fromJson(body["data"]);
    } catch (e) {
      print("Error: ${e.toString()}");
      rethrow;
    }
  }
  Future<ChatModel> removeParticpantInGroup(
      {String? chatId, String? participantId}) async {
    try {
      final response = await DioSingleton.instance.dio
          .delete("chat-app/chats/group/${chatId}/${participantId}");
      final body = response.data;
      return ChatModel.fromJson(body["data"]);
    } catch (e) {
      print("Error: ${e.toString()}");
      rethrow;
    }
  }

  Future<ChatModel> updateGroupName({String? chatId, String? name}) async {
    try {
      final response = await DioSingleton.instance.dio
          .patch("chat-app/chats/group/${chatId}", data: {"name": name});
      final body = response.data;
      return ChatModel.fromJson(body['data']);
    } catch (e) {
      print("Error: ${e.toString()}");
      rethrow;
    }
  }

  Future<ChatModel> createGroupChat(
      {String? groupName, List<String>? particpantsList}) async {
    try {
      final response =
          await DioSingleton.instance.dio.post("chat-app/chats/group", data: {
        "name": groupName,
        "participants": particpantsList,
      });
      final body = response.data;
      return ChatModel.fromJson(body["data"]);
    } on DioException catch (e) {
      print("Error in creating group: $e");
      rethrow;
    }
  }

  Future<ChatModel> deleteGroupChat({String? chatId}) async {
    try {
      final response = await DioSingleton.instance.dio
          .delete("chat-app/chats/group/${chatId}");
      final body = response.data;
      return ChatModel.fromJson(body["data"]);
    } catch (e) {
      print("Error in deleting : ${e.toString()}");
      rethrow;
    }
  }

  Future<ChatModel> leaveGroupChat({String? chatId}) async {
    try {
      final response = await DioSingleton.instance.dio
          .delete("chat-app/chats/leave/group/${chatId}");
      final body = response.data;
      return ChatModel.fromJson(body["data"]);
    } catch (e) {
      print("Error in deleting : ${e.toString()}");
      rethrow;
    }
  }
}
