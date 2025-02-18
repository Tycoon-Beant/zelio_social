// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:bloc/bloc.dart';

import 'package:zelio_social/chat/model/message_model.dart';
import 'package:zelio_social/chat/service/message_service.dart';
import 'package:zelio_social/model/result.dart';

class MessageCubit extends Cubit<Result<MessageState>> {
  final MessageService _messageService;
  MessageCubit(this._messageService) : super(Result(isLoading: false));

  Future<void> addMessage(
      {required String chatId,
      required String content,
      List<File>? images}) async {
    try {
      emit(Result(isLoading: true));
      final messageData = await _messageService.addMessage(
          chatId: chatId, content: content, images: images);
      emit(Result(data: MessageState(model: messageData, event: MessageEvent.add)));
    } catch (e) {
      emit(Result(error: e.toString()));
    }
  }


  Future<void> deleteMessages(String? chatId, String? messageId) async {
    try {
      emit(Result(isLoading: true));
      final delte = await _messageService.deleteMessage(chatId: chatId, messageId: messageId);
      emit(Result(data: MessageState(event: MessageEvent.delete, model: delte)));
    } catch (e) {
      emit(Result(error: e.toString()));
      rethrow;
    }
  }
}

class MessageState {
  MessageEvent event;
  MessageModel model;
  MessageState({
    required this.event,
    required this.model,
  });
}

enum MessageEvent{ add, delete}