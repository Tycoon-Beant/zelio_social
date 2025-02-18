import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zelio_social/chat/cubit/group_chat_cubit.dart';
import 'package:zelio_social/chat/service/chat_service.dart';
import 'package:zelio_social/chat/service/get_avilable_user_service.dart';
import 'package:zelio_social/chat/service/group_chat_service.dart';
import 'package:zelio_social/chat/service/message_service.dart';
import 'package:zelio_social/services/local_storage_service.dart';
import 'package:zelio_social/services/socket_service.dart';
import 'package:zelio_social/social/auth/cubit/login_cubit/login_cubit.dart';
import 'package:zelio_social/social/auth/cubit/signup_cubit/signup_cubit.dart';
import 'package:zelio_social/social/auth/service/login_services.dart';
import 'package:zelio_social/social/auth/service/signup_services.dart';
import 'package:zelio_social/social/home/all_post_cubit/all_post_list_cubit.dart';
import 'package:zelio_social/social/addpost/cubit/post_cubit.dart';
import 'package:zelio_social/social/addpost/post_service/add_post_service.dart';
import 'package:zelio_social/social/profile/service/all_post_service.dart';
import 'package:zelio_social/social/profile/service/bookmark_service.dart';
import 'package:zelio_social/social/profile/service/comment_service.dart';
import 'package:zelio_social/social/profile/service/like_unlike_post_service.dart';
import 'package:zelio_social/social/profile/service/profile_service.dart';
import 'package:zelio_social/social/splash/splash_screen.dart';
import 'package:zelio_social/theme/app_theme.dart';
import 'package:zelio_social/theme/cubit/theme_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => LocalStorageService(prefs),
        ),
        RepositoryProvider(create: (context) => SignupServices()),
        RepositoryProvider(
            create: (context) =>
                LoginServices(context.read<LocalStorageService>())),
        RepositoryProvider(create: (context) => AllPostService()),
        RepositoryProvider(create: (context) => AddPostService()),
        RepositoryProvider(create: (context) => ProfileService()),
        RepositoryProvider(create: (context) => LikeUnlikePostService()),
        RepositoryProvider(create: (context) => CommentService()),
        RepositoryProvider(create: (context) => BookmarkService()),
        RepositoryProvider(create: (context) => ChatService()),
        RepositoryProvider(create: (context) => MessageService()),
        RepositoryProvider(create: (context) => SocketService()),
        RepositoryProvider(create: (context) => GetAvilableUserService()),
        RepositoryProvider(create: (context) => GroupChatService())
      ],
      child: MultiBlocListener(listeners: [
        BlocProvider(create: (context) => SignupCubit()),
        BlocProvider(
            create: (context) => LoginCubit(context.read<LoginServices>())),
        BlocProvider(
            create: (context) =>
                AllPostListCubit(context.read<AllPostService>())),
        BlocProvider(
            create: (context) => PostCubit(context.read<AddPostService>())),
        BlocProvider(create: (context) => ThemeCubit())
      ],
       child: const MyApp()),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, state) {
        return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Flutter Demo',
            builder: (context, child) {
              final mediaQueryData = MediaQuery.of(context);
              return MediaQuery(
                data: mediaQueryData.copyWith(
                    textScaler: const TextScaler.linear(1.0)),
                child: child!,
              );
            },
            theme: AppTheme().lightTheme,
            themeMode: state,
            home: SafeArea(child: Splashscreen()));
      },
    );
  }
}
