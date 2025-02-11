import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zelio_social/chat/cubit/meassge_list_cubit.dart';
import 'package:zelio_social/chat/model/add_message_model.dart';
import 'package:zelio_social/chat/model/chat_model.dart';
import 'package:zelio_social/config/common.dart';
import 'package:zelio_social/model/result.dart';
import 'package:zelio_social/services/local_storage_service.dart';
import 'package:zelio_social/social/auth/model/login_model.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key, this.chatModel});
  final ChatModel? chatModel;
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  User? currentUser;
  final TextEditingController _messageController = TextEditingController();
  List<Map<String, dynamic>> chatList = [];
  // Function to add a new message
  void _addMessage() {
    final String newMessage = _messageController.text.trim();

    if (newMessage.isNotEmpty) {
      setState(() {
        chatList.add({"user": "sender", "message": newMessage});
        _messageController.clear(); // Clear the text field
      });
    }
  }

  @override
  void initState() {
    currentUser = context.read<LocalStorageService>().getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MessageListCubit(context.read()),
      child: Scaffold(
        appBar: AppBar(
          title: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.white,
                  foregroundColor: Color(0xff128C7E),
                  radius: 20,
                  backgroundImage:
                      AssetImage("assets/social_media/profile2.png"),
                ),
                const SizedBox(width: 10),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(
                    widget.chatModel?.chatTitle(currentUser?.id) ?? 'User',
                    style: context.theme.titleMedium!.copyWith(
                        fontFamily: FontFamily.w700,
                        color: context.colorScheme.primary),
                  ),
                  Text("@snowmichael09",
                      style: context.theme.bodyMedium!
                          .copyWith(color: Colors.grey))
                ])
              ],
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              BlocBuilder<MessageListCubit, Result<List<MessageModel>>>(
                builder: (context, state) {
                  final message = state.data ?? [];
                  return message.isEmpty
                      ? Center(
                          child: Text(
                              "please send some message to start converstion!"),
                        )
                      : BuildChatBubble(
                          chat: message,
                        );
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _messageController,
                decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color.fromARGB(255, 236, 233, 233),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none),
                    hintText: "Type message here!....",
                    hintStyle:
                        context.theme.bodySmall!.copyWith(color: Colors.grey),
                    prefixIcon: Icon(
                      Icons.emoji_emotions_outlined,
                      color: Colors.black,
                    ),
                    suffixIcon: IconButton(
                        onPressed: _addMessage,
                        icon: Icon(
                          Icons.send_outlined,
                          color: context.colorScheme.primary,
                        ))),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class BuildChatBubble extends StatelessWidget {
  final List<MessageModel> chat;
  const BuildChatBubble({super.key, required this.chat});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.separated(
        itemCount: chat.length,
        reverse: true,
        itemBuilder: (BuildContext context, int index) {
          final String user = chat[index].sender?.username as String;
          final String message = chat[index].content as String;
          final currentUser = context.read<LocalStorageService>().getUser();
          return Row(
            mainAxisAlignment: user == currentUser?.username
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: user == currentUser?.username
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                children: [
                  Text(
                    "$user: ",
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(color: Colors.grey),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: user == currentUser?.username
                            ? Colors.blue
                            : const Color.fromARGB(255, 213, 212, 212),
                        borderRadius: user == currentUser?.username
                            ? BorderRadius.only(
                                topLeft: Radius.circular(20),
                                bottomLeft: Radius.circular(20),
                                bottomRight: Radius.circular(20))
                            : BorderRadius.only(
                                topRight: Radius.circular(20),
                                bottomLeft: Radius.circular(20),
                                bottomRight: Radius.circular(20))),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        message,
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color:
                                user == currentUser?.username ? Colors.white : Colors.black),
                      ),
                    ),
                  ),
                ],
              )
            ],
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return const SizedBox(height: 8);
        },
      ),
    );
  }
}



// class BuildChatBubble extends StatelessWidget {
//   final List<MessageModel> chat;
//   const BuildChatBubble({super.key, required this.chat});

//   @override
//   Widget build(BuildContext context) {
//     return Expanded(
//       child: ListView.separated(
//         itemCount: chat.length,
//         reverse: true,
//         itemBuilder: (BuildContext context, int index) {
//           final String user = chat[index].["user"]};
//           final String message = chat[index]["message"] as String;
//           return Row(
//             mainAxisAlignment: user == "sender"
//                 ? MainAxisAlignment.end
//                 : MainAxisAlignment.start,
//             children: [
//               Column(
//                 crossAxisAlignment: user == "sender"
//                     ? CrossAxisAlignment.end
//                     : CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     "$user: ",
//                     style: Theme.of(context)
//                         .textTheme
//                         .bodySmall!
//                         .copyWith(color: Colors.grey),
//                   ),
//                   Container(
//                     decoration: BoxDecoration(
//                         color: user == "sender"
//                             ? Colors.blue
//                             : const Color.fromARGB(255, 213, 212, 212),
//                         borderRadius: user == "sender"
//                             ? BorderRadius.only(
//                                 topLeft: Radius.circular(20),
//                                 bottomLeft: Radius.circular(20),
//                                 bottomRight: Radius.circular(20))
//                             : BorderRadius.only(
//                                 topRight: Radius.circular(20),
//                                 bottomLeft: Radius.circular(20),
//                                 bottomRight: Radius.circular(20))),
//                     child: Padding(
//                       padding: const EdgeInsets.all(16),
//                       child: Text(
//                         message,
//                         style: Theme.of(context).textTheme.bodyMedium!.copyWith(
//                             color:
//                                 user == "sender" ? Colors.white : Colors.black),
//                       ),
//                     ),
//                   ),
//                 ],
//               )
//             ],
//           );
//         },
//         separatorBuilder: (BuildContext context, int index) {
//           return const SizedBox(height: 8);
//         },
//       ),
//     );
//   }
// }
