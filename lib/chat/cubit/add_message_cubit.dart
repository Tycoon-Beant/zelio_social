import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:zelio_social/chat/model/add_message_model.dart';
import 'package:zelio_social/chat/service/message_service.dart';
import 'package:zelio_social/model/result.dart';


class AddMessageCubit extends Cubit<Result<MessageModel>> {
  final MessageService _messageService;
  AddMessageCubit(this._messageService) : super(Result(isLoading: false));

  Future<void> addMessage(String chatId, String content, List<File> images) async {
    try {
      emit(Result(isLoading:  true));
      final messageData = await _messageService.addMessage(chatId: chatId, content: content, images: images);
      emit(Result(data: messageData));
    } catch (e) {
      emit(Result(error: e.toString()));
    }
  }
}
