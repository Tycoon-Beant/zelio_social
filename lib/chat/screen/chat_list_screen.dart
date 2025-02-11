import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_swipe_action_cell/flutter_swipe_action_cell.dart';
import 'package:zelio_social/Widgets/async_widget.dart';
import 'package:zelio_social/chat/cubit/chat_list_cubit.dart';
import 'package:zelio_social/chat/cubit/create_one_to_one_chat_cubit.dart';
import 'package:zelio_social/chat/cubit/meassge_list_cubit.dart';
import 'package:zelio_social/chat/model/chat_model.dart';
import 'package:zelio_social/config/common.dart';
import 'package:zelio_social/chat/screen/chat_screen.dart';
import 'package:zelio_social/services/local_storage_service.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

List msgCount = ["3", "1", "4", "2", "", "", "3", "1", "4", "2", "", ""];

class _ChatListScreenState extends State<ChatListScreen> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => CreateOneToOneChatCubit(context.read()),
        ),
        BlocProvider(
          create: (context) => MessageListCubit(context.read()),
        ),
      ],
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              "Chats",
              style: context.theme.headlineMedium!
                  .copyWith(fontFamily: FontFamily.w700),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 20),
                child: Icon(Icons.more_vert),
              )
            ],
          ),
          body: Expanded(
            child: AsyncWidget<ChatlistCubit, List<ChatModel>>(
              data: (chatList) {
                return ListView.separated(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  itemCount: chatList?.length ?? 0,
                  itemBuilder: (BuildContext context, int index) {
                    final chat = chatList?[index];
                    final currentUser =
                        context.read<LocalStorageService>().getUser();
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          SwipeActionCell(
                            key: ObjectKey(chatList?[index]),
                            trailingActions: <SwipeAction>[
                              SwipeAction(
                                  color: Colors.white,
                                  icon: Icon(
                                    Icons.delete_outline,
                                    color: Colors.red,
                                  ),
                                  onTap: (CompletionHandler handler) async {
                                    deleteSheet(context, index);
                                  })
                            ],
                            child: InkWell(
                              onTap: () {
                                context
                                    .read<MessageListCubit>()
                                    .getMessages(chat.id!);
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => ChatScreen(
                                      chatModel: chat,
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20)),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: Colors.grey,
                                      foregroundColor: Color(0xff128C7E),
                                      radius: 25,
                                      backgroundImage: NetworkImage(
                                        chat!.participants?.first.avatar!
                                                .localPath ??
                                            '',
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                              chat?.chatTitle(
                                                      currentUser!.id!) ??
                                                  "N/A",
                                              style: context.theme.titleMedium!
                                                  .copyWith(
                                                      fontFamily:
                                                          FontFamily.w700)),
                                          Text("start conversation....",
                                              overflow: TextOverflow.ellipsis,
                                              style: context.theme.bodySmall!
                                                  .copyWith(
                                                      color: Colors.grey,
                                                      fontFamily:
                                                          FontFamily.w400))
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 20),
                                    // if (int.tryParse(msgCount[index]) != null)
                                    //   Column(
                                    //     crossAxisAlignment:
                                    //         CrossAxisAlignment.end,
                                    //     mainAxisAlignment:
                                    //         MainAxisAlignment.end,
                                    //     children: [
                                    //       Container(
                                    //         height: 20,
                                    //         width: 20,
                                    //         decoration: BoxDecoration(
                                    //           color: Colors.blue,
                                    //           borderRadius:
                                    //               BorderRadius.circular(20),
                                    //         ),
                                    //         child: Center(
                                    //           child: Text(
                                    //             msgCount[index],
                                    //             style: TextStyle(
                                    //                 color: Colors.white),
                                    //           ),
                                    //         ),
                                    //       ),
                                    //     ],
                                    //   )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return SizedBox(
                      height: 10,
                    );
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Future<dynamic> deleteSheet(BuildContext context, int index) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(20),
          height: 400,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.warning_amber_rounded,
                  color: const Color.fromARGB(255, 137, 15, 6),
                  size: 80,
                ),
                Spacer(),
                Text(
                  "Delete Chat?",
                  style: context.theme.headlineSmall!.copyWith(
                    fontFamily: FontFamily.w800,
                  ),
                ),
                Spacer(),
                const Text(
                  "All the messages will be deleted permanently and can't be restored, are you sure?",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),
                const Spacer(),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      fixedSize: Size(MediaQuery.sizeOf(context).width, 50)),
                  onPressed: () {
                    setState(() {
                      // profileimg.removeAt(index);
                      // name.removeAt(index);
                      // message.removeAt(index);
                      // msgCount.removeAt(index);
                    });
                    Navigator.pop(context);
                  },
                  child: Text("Delete",
                      style: context.theme.titleMedium!
                          .copyWith(color: Colors.white)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
