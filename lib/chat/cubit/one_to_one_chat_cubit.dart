// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloc/bloc.dart';

import 'package:zelio_social/chat/model/chat_model.dart';
import 'package:zelio_social/chat/service/chat_service.dart';
import 'package:zelio_social/model/result.dart';

class OneToOneChatCubit extends Cubit<Result<OneToOneChatState>> {
  final ChatService _chatListService;
  OneToOneChatCubit(this._chatListService) : super(Result(isLoading: false));

  Future<void> createOneOnOneChat({String? receiverId}) async{
    try {
      emit(Result(isLoading: true));
      final chatDetail = await _chatListService.createOneToOneChat(receiverId:receiverId );
      emit(Result(data: OneToOneChatState(model:  chatDetail, events: OneToOneChatEvents.add)));
    } catch (e) {
      emit(Result(error: e.toString()));
      rethrow;
    }
  }

Future<void> deleteOneToOneChat(String? chatId) async{
    try {
      emit(Result(isLoading: true));
      final delte = await _chatListService.deleteOneToOneChat(chatId: chatId);
      emit(Result(data: OneToOneChatState(model: delte, events: OneToOneChatEvents.delete)));
    } catch (e) {
      emit(Result(error: e.toString()));
      rethrow;
    }
  }


}

class OneToOneChatState {
  OneToOneChatEvents events;
  ChatModel model;
  OneToOneChatState({
    required this.events,
    required this.model,
  });
}

enum OneToOneChatEvents { add, delete}