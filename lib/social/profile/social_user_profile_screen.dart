import 'dart:io';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:zelio_social/chat/cubit/chat_list_cubit.dart';
import 'package:zelio_social/chat/cubit/create_one_to_one_chat_cubit.dart';
import 'package:zelio_social/chat/model/chat_model.dart';
import 'package:zelio_social/chat/screen/chat_screen.dart';
import 'package:zelio_social/config/common.dart';
import 'package:zelio_social/model/result.dart';
import 'package:zelio_social/services/local_storage_service.dart';
import 'package:zelio_social/social/addpost/add_post_screen.dart';
import 'package:zelio_social/social/home/model/all_post_model.dart';
import 'package:zelio_social/social/home/social_home_screen.dart';
import 'package:zelio_social/social/profile/cubit/profile_post_list_cubit.dart';
import 'package:zelio_social/social/home/all_post_cubit/all_post_list_cubit.dart';
import 'package:zelio_social/social/profile/follower_following_screen.dart';
import 'package:zelio_social/social/profile/repository/follow_unfollow_repository.dart';
import 'package:zelio_social/social/settings/setting_screen.dart';

class SocialUserProfileScreen extends StatefulWidget {
  const SocialUserProfileScreen({super.key, this.username, this.id});
  final String? username;
  final String? id;
  @override
  State<SocialUserProfileScreen> createState() =>
      _SocialUserProfileScreenState();
}

class _SocialUserProfileScreenState extends State<SocialUserProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => FollowUnfollowRepository(
          profileService: context.read(), allPostService: context.read()),
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) =>
                ProfilePostListCubit(context.read(), context.read())
                  ..getProfileData(userName: widget.username),
          ),
          BlocProvider(
              create: (context) => CreateOneToOneChatCubit(context.read()))
        ],
        child: Builder(builder: (context) {
          return SafeArea(
            child: Scaffold(
              appBar: AppBar(
                leading: InkWell(
                    onTap: () {
                      Navigator.of(context).maybePop();
                    },
                    child: Icon(
                      Icons.arrow_back,
                      color: context.colorScheme.primary,
                    )),
                title: Text("Profile", style: context.theme.headlineSmall!),
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => SettingScreen()));
                      },
                      child: Icon(
                        Icons.settings_outlined,
                        size: 30,
                      ),
                    ),
                  )
                ],
              ),
              body: Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
                child: Column(
                  children: [
                    BlocListener<CreateOneToOneChatCubit, Result<ChatModel>>(
                      listener: (context, state) {
                        if (state.data != null) {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ChatScreen(
                                    chatModel: state.data,
                                  )));
                        }
                      },
                      child: BlocBuilder<ProfilePostListCubit,
                          Result<ProfileState>>(
                        builder: (context, state) {
                          if (state.isLoading) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                          if (state.error != null) {
                            return Center(child: Text(state.error.toString()));
                          }
                          if (state.data != null) {
                            final currentUsername = context
                                .read<LocalStorageService>()
                                .getUser()
                                ?.username;
                            final profile = state.data;
                            final postImage = state.data?.myPostList
                                    ?.map((e) => e.images)
                                    .expand((e) => e!)
                                    .toList() ??
                                [];

                            return ProfilePage(
                              postImages: postImage,
                              profile: profile,
                              username: widget.username,
                              currentUser: currentUsername == widget.username ||
                                  widget.username == null,
                              id: widget.id,
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class ProfilePage extends StatefulWidget {
  final List<Images>? postImages;
  final ProfileState? profile;
  final String? username;
  final bool currentUser;
  final String? id;
  const ProfilePage(
      {super.key,
      this.postImages,
      this.profile,
      this.username,
      required this.currentUser,
      this.id});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  File? selectedImage;
  bool isFollow = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Stack(children: [
              if (selectedImage != null)
                CircleAvatar(
                  radius: 40,
                  backgroundImage: FileImage(selectedImage!, scale: 0.5),
                )
              else if (widget.profile?.myProfile?.coverImage?.url != null)
                CircleAvatar(
                  backgroundColor: Colors.grey,
                  radius: 40,
                  backgroundImage: NetworkImage(
                      widget.profile?.myProfile?.coverImage?.url ?? ''),
                ),
              Positioned(
                  top: 50,
                  right: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: context.colorScheme.primary,
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: context.colorScheme.onPrimary),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: InkWell(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
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
                          child: Icon(
                            Icons.camera_alt_outlined,
                            color: context.colorScheme.onPrimary,
                          )),
                    ),
                  ))
            ]),
            const SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    "${widget.profile!.myProfile?.firstName} ${widget.profile!.myProfile?.lastName}",
                    style: context.theme.titleLarge!
                        .copyWith(fontFamily: FontFamily.w700)),
                Text("${widget.profile!.myProfile?.bio} ",
                    style: context.theme.titleMedium!.copyWith(
                      color: Colors.grey,
                    )),
                Text("${widget.profile!.myProfile?.location}",
                    style: context.theme.titleSmall!.copyWith(
                      color: Colors.grey,
                    )),
              ],
            )
          ],
        ),
        const SizedBox(height: 20),
        if (!widget.currentUser)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                height: 50,
                width: 80,
                decoration: BoxDecoration(
                  border: Border.all(color: context.colorScheme.secondary),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: InkWell(onTap: () {
                  final chatState = context.read<ChatlistCubit>();
                  final chat = chatState.state.data!.singleWhereOrNull((e) =>
                      !(e.isGroupChat ?? false) &&
                      e.participants!.any(
                          (p) => p.id == widget.profile?.myProfile?.owner));

                  if (chat != null) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ChatScreen(
                          chatModel: chat,
                        ),
                      ),
                    );
                  }

                  context.read<CreateOneToOneChatCubit>().createOneOnOneChat(
                      receiverId: widget.profile?.myProfile?.owner);
                }, child:
                    BlocBuilder<CreateOneToOneChatCubit, Result<ChatModel>>(
                  builder: (context, state) {
                    if (state.isLoading) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (state.data != null) {
                      return Text("error");
                    }
                    return Image.asset("assets/social_media/3x/comment.png");
                  },
                )),
              ),
              FollowButton(
                isFollowed: widget.profile?.myProfile?.isFollowing ?? false,
                onTap: () {
                  context
                      .read<ProfilePostListCubit>()
                      .postFollow(userId: widget.id, username: widget.username);
                },
              ),
            ],
          ),
        const SizedBox(height: 20),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          height: 80,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Text("${widget.postImages?.length.toString()}",
                        style: context.theme.titleLarge!
                            .copyWith(fontFamily: FontFamily.w700)),
                    Text(
                      "Posts",
                      style: context.theme.bodyMedium!
                          .copyWith(color: Colors.grey),
                    ),
                  ],
                ),
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (bcontext) => BlocProvider.value(
                              value: context.read<ProfilePostListCubit>(),
                              child: FollowerFollowingScreen(
                                  username: widget.username),
                            )));
                  },
                  child: Column(
                    children: [
                      Text(widget.profile!.myProfile!.followersCount.toString(),
                          style: context.theme.titleLarge!
                              .copyWith(fontFamily: FontFamily.w700)),
                      Text(
                        "Followers",
                        style: context.theme.bodyMedium!
                            .copyWith(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => BlocProvider.value(
                              value: context.read<ProfilePostListCubit>(),
                              child: FollowerFollowingScreen(
                                  username: widget.username),
                            )));
                  },
                  child: Column(
                    children: [
                      Text(widget.profile!.myProfile!.followingCount.toString(),
                          style: context.theme.titleLarge!
                              .copyWith(fontFamily: FontFamily.w700)),
                      Text(
                        "Following",
                        style: context.theme.bodyMedium!
                            .copyWith(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        widget.postImages != null
            ? SizedBox(
                height: 435,
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // Number of columns
                    childAspectRatio: 1,
                  ),
                  itemCount: widget.postImages?.length,
                  itemBuilder: (BuildContext context, int index) {
                    final post = widget.postImages?[index];
                    return InkWell(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return PostWidget(
                                post: widget.profile!.myPostList!,
                              );
                            });
                      },
                      child: Card(
                        elevation: 0,
                        color: Colors.white,
                        child: AspectRatio(
                          aspectRatio: 2,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.network(
                              post?.localPath ?? '',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              )
            : SizedBox.shrink()
      ],
    );
  }
}

class FollowButton extends StatefulWidget {
  final bool isFollowed;
  final VoidCallback onTap;

  const FollowButton({
    super.key,
    required this.isFollowed,
    required this.onTap,
  });

  @override
  State<FollowButton> createState() => _FollowButtonState();
}

class _FollowButtonState extends State<FollowButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        height: 50,
        width: 160,
        decoration: BoxDecoration(
          color: widget.isFollowed
              ? context.colorScheme.onPrimary
              : context.colorScheme.secondary,
          border: Border.all(
            color: context.colorScheme.secondary,
          ),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Center(
          child: context.watch<ProfilePostListCubit>().state.isRefreshing
              ? CircularProgressIndicator(
                  color: Colors.grey,
                )
              : Text(
                  widget.isFollowed ? "Following" : "Follow",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: widget.isFollowed
                            ? context.colorScheme.secondary
                            : context.colorScheme.onPrimary,
                      ),
                ),
        ),
      ),
    );
  }
}
