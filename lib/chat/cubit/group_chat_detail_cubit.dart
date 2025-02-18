

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zelio_social/chat/model/chat_model.dart';
import 'package:zelio_social/chat/service/group_chat_service.dart';
import 'package:zelio_social/model/result.dart';

class GroupChatDetailCubit extends Cubit<Result<ChatModel>> {
  final GroupChatService _groupChatService;
  GroupChatDetailCubit(this._groupChatService) : super(Result(isLoading: true));

  Future<void> getGroupChatInfo(String? chatId) async {
    try {
      emit(Result(isLoading: true));
      final userChatListDetail = await _groupChatService.getGroupChatDetail(chatId: chatId);
      emit(Result(data: userChatListDetail));
    } catch (e) {
      emit(Result(error: e.toString()));
    }
  }

  Future<void> updateGroupName(String? chatId) async {
    try {
      emit(Result(isLoading: true));
      final userChatListDetail = await _groupChatService.getGroupChatDetail(chatId: chatId);
      emit(Result(data: userChatListDetail));
    } catch (e) {
      emit(Result(error: e.toString()));
    }
  }
}
