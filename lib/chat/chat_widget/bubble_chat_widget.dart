import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zelio_social/chat/cubit/select_message_cubit.dart';
import 'package:zelio_social/chat/model/message_model.dart';
import 'package:zelio_social/services/local_storage_service.dart';

class BuildChatBubble extends StatelessWidget {
  final List<MessageModel> chat;
  final bool isTyping;

  const BuildChatBubble({
    super.key,
    required this.chat,
    required this.isTyping,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.separated(
        itemCount: chat.length + 1,
        reverse: true,
        itemBuilder: (BuildContext context, int index) {
          final currentUser = context.read<LocalStorageService>().getUser();
          if (index == 0) {
            if (isTyping) {
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(20),
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        "Typing...",
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(color: Colors.black),
                      ),
                    ),
                  ),
                ],
              );
            } else {
              return SizedBox.shrink();
            }
          }

          final String user = chat[index - 1].sender?.username ?? '';
          final String message = chat[index - 1].content ?? '';
          final bool isCurrentUser = user == currentUser?.username;
          final messageId = chat[index - 1].id;

          return InkWell(
            onTap: () =>
                context.read<SelectMessageCubit>().deSelectMessages(messageId!),
            onLongPress: () =>
                context.read<SelectMessageCubit>().selecteMessages(messageId!),
            child: Stack(
              children: [
                Align(
                  alignment: isCurrentUser
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: isCurrentUser
                      ? CurrentUserMessageBubble(message: message)
                      : UserMessageBubble(user: user, message: message),
                ),
                BlocBuilder<SelectMessageCubit, SelectMessageState>(
                  builder: (context, state) {
                    if (state.isSelected(messageId!)) {
                      return Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.blue.shade100.withOpacity(0.3),
                          ),
                        ),
                      );
                    } else {
                      return SizedBox.shrink();
                    }
                  },
                )
              ],
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return const SizedBox(height: 8);
        },
      ),
    );
  }
}

class UserMessageBubble extends StatelessWidget {
  final String user;
  final String message;

  const UserMessageBubble({
    required this.user,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 20),
      child: SizedBox(
        width: MediaQuery.sizeOf(context).width / 1.6,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "$user ",
              style: Theme.of(context)
                  .textTheme
                  .bodySmall!
                  .copyWith(color: Colors.grey),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color.fromARGB(255, 239, 238, 238),
                    offset: Offset(1, 1),
                    spreadRadius: 2,
                    blurRadius: 2,
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  message,
                  maxLines: 4,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(color: Colors.black),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CurrentUserMessageBubble extends StatelessWidget {
  final String message;

  const CurrentUserMessageBubble({
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 20),
      child: SizedBox(
        width: MediaQuery.sizeOf(context).width / 1.6,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              "you",
              style: Theme.of(context)
                  .textTheme
                  .bodySmall!
                  .copyWith(color: Colors.grey),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color.fromARGB(255, 239, 238, 238),
                    offset: Offset(1, 1),
                    spreadRadius: 2,
                    blurRadius: 2,
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  message,
                  maxLines: 4,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
