
import 'package:bloc/bloc.dart';
import 'package:zelio_social/chat/model/add_message_model.dart';
import 'package:zelio_social/chat/service/message_service.dart';
import 'package:zelio_social/model/result.dart';

class MessageListCubit extends Cubit<Result<List<MessageModel>>> {
  final MessageService _messageService;
  MessageListCubit(this._messageService) : super(Result(isLoading: true)){

  }

  Future<void> getMessages(String chatId) async {
    try {
      emit(Result(isLoading: true));
      final message = await _messageService.getAllMessages(chatId: chatId);
      emit(Result(data: message));
    } catch (e) {
      emit(Result(error: e.toString()));
      rethrow;
    }
  }


}
