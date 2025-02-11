import 'dart:async';

import 'package:flutter/material.dart';
import 'package:zelio_social/services/token_service.dart';
import 'package:zelio_social/social/onboarding/onboarding_screen.dart';
import 'package:zelio_social/social/top_notch_bottom_nav/top_notch_bottom_nav.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () async {
      final token = await TokenService.instance.getToken();

      if (token != null && token.accessToken != null) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => TopNotchBottomNav(),
          ),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const OnboardingScreen(),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: const BoxDecoration(color: Colors.white),
        child: Center(
          child: Image.asset("assets/social_media/3x/zelio_blue.png"),
        ),
      ),
    );
  }
}
