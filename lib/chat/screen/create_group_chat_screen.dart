import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zelio_social/Widgets/async_widget.dart';
import 'package:zelio_social/chat/cubit/avilable_user_cubit.dart';
import 'package:zelio_social/chat/cubit/group_chat_cubit.dart';
import 'package:zelio_social/chat/cubit/group_chat_detail_cubit.dart';
import 'package:zelio_social/chat/model/avilable_user_model.dart';
import 'package:zelio_social/chat/model/chat_model.dart';
import 'package:zelio_social/chat/screen/chat_list_screen.dart';
import 'package:zelio_social/config/common.dart';
import 'package:zelio_social/model/result.dart';

class CreateGroupChatScreen extends StatefulWidget {
  const CreateGroupChatScreen(
      {super.key, this.chatId, this.chatModel, this.event});
  final String? chatId;
  final ChatModel? chatModel;
  final String? event;
  @override
  State<CreateGroupChatScreen> createState() => _CreateGroupChatScreenState();
}

class _CreateGroupChatScreenState extends State<CreateGroupChatScreen> {
  final TextEditingController _groupChatName = TextEditingController();
  List<String> particpants = [];

  @override
  void initState() {
    _groupChatName.text = widget.chatModel?.name ?? '';
    particpants
        .addAll(widget.chatModel?.participants?.map((e) => e.id ?? '') ?? []);
    super.initState();
  }

  String? participantId;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AvilableUserCubit(context.read()),
        ),
        BlocProvider(
          create: (context) => GroupChatCubit(context.read()),
        ),
        BlocProvider(create: (context) => GroupChatDetailCubit(context.read()))
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            widget.event == "remove"
                ? "Remove Member"
                : widget.event == "add"
                    ? "Add Member"
                    : "Create Group Chat",
            style: context.theme.headlineMedium!
                .copyWith(fontFamily: FontFamily.w700),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text("Group name: ", style: context.theme.titleMedium),
                ),
              ),
              TextFormField(
                controller: _groupChatName,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color.fromARGB(255, 236, 233, 233),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none),
                  hintText: "Type message here!....",
                  hintStyle:
                      context.theme.bodySmall!.copyWith(color: Colors.grey),
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: BlocListener<GroupChatCubit, Result<GroupState>>(
                  listener: (context, state) {
                    if (state.data != null) {
                      _groupChatName.clear();
                    }
                  },
                  child:
                      AsyncWidget<AvilableUserCubit, List<AvilableUserModel>>(
                    data: (user) {
                      final userlist = user ?? [];

                      userlist
                          .sort((a, b) => particpants.contains(a.id) ? -1 : 1);
                      return ListView.separated(
                        itemCount: userlist.length,
                        separatorBuilder: (BuildContext context, int index) {
                          return SizedBox(
                            height: 10,
                          );
                        },
                        itemBuilder: (BuildContext context, int index) {
                          final users = userlist[index];
                          bool isChecked = particpants.contains(users.id);
                          return Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.grey,
                                foregroundColor: Color(0xff128C7E),
                                radius: 25,
                                backgroundImage: NetworkImage(
                                  users.avatar?.localPath ?? '',
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(users.username ?? '',
                                        style: context.theme.titleMedium!
                                            .copyWith(
                                                fontFamily: FontFamily.w700)),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 10),
                              Checkbox(
                                value: isChecked,
                                onChanged: (bool? newValue) {
                                  setState(() {
                                    if (widget.event == "add") {
                                      participantId = users.id!;
                                      particpants.add(users.id!);
                                    }
                                    if (widget.event == "remove") {
                                      participantId = users.id!;
                                      particpants.remove(users.id!);
                                    }
                                    if (newValue == true) {
                                      particpants.add(users.id!);
                                    } else {
                                      particpants.remove(users.id!);
                                    }
                                  });
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),
              BlocConsumer<GroupChatCubit, Result<GroupState>>(
                listener: (context, state) {
                  if (state.data != null &&
                      state.data?.event == GroupEvent.add) {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => ChatListScreen()));
                  }
                  if (state.data != null &&
                      state.data?.event == GroupEvent.addParticipant) {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => ChatListScreen()));
                  }
                  if (state.data != null &&
                      state.data?.event == GroupEvent.removeParticipant) {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => ChatListScreen()));
                  }
                },
                builder: (context, state) {
                  return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: context.colorScheme.secondary,
                          fixedSize:
                              Size(MediaQuery.of(context).size.width, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          )),
                      onPressed: () {
                        if (_groupChatName.text.isNotEmpty) {
                          if (widget.event == "add") {
                            context
                                .read<GroupChatCubit>()
                                .addParticipant(widget.chatId, participantId);
                          }
                          if (widget.event == "remove") {
                            context.read<GroupChatCubit>().removeParticipant(
                                widget.chatId, participantId);
                          }
                          context.read<GroupChatCubit>().createGroupChats(
                              _groupChatName.text, particpants);
                        }
                      },
                      child: Text(
                          widget.event == "remove"
                              ? "Remove Member"
                              : widget.event == "add"
                                  ? "Add Member"
                                  : "Create Group Chat",
                          style: context.theme.titleMedium!
                              .copyWith(color: Colors.white)));
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
