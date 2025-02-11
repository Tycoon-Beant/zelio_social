import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zelio_social/chat/model/chat_model.dart';
import 'package:zelio_social/chat/service/chat_service.dart';
import 'package:zelio_social/config/common.dart';
import 'package:zelio_social/model/result.dart';
import 'package:zelio_social/services/socket_service.dart';
 
class ChatlistCubit extends Cubit<Result<List<ChatModel>>> {
  final ChatService _chatListService;
  final SocketService _socketService;
  ChatlistCubit(this._chatListService, this._socketService) : super(Result(isLoading: true)) {
    getUserChatList();
    // _socketService.emit(SocketEvents.joinChat.event, )
    _socketService.on(SocketEvents.newChat.event, (data){
      final chat = ChatModel.fromJson(data);
      emit(Result(data: [...state.data ?? [], chat]));
    });
    _socketService.on(SocketEvents.leaveChat.event, (data){
      final chat = ChatModel.fromJson(data);
      emit(Result(data: state.data?.where((e) => e.id != chat.id).toList()));
    });
  }
 
  Future<void> getUserChatList() async {
    try {
      emit(Result(isLoading: true));
      final userChatListDetail = await _chatListService.getUserChatList();
      emit(Result(data: userChatListDetail));
    } catch (e) {
      emit(Result(error: e.toString()));
    }
  }
}