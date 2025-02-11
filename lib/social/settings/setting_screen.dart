import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zelio_social/config/common.dart';
import 'package:zelio_social/social/auth/cubit/login_cubit/login_cubit.dart';
import 'package:zelio_social/social/auth/loginscreen.dart';
import 'package:zelio_social/social/auth/service/login_services.dart';
import 'package:zelio_social/chat/screen/chat_list_screen.dart';
import 'package:zelio_social/social/profile/update_profile_detail_screen.dart';
import 'package:zelio_social/social/settings/bookmark_screen.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  final List<Map<String, dynamic>> faq = [
    {
      "title": "Personal Information",
      "page": UpdateProfileDetailScreen(),
    },
    {
      "title": "Language",
      "page": ChatListScreen(),
    },
    {
      "title": "Liked Post",
      "page": BookmarkScreen(),
    }
  ];

  bool notificationOn = true;
  late StreamSubscription<bool> notificationSubscription;
  final notificationStreamController = StreamController<bool>()..add(true);

  late StreamSubscription<bool> privateAccountSubscription;
  final privateAccountStreamController = StreamController<bool>()..add(true);
  bool privateAcc = true;

  // @override
  // void initState() {
  //   notificationSubscription = notificationStreamController.stream.listen((value){
  //     log("${value}");
  //   });
  //   super.initState();
  // }

  @override
  void dispose() {
    notificationStreamController.close();
    notificationSubscription.cancel();
    privateAccountSubscription.cancel();
    privateAccountStreamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Icon(Icons.arrow_back)),
        title: Text(
          "Settings",
          style: Theme.of(context)
              .textTheme
              .headlineSmall!
              .copyWith(color: Colors.blue),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Text(
              "Account",
              style: context.theme.titleLarge!
                  .copyWith(fontFamily: FontFamily.w700),
            ),
            const SizedBox(height: 20),
            ...faq.map((e) => ProfileItem(title: e["title"], page: e["page"])),
            const SizedBox(height: 20),
            Text(
              "Preferences",
              style: context.theme.titleLarge!
                  .copyWith(fontFamily: FontFamily.w700),
            ),
            const SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(
                    offset: Offset(2, 2),
                    color: const Color.fromRGBO(147, 147, 147, 0.1),
                    spreadRadius: 6,
                    blurRadius: 2)
              ], color: Colors.white, borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: Row(
                  children: [
                    const SizedBox(width: 8),
                    Expanded(
                      child: SizedBox(
                          child: Text(
                        "Notification",
                        style: context.theme.bodyLarge!
                            .copyWith(fontFamily: FontFamily.w700),
                      )),
                    ),
                    StreamBuilder<bool>(
                        stream: notificationStreamController.stream,
                        builder: (context, snapshot) {
                          notificationOn = snapshot.data ?? true;
                          return SizedBox(
                            width: 50,
                            child: Transform.scale(
                              scale: 0.8,
                              child: Switch(
                                thumbColor:
                                    WidgetStateProperty.all(Colors.white),
                                value: notificationOn,
                                activeColor: Colors.blue,
                                onChanged: (bool value) {
                                  setState(() {
                                    notificationOn = value;
                                    notificationStreamController.add(value);
                                  });
                                },
                              ),
                            ),
                          );
                        })
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(
                    offset: Offset(3, 2),
                    color: const Color.fromRGBO(147, 147, 147, 0.1),
                    spreadRadius: 6,
                    blurRadius: 2)
              ], color: Colors.white, borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    const SizedBox(width: 8),
                    Expanded(
                      child: SizedBox(
                          child: Text(
                        "Actions",
                        style: context.theme.bodyLarge!
                            .copyWith(fontFamily: FontFamily.w700),
                      )),
                    ),
                    const SizedBox(width: 16),
                    SizedBox(
                      width: 20,
                      child: Icon(Icons.arrow_forward_ios),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "Security",
              style: context.theme.titleLarge!
                  .copyWith(fontFamily: FontFamily.w700),
            ),
            const SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(
                    offset: Offset(2, 2),
                    color: const Color.fromRGBO(147, 147, 147, 0.1),
                    spreadRadius: 6,
                    blurRadius: 2)
              ], color: Colors.white, borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: Row(
                  children: [
                    const SizedBox(width: 8),
                    Expanded(
                      child: SizedBox(
                          child: Text(
                        "Private Account",
                        style: context.theme.bodyLarge!
                            .copyWith(fontFamily: FontFamily.w700),
                      )),
                    ),
                    StreamBuilder<bool>(
                        stream: privateAccountStreamController.stream,
                        builder: (context, snapshot) {
                          privateAcc = snapshot.data ?? true;
                          return SizedBox(
                            width: 50,
                            child: Transform.scale(
                              scale: 0.8,
                              child: Switch(
                                thumbColor:
                                    WidgetStateProperty.all(Colors.white),
                                value: privateAcc,
                                activeColor: Colors.blue,
                                onChanged: (bool value) {
                                  privateAcc = !privateAcc;
                                  privateAccountStreamController
                                      .add(privateAcc);
                                },
                              ),
                            ),
                          );
                        })
                  ],
                ),
              ),
            ),
            Spacer(),
            ElevatedButton(
              onPressed: () {
                context.read<LoginServices>().logoutUser();
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (context) => BlocProvider(
                              create: (context) =>
                                  LoginCubit(context.read<LoginServices>()),
                              child: LoginScreen(),
                            )),
                    (route) => false);
              },
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(Colors.blue),
                fixedSize: WidgetStateProperty.all(
                  Size(MediaQuery.of(context).size.width, 50),
                ),
                shape: WidgetStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              child: Text(
                "Log Out Account",
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: Colors.white,
                    ),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}

class ProfileItem extends StatelessWidget {
  final String title;
  final Widget page;

  const ProfileItem({super.key, required this.title, required this.page});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => page));
      },
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(boxShadow: [
              BoxShadow(
                  offset: Offset(3, 2),
                  color: const Color.fromRGBO(147, 147, 147, 0.1),
                  spreadRadius: 6,
                  blurRadius: 2)
            ], color: Colors.white, borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  const SizedBox(width: 8),
                  Expanded(
                    child: SizedBox(
                        child: Text(
                      title,
                      style: context.theme.bodyLarge!
                          .copyWith(fontFamily: FontFamily.w700),
                    )),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    width: 20,
                    child: Icon(Icons.arrow_forward_ios),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
