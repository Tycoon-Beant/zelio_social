import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zelio_social/chat/chat_widget/bubble_chat_widget.dart';
import 'package:zelio_social/chat/cubit/select_message_cubit.dart';
import 'package:zelio_social/chat/cubit/message_cubit.dart';
import 'package:zelio_social/chat/cubit/group_chat_cubit.dart';
import 'package:zelio_social/chat/cubit/meassge_list_cubit.dart';
import 'package:zelio_social/chat/cubit/one_to_one_chat_cubit.dart';
import 'package:zelio_social/chat/model/chat_model.dart';
import 'package:zelio_social/chat/screen/chat_list_screen.dart';
import 'package:zelio_social/chat/screen/create_group_chat_screen.dart';
import 'package:zelio_social/config/common.dart';
import 'package:zelio_social/model/result.dart';
import 'package:zelio_social/services/local_storage_service.dart';
import 'package:zelio_social/social/addpost/add_post_screen.dart';
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

  File? selectedImage;

  

  @override
  void initState() {
    currentUser = context.read<LocalStorageService>().getUser();

    super.initState();
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => SelectMessageCubit()),
        BlocProvider(
          create: (context) => MessageListCubit(context.read(), context.read())
            ..getMessages(widget.chatModel!.id!),
        ),
        BlocProvider(
          create: (context) => MessageCubit(context.read()),
        ),
        BlocProvider(
          create: (context) => GroupChatCubit(context.read()),
        ),
        BlocProvider(create: (context) => OneToOneChatCubit(context.read()))
      ],
      child: Builder(builder: (context) {
        List<Participants>? participants = widget.chatModel!.participants;
        return MultiBlocListener(
          listeners: [
            BlocListener<GroupChatCubit, Result<GroupState>>(
              listener: (context, state) {
                if (state.data != null &&
                    state.data?.event == GroupEvent.delte) {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => ChatListScreen()));
                }
                if (state.data != null &&
                    state.data?.event == GroupEvent.leave) {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => ChatListScreen()));
                }
                if (state.data != null &&
                    state.data?.event == GroupEvent.updateName) {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => ChatListScreen()));
                }
                if (state.data != null &&
                    state.data?.event == GroupEvent.removeParticipant) {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => ChatListScreen()));
                }
              },
            ),
            BlocListener<OneToOneChatCubit, Result<OneToOneChatState>>(
              listener: (context, state) {
                if (state.data != null &&
                    state.data?.events == OneToOneChatEvents.delete) {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => ChatListScreen()));
                }
              },
            ),
            
          ],
          child: Scaffold(
            appBar: AppBar(
              title: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    Builder(builder: (context) {
                      final url =
                          widget.chatModel?.chatAvatar(currentUser!.id!);
                      return CircleAvatar(
                          backgroundColor: Colors.grey,
                          radius: 20,
                          backgroundImage: switch (url) {
                            null =>
                              AssetImage('assets/social_media/3x/userIcon.png'),
                            String imageUrl => NetworkImage(imageUrl)
                          });
                    }),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.chatModel?.chatTitle(currentUser?.id) ??
                                'User',
                            style: context.theme.titleMedium!.copyWith(
                              fontFamily: FontFamily.w700,
                              color: context.colorScheme.primary,
                            ),
                          ),
                          if (widget.chatModel?.isGroupChat == true &&
                              participants != null)
                            Text(
                              widget.chatModel?.participants
                                      ?.where((e) => e.id != currentUser!.id)
                                      .map((e) => e.username!)
                                      .join(", ") ??
                                  "",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: context.theme.bodyMedium!
                                  .copyWith(color: Colors.grey),
                            )
                          else
                            Text(
                              widget.chatModel?.participants?.first.email ?? '',
                              style: context.theme.bodyMedium!
                                  .copyWith(color: Colors.grey),
                            )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: widget.chatModel?.isGroupChat == true
                      ? isGroupchatPopUpMenu()
                      : oneToOneChatPopupMenu(),
                ),
                BlocSelector<SelectMessageCubit, SelectMessageState, bool>(
                  selector: (state) => state.isEditing,
                  builder: (context, state) {
                    if (state) {
                      return IconButton(
                        onPressed: () {
                          final list = context.read<SelectMessageCubit>().state.selectedMessages;
                          context.read<MessageCubit>().deleteMessages(widget.chatModel?.id,  list.first);
                        },
                        icon: Icon(Icons.delete),
                      );
                    }
                    return SizedBox.shrink();
                  },
                )
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  BlocListener<MessageCubit, Result<MessageState>>(
                    listener: (context, state) {
                      context
                          .read<MessageListCubit>()
                          .addMessage(state.data!.model);
                      _messageController.clear();
                    },
                    child: BlocBuilder<MessageListCubit, Result<ChatState>>(
                      builder: (context, state) {
                        if (state.isLoading) {
                          return CircularProgressIndicator();
                        }
                        if (state.error != null) {
                          return Text(state.error.toString());
                        }
                        final message = state.data?.messageList ?? [];
                        return message.isEmpty
                            ? Center(
                                child: Text(
                                    "please send some message to start converstion!"),
                              )
                            : BuildChatBubble(
                                chat: message,
                                isTyping: state.data?.isTyping ?? false,
                              );
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      children: [
                        Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 220, 219, 219),
                              borderRadius: BorderRadius.circular(30)),
                          child: IconButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext bcontext) {
                                  return ImageSelection(
                                    onImageSelected: (compressedImage) {
                                      setState(() {
                                        selectedImage = compressedImage;
                                      });
                                    },
                                  );
                                },
                              );
                            },
                            icon: Icon(
                              Icons.attach_file,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        MessageTextField(
                          widget: widget,
                          messageController: _messageController,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  PopupMenuButton<String> oneToOneChatPopupMenu() {
    String? _selectedOption;
    return PopupMenuButton<String>(
      onSelected: (String value) {
        setState(() {
          _selectedOption = value;
        });
      },
      itemBuilder: (BuildContext context) => [
        PopupMenuItem(
          onTap: () {
            showDialog(
              context: context,
              builder: (BuildContext bcontext) {
                return AlertDialog(
                  content: Container(
                    height: 200,
                    width: 200,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          Text(
                            "DELETE!",
                            style: context.theme.headlineMedium!
                                .copyWith(color: Colors.red),
                          ),
                          Text(
                            "Are you sure!",
                            style: context.theme.bodyMedium!
                                .copyWith(color: Colors.grey),
                          ),
                          Spacer(),
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      const Color.fromARGB(255, 202, 22, 9),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  )),
                              onPressed: () {
                                context
                                    .read<OneToOneChatCubit>()
                                    .deleteOneToOneChat(widget.chatModel?.id);
                              },
                              child: Text(
                                "DELETE",
                                style: context.theme.titleMedium!
                                    .copyWith(color: Colors.white),
                              ))
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
          value: "Option 1",
          child: Text(
            "Delete",
            style: context.theme.titleMedium!.copyWith(
              color: Colors.red,
            ),
          ),
        ),
      ],
    );
  }

  PopupMenuButton<String> isGroupchatPopUpMenu() {
    String? _selectedOption;
    return PopupMenuButton<String>(
      onSelected: (String value) {
        setState(() {
          _selectedOption = value;
        });
      },
      itemBuilder: (BuildContext context) => [
        PopupMenuItem(
          onTap: () {
            showDialog(
              context: context,
              builder: (BuildContext bcontext) {
                final id = widget.chatModel?.id;
                final TextEditingController _groupName =
                    TextEditingController();
                _groupName.text = widget.chatModel?.name ?? '';
                return AlertDialog(
                  content: Container(
                    height: 250,
                    width: 250,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          Text(
                            "Update Group Name",
                            style: context.theme.titleLarge!
                                .copyWith(color: Colors.red),
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: _groupName,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor:
                                  const Color.fromARGB(255, 236, 233, 233),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: BorderSide.none),
                              hintText: "Type message here!....",
                              hintStyle: context.theme.bodySmall!
                                  .copyWith(color: Colors.grey),
                            ),
                          ),
                          Spacer(),
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      const Color.fromARGB(255, 42, 152, 231),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  )),
                              onPressed: () {
                                context
                                    .read<GroupChatCubit>()
                                    .updateGroupChatName(id, _groupName.text);
                              },
                              child: Text(
                                "Update",
                                style: context.theme.titleMedium!
                                    .copyWith(color: Colors.white),
                              ))
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
          value: "Option 1",
          child: Text(
            "update Group Name",
            style: context.theme.titleMedium!.copyWith(
              color: Colors.black,
            ),
          ),
        ),
        PopupMenuItem(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => CreateGroupChatScreen(
                      chatId: widget.chatModel?.id,
                      chatModel: widget.chatModel,
                      event: "add",
                    )));
          },
          value: "Option 2",
          child: Text(
            "Add Participant",
            style: context.theme.titleMedium!.copyWith(
              color: Colors.black,
            ),
          ),
        ),
        PopupMenuItem(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => CreateGroupChatScreen(
                      chatId: widget.chatModel?.id,
                      chatModel: widget.chatModel,
                      event: "remove",
                    )));
          },
          value: "Option 3",
          child: Text(
            "Remove Participant",
            style: context.theme.titleMedium!.copyWith(
              color: Colors.black,
            ),
          ),
        ),
        PopupMenuItem(
          onTap: () {
            showDialog(
              context: context,
              builder: (BuildContext bcontext) {
                return AlertDialog(
                  content: Container(
                    height: 200,
                    width: 200,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          Text(
                            "Leave Group!",
                            style: context.theme.headlineMedium!
                                .copyWith(color: Colors.red),
                          ),
                          Text(
                            "Are you sure!",
                            style: context.theme.bodyMedium!
                                .copyWith(color: Colors.grey),
                          ),
                          Spacer(),
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      const Color.fromARGB(255, 42, 152, 231),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  )),
                              onPressed: () {
                                context
                                    .read<GroupChatCubit>()
                                    .leaveGroup(widget.chatModel?.id);
                              },
                              child: Text(
                                "Leave",
                                style: context.theme.titleMedium!
                                    .copyWith(color: Colors.white),
                              ))
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
          value: "Option 4",
          child: Text(
            "Leave Group",
            style: context.theme.titleMedium!.copyWith(
              color: Colors.black,
            ),
          ),
        ),
        PopupMenuItem(
          onTap: () {
            showDialog(
              context: context,
              builder: (BuildContext bcontext) {
                return AlertDialog(
                  content: Container(
                    height: 200,
                    width: 200,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          Text(
                            "DELETE!",
                            style: context.theme.headlineMedium!
                                .copyWith(color: Colors.red),
                          ),
                          Text(
                            "Are you sure!",
                            style: context.theme.bodyMedium!
                                .copyWith(color: Colors.grey),
                          ),
                          Spacer(),
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      const Color.fromARGB(255, 202, 22, 9),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  )),
                              onPressed: () {
                                context
                                    .read<GroupChatCubit>()
                                    .deleteGroup(widget.chatModel?.id);
                              },
                              child: Text(
                                "DELETE",
                                style: context.theme.titleMedium!
                                    .copyWith(color: Colors.white),
                              ))
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
          value: "Option 5",
          child: Text(
            "Delete",
            style: context.theme.titleMedium!.copyWith(
              color: Colors.red,
            ),
          ),
        ),
      ],
    );
  }
}



class MessageTextField extends StatelessWidget {
  const MessageTextField({
    super.key,
    required this.widget,
    required TextEditingController messageController,
  }) : _messageController = messageController;

  final ChatScreen widget;
  final TextEditingController _messageController;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 310,
      child: TextFormField(
        onChanged: (value) {
          context
              .read<MessageListCubit>()
              .emitIsTyping(value, widget.chatModel?.id);
        },
        controller: _messageController,
        decoration: InputDecoration(
          filled: true,
          fillColor: const Color.fromARGB(255, 236, 233, 233),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide.none),
          hintText: "Type message here!....",
          hintStyle: context.theme.bodySmall!.copyWith(color: Colors.grey),
          prefixIcon: Icon(
            Icons.emoji_emotions_outlined,
            color: Colors.black,
          ),
          suffixIcon: InkWell(
            onTap: () {
              context.read<MessageListCubit>().stopTyping(widget.chatModel?.id);
              context.read<MessageCubit>().addMessage(
                    chatId: widget.chatModel!.id!,
                    content: _messageController.text,
                  );
            },
            child: Icon(
              Icons.send_outlined,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
