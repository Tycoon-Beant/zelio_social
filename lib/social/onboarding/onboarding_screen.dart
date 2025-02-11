
import 'package:flutter/material.dart';
import 'package:zelio_social/config/common.dart';
import 'package:zelio_social/social/auth/signin_screen.dart';
import 'package:zelio_social/social/onboarding/model/onboarding_model.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int currentIndex = 0;
  late PageController _controller;

  @override
  void initState() {
    _controller = PageController(initialPage: 0);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
                controller: _controller,
                itemCount: contents.length,
                onPageChanged: (int index) {
                  setState(() {
                    currentIndex = index;
                  });
                },
                itemBuilder: (_, i) {
                  return Column(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Image.asset(contents[i].image),
                      ),
                      const SizedBox(height: 20),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Text(
                                contents[i].description,
                                style: Theme.of(context).textTheme.headlineMedium!.copyWith(fontFamily: FontFamily.w700,fontWeight: FontWeight.bold),
                              ),
                              Text(contents[i].subDescription,textAlign: TextAlign.center,
                                  style: context.theme.bodyLarge!.copyWith(fontFamily: FontFamily.w700),
                                  ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                }),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: List.generate(
                      contents.length, (index) => buildDot(index, context)),
                ),
              ),
              Container(
              
                margin: EdgeInsets.all(16),
                child: SizedBox(
                  width: 200,
                  height: 40,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      
                      backgroundColor:
                          WidgetStateProperty.all<Color>(Colors.blue),
                    ),
                    onPressed: () {
                      if (currentIndex == contents.length - 1) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const SignInScreen(),
                          ),
                        );
                      }
                      _controller.nextPage(
                        duration: const Duration(milliseconds: 100),
                        curve: Curves.bounceIn,
                      );
                    },
                    child: currentIndex == contents.length - 1
                        ? Text(
                            "Get Started",
                            style: context.theme.titleMedium!.copyWith(color: Colors.white),
                          )
                        : Text(
                            "Next",
                            style: context.theme.titleMedium!.copyWith(color: Colors.white),
                          ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Container buildDot(int index, BuildContext context) {
    return Container(
      height: 10,
      width: currentIndex == index ? 25 : 10,
      margin: const EdgeInsets.only(right: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Theme.of(context).colorScheme.secondary,
      ),
    );
  }
}
