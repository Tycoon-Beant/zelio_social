import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:zelio_social/chat/model/message_model.dart';
import 'package:zelio_social/chat/service/message_service.dart';
import 'package:zelio_social/config/common.dart';
import 'package:zelio_social/model/result.dart';
import 'package:zelio_social/services/socket_service.dart';

class MessageListCubit extends Cubit<Result<ChatState>> {
  final MessageService _messageService;
  final SocketService _socketService;
  Timer? _debounce;

  MessageListCubit(this._messageService, this._socketService)
      : super(Result(isLoading: true)) {
    _socketService.on(SocketEvents.typing.event, (_) {
      emit(Result(data: state.data?.copyWith(isTyping: true)));
    });
    _socketService.on(SocketEvents.stopTyping.event, (_) {
      emit(Result(data: state.data?.copyWith(isTyping: false)));
    });
    _socketService.on(SocketEvents.messageReceived.event, (data) {
      final message = MessageModel.fromJson(data);
      emit(
        Result(
          data: ChatState(
            messageList: [message, ...state.data?.messageList ?? []],
          ),
        ),
      );
    });
  }
  void addMessage(MessageModel message) {
    emit(
      Result(
        data: ChatState(
          messageList: [message, ...state.data?.messageList ?? []],
        ),
      ),
    );
  }

  Future<void> getMessages(String chatId) async {
    _socketService.emit(SocketEvents.joinChat.event, chatId);
    try {
      emit(Result(isLoading: true));
      final message = await _messageService.getAllMessages(chatId: chatId);
      emit(Result(data: ChatState(messageList: message)));
    } catch (e) {
      emit(Result(error: e.toString()));
      rethrow;
    }
  }

  void emitIsTyping(String? value, String? chatId) {
    _socketService.emit(SocketEvents.typing.event, chatId);

    _debounce?.cancel();

    _debounce = Timer(Duration(seconds: 1), () {
      _socketService.emit(SocketEvents.stopTyping.event, chatId);
    });
  }

  void stopTyping(String? chatId) {
    _socketService.emit(SocketEvents.stopTyping.event, chatId);
  }

  @override
  Future<void> close() {
    _socketService.off(SocketEvents.messageReceived.event);
    _socketService.off(SocketEvents.typing.event);
    _socketService.off(SocketEvents.stopTyping.event);
    return super.close();
  }
}

class ChatState {
  final List<MessageModel> messageList;
  final bool isTyping;

  ChatState({required this.messageList, this.isTyping = false});

  ChatState copyWith({List<MessageModel>? messageList, bool? isTyping}) {
    return ChatState(
      messageList: messageList ?? this.messageList,
      isTyping: isTyping ?? this.isTyping,
    );
  }
}
