import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zelio_social/Widgets/async_widget.dart';
import 'package:zelio_social/config/common.dart';
import 'package:zelio_social/model/result.dart';
import 'package:zelio_social/social/home/all_post_cubit/all_post_list_cubit.dart';
import 'package:zelio_social/social/profile/cubit/follower_list_cubit.dart';
import 'package:zelio_social/social/profile/cubit/following_list_cubit.dart';
import 'package:zelio_social/social/profile/cubit/profile_post_list_cubit.dart';
import 'package:zelio_social/social/profile/model/follower_following_model.dart';

class FollowerFollowingScreen extends StatefulWidget {
  const FollowerFollowingScreen({super.key, this.username});
  final String? username;
  @override
  State<FollowerFollowingScreen> createState() =>
      _FollowerFollowingScreenState();
}

class _FollowerFollowingScreenState extends State<FollowerFollowingScreen>
    with TickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => FollowerListCubit(context.read(), context.read())
            ..getFollowerList(username: widget.username),
        ),
        BlocProvider(
          create: (context) =>
              FollowingListCubit(context.read(), context.read())
                ..getFollowingsList(username: widget.username),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: TabBar(
            controller: _tabController,
            tabs: const <Widget>[
              Tab(
                text: 'Follower',
              ),
              Tab(
                text: 'Following',
              ),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: <Widget>[
            BlocListener<ProfilePostListCubit, Result<ProfileState>>(
              listener: (context, state) {
                if (state.data != null) {
                  context
                      .read<FollowerListCubit>()
                      .getFollowerList(username: widget.username);
                }
              },
              child:
                  AsyncWidget<FollowerListCubit, List<FollowersFollowingModel>>(
                data: (followers) {
                  return FollowerList(
                    profile: followers,
                  );
                },
              ),
            ),
            BlocListener<ProfilePostListCubit, Result<ProfileState>>(
              listener: (context, state) {
                if (state.data != null) {
                  context
                      .read<FollowingListCubit>()
                      .getFollowingsList(username: widget.username);
                }
              },
              child: AsyncWidget<FollowingListCubit,
                  List<FollowersFollowingModel>>(
                data: (following) {
                  return FollowingList(
                    profile: following,
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

class FollowerList extends StatefulWidget {
  const FollowerList({super.key, required this.profile});
  final List<FollowersFollowingModel>? profile;
  @override
  State<FollowerList> createState() => _FollowerListState();
}

class _FollowerListState extends State<FollowerList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        child: ListView.builder(
          itemCount: widget.profile?.length,
          itemBuilder: (BuildContext context, int index) {
            var follower = widget.profile?[index];
            return Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20)),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.grey,
                          foregroundColor: Color(0xff128C7E),
                          radius: 25,
                          backgroundImage: NetworkImage(
                              "${follower?.profile?.coverImage?.localPath}"),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            InkWell(
                              child: Text('${follower?.username}',
                                  style: context.theme.titleLarge),
                            ),
                            Text('${follower?.profile?.bio}',
                                style: context.theme.bodySmall!.copyWith(
                                    color: context.colorScheme.onSecondary)),
                          ],
                        ),
                        Expanded(child: const SizedBox(width: 8)),
                        OutlinedButton(
                          style: ButtonStyle(
                            side: WidgetStatePropertyAll(
                                BorderSide(color: Colors.blue)),
                            backgroundColor: follower?.isFollowing == true
                                ? WidgetStateProperty.all(Colors.white)
                                : WidgetStatePropertyAll(Colors.blue),
                          ),
                          onPressed: () {
                            context.read<ProfilePostListCubit>().postFollow(
                                userId: follower?.id,
                                username: follower?.username);
                          },
                          child: context
                                  .watch<ProfilePostListCubit>()
                                  .state
                                  .isRefreshing
                              ? CircularProgressIndicator()
                              : Text(
                                  follower?.isFollowing == true
                                      ? "Unfollow"
                                      : "Follow",
                                  style: context.theme.titleMedium!.copyWith(
                                      color: follower?.isFollowing == true
                                          ? Colors.blue
                                          : Colors.white),
                                ),
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
              ],
            );
          },
        ),
      ),
    );
  }
}

class FollowingList extends StatefulWidget {
  const FollowingList({super.key, required this.profile});
  final List<FollowersFollowingModel>? profile;
  @override
  State<FollowingList> createState() => _FollowingListState();
}

class _FollowingListState extends State<FollowingList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        child: ListView.builder(
          itemCount: widget.profile?.length,
          itemBuilder: (BuildContext context, int index) {
            var following = widget.profile?[index];
            return Column(
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.grey,
                      foregroundColor: Color(0xff128C7E),
                      radius: 25,
                      backgroundImage: NetworkImage(
                          "${following?.profile?.coverImage?.localPath}"),
                    ),
                    const SizedBox(width: 10),
                    InkWell(
                      child: Expanded(
                        child: Text('${following?.username}',
                            style: context.theme.titleLarge),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Expanded(child: const SizedBox(width: 8)),
                OutlinedButton(
                  style: ButtonStyle(
                    side:
                        WidgetStatePropertyAll(BorderSide(color: Colors.blue)),
                    backgroundColor: following?.isFollowing == true
                        ? WidgetStateProperty.all(Colors.white)
                        : WidgetStatePropertyAll(Colors.blue),
                  ),
                  onPressed: () {
                    context.read<ProfilePostListCubit>().postFollow(
                        userId: following?.id, username: following?.username);
                  },
                  child:
                      context.watch<ProfilePostListCubit>().state.isRefreshing
                          ? CircularProgressIndicator()
                          : Text(
                              following?.isFollowing == true
                                  ? "Unfollow"
                                  : "Follow",
                              style: context.theme.titleMedium!.copyWith(
                                  color: following?.isFollowing == true
                                      ? Colors.blue
                                      : Colors.white),
                            ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
