import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zelio_social/chat/cubit/chat_list_cubit.dart';
import 'package:zelio_social/chat/service/chat_service.dart';
import 'package:zelio_social/services/socket_service.dart';
import 'package:zelio_social/social/home/social_home_screen.dart';
import 'package:zelio_social/chat/screen/chat_list_screen.dart';
import 'package:zelio_social/social/addpost/add_post_screen.dart';
import 'package:zelio_social/social/profile/social_user_profile_screen.dart';
import 'package:zelio_social/social/search/search_screen.dart';

class TopNotchBottomNav extends StatefulWidget {
  const TopNotchBottomNav({super.key});

  @override
  State<TopNotchBottomNav> createState() => _TopNotchBottomNavState();
}

class _TopNotchBottomNavState extends State<TopNotchBottomNav> {
  List screens = [
    SocialHomeScreen(),
    SearchScreen(),
    AddPostScreen(),
    ChatListScreen(),
    SocialUserProfileScreen(),
  ];

  int currentIndex = 0;
  PageController controller = PageController();

  void nextPage(index) {
    setState(() {
      currentIndex = index;
      controller.jumpToPage(index);
    });
  }

  @override
  void initState() {
    context.read<SocketService>().initializeSocket();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChatlistCubit(context.read<ChatService>(),context.read<SocketService>()),
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          elevation: 0,
          onPressed: () {
            nextPage(2);
          },
          backgroundColor: Colors.blue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          shape: CircularNotchedRectangle(),
          notchMargin: 10,
          elevation: 20,
          child: Row(
            children: [
              Expanded(
                child: IconButton(
                  onPressed: () {
                    nextPage(0);
                  },
                  icon: Image.asset(
                    "assets/social_media/3x/homeIcon.png",
                    color: currentIndex == 0 ? Colors.black : Colors.grey,
                  ),
                ),
              ),
              Expanded(
                child: IconButton(
                  onPressed: () {
                    nextPage(1);
                  },
                  icon: Icon(Icons.search),
                  color: currentIndex == 1 ? Colors.black : Colors.grey,
                ),
              ),
              Expanded(
                child: IconButton(
                  onPressed: () {
                    nextPage(3);
                  },
                  icon: Image.asset("assets/social_media/3x/smsIcon.png",
                      color: currentIndex == 3 ? Colors.black : Colors.grey),
                ),
              ),
              Expanded(
                child: IconButton(
                  onPressed: () {
                    nextPage(4);
                  },
                  icon: Image.asset(
                    "assets/social_media/3x/userIcon.png",
                    color: currentIndex == 4 ? Colors.black : Colors.grey,
                  ),
                ),
              ),
            ],
          ),
        ),
        body: PageView.builder(
          controller: controller,
          itemBuilder: (BuildContext context, int index) {
            return screens[index];
          },
          itemCount: screens.length,
        ),
      ),
    );
  }
}
