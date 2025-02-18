// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloc/bloc.dart';

import 'package:zelio_social/chat/model/chat_model.dart';
import 'package:zelio_social/chat/service/group_chat_service.dart';
import 'package:zelio_social/model/result.dart';

class GroupChatCubit extends Cubit<Result<GroupState>> {
  final GroupChatService _groupChatService;
  GroupChatCubit(this._groupChatService) : super(Result(isLoading: false));

  Future<void> createGroupChats(
      String? groupName, List<String>? particpantsList) async {
    try {
      emit(Result(isLoading: true));
      final groupChat = await _groupChatService.createGroupChat(
          groupName: groupName, particpantsList: particpantsList);
      emit(Result(data: GroupState(event: GroupEvent.add, model: groupChat)));
    } catch (e) {
      emit(Result(error: e.toString()));
      rethrow;
    }
  }

  Future<void> addParticipant(String? chatId, String? participantId) async {
    try {
      emit(Result(isLoading: true));
      final participant = await _groupChatService.addParticpantInGroup(
          chatId: chatId, participantId: participantId);
      emit(Result(
          data: GroupState(
              model: participant, event: GroupEvent.addParticipant)));
    } catch (e) {
      emit(Result(error: e.toString()));
      rethrow;
    }
  }
  Future<void> removeParticipant(String? chatId, String? participantId) async {
    try {
      emit(Result(isLoading: true));
      final participant = await _groupChatService.removeParticpantInGroup(
          chatId: chatId, participantId: participantId);
      emit(Result(
          data: GroupState(
              model: participant, event: GroupEvent.removeParticipant)));
    } catch (e) {
      emit(Result(error: e.toString()));
      rethrow;
    }
  }

  Future<void> updateGroupChatName(String? chatId, String? name) async{
    try {
      emit(Result(isLoading: true));
      final updatedName = await _groupChatService.updateGroupName(chatId: chatId,name: name);
      emit(Result(data: GroupState(model: updatedName, event: GroupEvent.updateName)));
    } catch (e) {
      emit(Result(error: e.toString()));
    }
  }

  Future<void> deleteGroup(String? chatId) async {
    try {
      emit(Result(isLoading: true));
      final delte = await _groupChatService.deleteGroupChat(chatId: chatId);
      emit(Result(data: GroupState(event: GroupEvent.delte, model: delte)));
    } catch (e) {
      emit(Result(error: e.toString()));
      rethrow;
    }
  }

  

  Future<void> leaveGroup(String? chatId) async {
    try {
      emit(Result(isLoading: true));
      final delte = await _groupChatService.leaveGroupChat(chatId: chatId);
      emit(Result(data: GroupState(event: GroupEvent.leave, model: delte)));
    } catch (e) {
      emit(Result(error: e.toString()));
      rethrow;
    }
  }
}

class GroupState {
  GroupEvent event;
  ChatModel model;
  GroupState({
    required this.event,
    required this.model,
  });
}

enum GroupEvent { add, delte, leave, addParticipant, removeParticipant, updateName}
