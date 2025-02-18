import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:zelio_social/Widgets/async_widget.dart';
import 'package:zelio_social/chat/cubit/chat_list_cubit.dart';
import 'package:zelio_social/config/common.dart';
import 'package:zelio_social/model/result.dart';
import 'package:zelio_social/services/local_storage_service.dart';
import 'package:zelio_social/social/home/model/all_post_model.dart';
import 'package:zelio_social/social/home/all_post_cubit/all_post_list_cubit.dart';
import 'package:zelio_social/social/addpost/cubit/post_cubit.dart';
import 'package:zelio_social/social/profile/cubit/add_bookmark_cubit.dart';
import 'package:zelio_social/social/profile/cubit/add_comment_cubit.dart';
import 'package:zelio_social/social/profile/cubit/comment_list_cubit.dart';
import 'package:zelio_social/social/profile/cubit/like_unlike_comment_cubit.dart';
import 'package:zelio_social/social/profile/cubit/like_unlike_post_cubit.dart';
import 'package:zelio_social/social/profile/model/bookmark_model.dart';
import 'package:zelio_social/social/profile/model/comment_model.dart';
import 'package:zelio_social/social/profile/model/like_unlike_post_model.dart';
import 'package:zelio_social/social/profile/service/bookmark_service.dart';
import 'package:zelio_social/social/profile/service/comment_service.dart';
import 'package:zelio_social/social/profile/service/like_unlike_post_service.dart';
import 'package:zelio_social/social/profile/social_user_profile_screen.dart';

class SocialHomeScreen extends StatefulWidget {
  const SocialHomeScreen({super.key});

  @override
  State<SocialHomeScreen> createState() => _SocialHomeScreenState();
}

class _SocialHomeScreenState extends State<SocialHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              LikeUnlikePostCubit(context.read<LikeUnlikePostService>()),
        ),
        BlocProvider(
          create: (context) => CommentListCubit(context.read<CommentService>()),
        ),
        BlocProvider(
          create: (context) => AddCommentCubit(context.read<CommentService>()),
        ),
        BlocProvider(
          create: (context) =>
              LikeUnlikeCommentCubit(context.read<CommentService>()),
        ),
      ],
      child: Builder(builder: (context) {
        return SafeArea(
          child: Scaffold(
            appBar: AppBar(
              iconTheme: IconThemeData(color: Colors.blue),
              automaticallyImplyLeading: false,
              title: Text(
                "Home",
                style: context.theme.headlineMedium!
                    .copyWith(fontFamily: FontFamily.w700),
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: Icon(
                    Icons.notifications_none_outlined,
                    color: context.colorScheme.primary,
                  ),
                )
              ],
            ),
            body: Column(
              children: [
                Row(
                  children: [FriendsStories()],
                ),
                // const SizedBox(height: 20),
                Expanded(
                    child: MultiBlocListener(
                  listeners: [
                    BlocListener<LikeUnlikePostCubit, Result<LikeModel>>(
                      listener: (context, state) {
                        context.read<AllPostListCubit>().update(state.data!);
                      },
                    ),
                    BlocListener<PostCubit, Result<PostsState>>(
                        listener: (context, state) {
                      if (state.data != null) {
                        context.read<AllPostListCubit>().getAllPosts();
                      }
                    })
                  ],
                  child: AsyncWidget<AllPostListCubit, List<PostModel>>(
                    data: (post) {
                      final postData = post ?? [];
                      if (post != null) {
                        return PostWidget(
                          post: postData,
                        );
                      } else {
                        return Center(
                          child: Text(
                              "No Post available. \n Please check your internet \n Refresh Page/revisit page"),
                        );
                      }
                    },
                  ),
                )),
              ],
            ),
          ),
        );
      }),
    );
  }
}

class PostWidget extends StatelessWidget {
  const PostWidget({super.key, required this.post});
  final List<PostModel> post;
  @override
  Widget build(BuildContext context) {
    post.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: ListView.builder(
        itemCount: post.length,
        itemBuilder: (BuildContext context, int index) {
          final postItem = post[index];
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                const SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                    color: context.colorScheme.onPrimary,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.grey,
                                foregroundColor: Color(0xff128C7E),
                                radius: 25,
                                backgroundImage: NetworkImage(
                                    postItem.author?.coverImage?.localPath ??
                                        ""),
                              ),
                              const SizedBox(width: 10),
                              InkWell(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (bcontext) => BlocProvider.value(
                                        value: context.read<ChatlistCubit>(),
                                        child: SocialUserProfileScreen(
                                          username: postItem
                                              .author?.account!.username!,
                                          id: postItem.author?.account?.id,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                child: Text(
                                    '${postItem.author?.firstName} ${postItem.author?.lastName}',
                                    style: context.theme.titleLarge),
                              ),
                              Expanded(child: SizedBox()),
                              IconButton(
                                icon: Icon(Icons.more_vert_outlined),
                                onPressed: () {
                                  showCustomBottomSheet(
                                      context,
                                      postItem.author?.account!.username,
                                      postItem.id);
                                },
                              )
                            ],
                          ),
                          const SizedBox(height: 16),
                          Divider(
                            height: 2,
                            color: const Color.fromARGB(255, 220, 218, 218),
                          ),
                          const SizedBox(height: 8),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: Text(
                              postItem.content!,
                              textAlign: TextAlign.left,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: context.theme.bodyLarge!.copyWith(
                                color: Color.fromRGBO(56, 56, 56, 0.8),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: postItem.tags?.length,
                              itemBuilder: (BuildContext context, int index) {
                                var tags = postItem.tags![index];
                                return Text(
                                  "# ${tags}",
                                  textAlign: TextAlign.left,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: context.theme.bodyLarge!.copyWith(
                                    color: Colors.blue,
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 20),
                          ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: AspectRatio(
                                  aspectRatio: 4 / 5,
                                  child: Image.network(
                                    errorBuilder: (context, error, stackTrace) {
                                      return Center(child: Text('Unable to load Image'));
                                    },
                                    postItem.images?.firstOrNull?.localPath ??
                                        '',
                                    fit: BoxFit.cover,
                                  ))),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  context
                                      .read<LikeUnlikePostCubit>()
                                      .likeUnlikePost(postItem.id);
                                },
                                child: postItem.isLiked!
                                    ? Icon(
                                        Icons.favorite,
                                        color: Colors.red,
                                      )
                                    : Icon(
                                        Icons.favorite_border_outlined,
                                      ),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                postItem.likes.toString(),
                                style: context.theme.bodyLarge!.copyWith(
                                  color: Color.fromRGBO(56, 56, 56, 0.8),
                                ),
                              ),
                              const SizedBox(width: 20),
                              InkWell(
                                onTap: () {
                                  showCommentBottomSheet(
                                    context,
                                    postItem,
                                    postItem.id,
                                  );
                                  context
                                      .read<CommentListCubit>()
                                      .getPostComments(id: postItem.id);

                                  // Navigator.of(context).push(MaterialPageRoute(
                                  //     builder: (context) => CommentScreen(
                                  //           postId: postItem.id,
                                  //         )));
                                },
                                child: Image.asset(
                                  "assets/social_media/3x/comment.png",
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                postItem.comments.toString(),
                                style: context.theme.bodyLarge!.copyWith(
                                  color: Color.fromRGBO(56, 56, 56, 0.8),
                                ),
                              ),
                              Expanded(child: SizedBox()),
                              Text(
                                DateFormat.yMMMd().format(postItem.createdAt!),
                                style: context.theme.bodyMedium!.copyWith(
                                    color: const Color.fromARGB(
                                        255, 188, 187, 187)),
                              )
                            ],
                          )
                        ]),
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          );
        },
      ),
    );
  }
}

void showCommentBottomSheet(
    BuildContext context, PostModel post, String? postId) {
  TextEditingController commentController = TextEditingController();
  final commentKey = GlobalKey<FormFieldState>();

  showModalBottomSheet(
    isScrollControlled: true,
    constraints: BoxConstraints.tightFor(
        height: MediaQuery.of(context).size.height * 0.65),
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (BuildContext bcontext) {
      final currentUsername =
          context.read<LocalStorageService>().getUser()?.username;
      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(bcontext).viewInsets.bottom,
        ),
        child: MultiBlocProvider(
          providers: [
            BlocProvider.value(
              value: context.read<CommentListCubit>(),
            ),
            BlocProvider.value(value: context.read<AddCommentCubit>()),
            BlocProvider.value(value: context.read<LikeUnlikeCommentCubit>()),
          ],
          child: MultiBlocListener(
            listeners: [
              BlocListener<LikeUnlikeCommentCubit, Result<LikeCommentModel>>(
                listener: (context, state) {
                  context
                      .read<CommentListCubit>()
                      .updateLikes(likeCommentModel: state.data);
                },
              ),
              BlocListener<AddCommentCubit, Result<CommentState>>(
                  listener: (context, state) {
                if (state.data != null ||
                    state.data?.event == CommentEvent.delete) {
                  context.read<AllPostListCubit>().updateCommentcount(
                      event: state.data!.event, postId: postId!);
                  context.read<CommentListCubit>().getPostComments(id: postId);
                }
              })
            ],
            child: BlocBuilder<CommentListCubit, Result<List<CommentModel>>>(
              builder: (context, state) {
                if (state.isLoading) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (state.error != null) {
                  return Center(
                    child: Text("Error: ${state.error}"),
                  );
                }

                return Container(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Comments",
                        style: context.theme.titleLarge!.copyWith(
                          fontFamily: FontFamily.w700,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Expanded(
                        child: state.data?.isEmpty ?? true
                            ? Center(
                                child: Text(
                                  "No comments yet",
                                  style: context.theme.bodyMedium!.copyWith(
                                    color: context.colorScheme.onSecondary,
                                  ),
                                ),
                              )
                            : ListView.builder(
                                itemCount: state.data?.length,
                                itemBuilder: (context, index) {
                                  final comment = state.data?[index];
                                  final username =
                                      comment?.author?.account?.username;
                                  return Column(
                                    children: [
                                      Container(
                                        color: Colors.white,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            children: [
                                              CircleAvatar(
                                                radius: 20,
                                                backgroundImage: NetworkImage(
                                                    "${comment?.author?.account?.avatar?.url}"),
                                              ),
                                              const SizedBox(width: 10),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "${comment?.author?.account?.username}",
                                                    style: context
                                                        .theme.titleMedium,
                                                  ),
                                                  Text(
                                                    "${comment?.content}",
                                                    style: context
                                                        .theme.bodySmall!
                                                        .copyWith(
                                                            color: context
                                                                .colorScheme
                                                                .onSecondary),
                                                  ),
                                                ],
                                              ),
                                              Expanded(child: SizedBox()),
                                              InkWell(
                                                onTap: () {
                                                  context
                                                      .read<
                                                          LikeUnlikeCommentCubit>()
                                                      .likeUnlikeComments(
                                                          commentId:
                                                              comment.id);
                                                },
                                                child: comment!.isLiked!
                                                    ? Icon(
                                                        Icons.favorite,
                                                        color: Colors.red,
                                                      )
                                                    : Icon(
                                                        Icons
                                                            .favorite_border_outlined,
                                                      ),
                                              ),
                                              const SizedBox(width: 8),
                                              username == currentUsername
                                                  ? InkWell(
                                                      onTap: () {
                                                        context
                                                            .read<
                                                                AddCommentCubit>()
                                                            .deleteCommentbyId(
                                                                commentId:
                                                                    comment.id,
                                                                postId: postId);
                                                      },
                                                      child: Icon(
                                                        Icons.delete_outline,
                                                        color: Colors.red,
                                                      ),
                                                    )
                                                  : SizedBox.shrink()
                                            ],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                    ],
                                  );
                                }),
                      ),
                      const SizedBox(height: 10),
                      BlocConsumer<AddCommentCubit, Result<CommentState>>(
                        listener: (context, state) {
                          if (state.data?.event == CommentEvent.add) {
                            commentController.clear();
                            context
                                .read<CommentListCubit>()
                                .getPostComments(id: postId);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Comment Added!"),
                              ),
                            );
                            Navigator.of(context).pop();
                          }
                        },
                        builder: (context, state) {
                          return Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  key: commentKey,
                                  controller: commentController,
                                  decoration: InputDecoration(
                                    hintText: "Type comment here!",
                                    hintStyle:
                                        context.theme.bodySmall!.copyWith(
                                      color: context.colorScheme.onSecondary,
                                    ),
                                    border: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.grey),
                                    ),
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.send),
                                onPressed: () {
                                  if (commentController.text.isNotEmpty) {
                                    context
                                        .read<AddCommentCubit>()
                                        .addPostComments(
                                            postId: postId,
                                            content: commentController.text);
                                  }
                                },
                              ),
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: 4),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      );
    },
  );
}

List stories = [
  "",
  "assets/social_media/person1.png",
  "assets/social_media/person2.png",
  "assets/social_media/person3.png",
  "assets/social_media/person4.png",
  "assets/social_media/person1.png",
  "assets/social_media/person2.png",
  "assets/social_media/person3.png",
  "assets/social_media/person4.png",
];

class FriendsStories extends StatelessWidget {
  const FriendsStories({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SizedBox(
        height: 100,
        width: 410,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: stories.length,
          itemBuilder: (BuildContext context, int index) {
            // Special case for index 1
            if (index == 0) {
              return Row(
                children: const [
                  UserStorie(), // Custom widget for user story
                  SizedBox(width: 10),
                ],
              );
            }

            // Default story item
            return Row(
              children: [
                Container(
                  width: 80, // Adjust as needed
                  height: 80, // Adjust as needed
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.blue, width: 4),
                      borderRadius: BorderRadius.circular(20)),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.asset(
                        stories[index],
                        fit: BoxFit.fill,
                      )),
                ),
                const SizedBox(width: 8),
              ],
            );
          },
        ),
      ),
    );
  }
}

class UserStorie extends StatelessWidget {
  const UserStorie({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: DottedBorder(
        color: Colors.blue, // Border color
        strokeWidth: 4, // Border width
        dashPattern: [8, 3], // Dotted pattern (length and gap)
        borderType: BorderType.RRect, // Rounded rectangle border
        radius: const Radius.circular(12), // Border radius
        child: Container(
            width: 70,
            height: 70,
            alignment: Alignment.center,
            child: Icon(
              Icons.add,
              size: 40,
              color: Colors.blue,
            )),
      ),
    );
  }
}

void showCustomBottomSheet(
    BuildContext gcontext, String? username, String? postId) {
  showModalBottomSheet(
    backgroundColor: Colors.white,
    context: gcontext,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (BuildContext context) {
      final currentUsername =
          context.read<LocalStorageService>().getUser()?.username;
      if (username == currentUsername) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min, // Wraps the content
            children: [
              InkWell(
                onTap: () {},
                child: Row(
                  children: [
                    Image.asset(
                      "assets/social_media/3x/heart-slash.png",
                      scale: 2,
                    ),
                    const SizedBox(width: 20),
                    Text(
                      'Hide Likes',
                      style: context.theme.bodyLarge,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              InkWell(
                onTap: () {},
                child: Row(
                  children: [
                    Icon(
                      Icons.remove_circle_outline_outlined,
                      size: 38,
                    ),
                    const SizedBox(width: 20),
                    Text(
                      'Turn off comments',
                      style: context.theme.bodyLarge,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              InkWell(
                onTap: () {},
                child: Row(
                  children: [
                    Icon(
                      Icons.edit,
                      size: 35,
                    ),
                    const SizedBox(width: 20),
                    Text(
                      'Edit',
                      style: context.theme.bodyLarge,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              InkWell(
                onTap: () {
                  context.read<PostCubit>().deletePost(postId: postId!);
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                  context.read<AllPostListCubit>().getAllPosts();
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.delete_forever_outlined,
                      color: Colors.red,
                      size: 35,
                    ),
                    const SizedBox(width: 20),
                    Text(
                      'Delete',
                      style:
                          context.theme.bodyLarge!.copyWith(color: Colors.red),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      } else {
        return BlocProvider(
          create: (context) =>
              AddBookmarkCubit(context.read<BookmarkService>()),
          child: BlocListener<AddBookmarkCubit, Result<AddBookMarkModel>>(
            listener: (context, state) {
              if (state.data != null) {
                context.read<AllPostListCubit>().updateBookmark(
                    postId: postId!,
                    isBookmarked: state.data?.isBookmarked ?? false);
              }
            },
            child: BlocBuilder<AllPostListCubit, Result<List<PostModel>>>(
                builder: (context, state) {
              final post = state.data?.singleWhere((e) => e.id == postId);
              return Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min, // Wraps the content
                  children: [
                    InkWell(
                      onTap: () {
                        context
                            .read<AddBookmarkCubit>()
                            .addBookmarkByPostId(postId: post?.id);
                      },
                      child: Row(
                        children: [
                          post?.isBookmarked == true
                              ? Image.asset(
                                  "assets/social_media/3x/star_slash_icon.png")
                              : Icon(
                                  Icons.star_border,
                                  size: 38,
                                ),
                          const SizedBox(width: 20),
                          Text(
                            post?.isBookmarked == true
                                ? "Remove from bookmark"
                                : 'Add to bookmark',
                            style: context.theme.bodyLarge,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    InkWell(
                      onTap: () {},
                      child: Row(
                        children: [
                          Icon(
                            Icons.person_remove_outlined,
                            size: 38,
                          ),
                          const SizedBox(width: 20),
                          Text(
                            'unfollow',
                            style: context.theme.bodyLarge,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    InkWell(
                      onTap: () {},
                      child: Row(
                        children: [
                          Icon(
                            Icons.visibility_off_outlined,
                            size: 35,
                          ),
                          const SizedBox(width: 20),
                          Text(
                            'Hide',
                            style: context.theme.bodyLarge,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    InkWell(
                      onTap: () {
                        context.read<PostCubit>().deletePost(postId: post!.id!);
                        Navigator.of(context).pop();
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.report_gmailerrorred,
                            color: Colors.red,
                            size: 35,
                          ),
                          const SizedBox(width: 20),
                          Text(
                            'report',
                            style: context.theme.bodyLarge!
                                .copyWith(color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        );
      }
    },
  );
}
