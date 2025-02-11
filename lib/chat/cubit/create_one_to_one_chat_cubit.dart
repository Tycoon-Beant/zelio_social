import 'package:bloc/bloc.dart';
import 'package:zelio_social/chat/model/chat_model.dart';
import 'package:zelio_social/chat/service/chat_service.dart';
import 'package:zelio_social/model/result.dart';

class CreateOneToOneChatCubit extends Cubit<Result<ChatModel>> {
  final ChatService _chatListService;
  CreateOneToOneChatCubit(this._chatListService) : super(Result(isLoading: false));

  Future<void> createOneOnOneChat({String? receiverId}) async{
    try {
      emit(Result(isLoading: true));
      final chatDetail = await _chatListService.createOneToOneChat(receiverId:receiverId );
      emit(Result(data: chatDetail));
    } catch (e) {
      emit(Result(error: e.toString()));
      rethrow;
    }
  }
}
