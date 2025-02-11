import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zelio_social/config/common.dart';
import 'package:zelio_social/model/result.dart';
import 'package:zelio_social/social/auth/cubit/login_cubit/login_cubit.dart';
import 'package:zelio_social/social/auth/model/login_model.dart';
import 'package:zelio_social/social/auth/signin_screen.dart';
import 'package:zelio_social/social/top_notch_bottom_nav/top_notch_bottom_nav.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  int buttonColor = 0xff26A9FF;
  bool inputTextNotNull = false;

  final formKey = GlobalKey<FormState>();
  bool passwordVisible = false;
  late StreamSubscription<bool> passwordSubscription;
  final passwordStreamController = StreamController<bool>.broadcast()
    ..add(true);
  final passwordKey = GlobalKey<FormFieldState>();

  @override
  void initState() {
    passwordSubscription = passwordStreamController.stream.listen((value) {
      log("${value}");
    });
    super.initState();
  }

  @override
  void dispose() {
    passwordSubscription.cancel();
    passwordStreamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double deviseWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 140),
                    child: Column(
                      children: [
                        AspectRatio(
                          aspectRatio: 5,
                          child: Image.asset(
                              "assets/social_media/3x/zelio_blue.png"),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Login",
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(fontFamily: FontFamily.w800),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 50),
                BlocConsumer<LoginCubit, Result<Loginuser>>(
                  listener: (context, state) {
                    if (state.data != null) {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => TopNotchBottomNav(),
                        ),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Login successfull!"),
                        ),
                      );
                    }
                    if (state.error != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(state.error.toString()),
                        ),
                      );
                    }
                  },
                  builder: (context, state) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Text("Username",
                              style: Theme.of(context).textTheme.titleMedium),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              boxShadow: const [
                                BoxShadow(
                                    offset: Offset(1, 1),
                                    color: Color.fromARGB(255, 218, 217, 217),
                                    spreadRadius: 2,
                                    blurRadius: 2)
                              ]),
                          child: TextFormField(
                            decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: BorderSide.none,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: BorderSide.none,
                                ),
                                prefixIcon: Icon(Icons.person_3_outlined),
                                prefixIconColor: Colors.black,
                                hintText: "Username",
                                hintStyle: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(color: Colors.grey)),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your username';
                              }
    
                              return null;
                            },
                            onSaved: (value) => context
                                .read<LoginCubit>()
                                .updateForm("username", value),
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                          ),
                        ),
                        const SizedBox(height: 30),
                        Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Text("Password",
                              style: Theme.of(context).textTheme.titleMedium),
                        ),
                        const SizedBox(height: 10),
                        StreamBuilder<bool>(
                            stream: passwordStreamController.stream,
                            builder: (context, snapshot) {
                              passwordVisible = snapshot.data ?? true;
                              return Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    boxShadow: const [
                                      BoxShadow(
                                          offset: Offset(1, 1),
                                          color: Color.fromARGB(
                                              255, 218, 217, 217),
                                          spreadRadius: 2,
                                          blurRadius: 2)
                                    ]),
                                child: TextFormField(
                                  key: passwordKey,
                                  obscureText: passwordVisible,
                                  decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.white,
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(30),
                                        borderSide: BorderSide.none,
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(30),
                                        borderSide: BorderSide.none,
                                      ),
                                      prefixIcon: Icon(Icons.lock_outline),
                                      prefixIconColor: Colors.black,
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                            !passwordVisible
                                                ? Icons.visibility_off
                                                : Icons.visibility,
                                            color: Colors.black),
                                        onPressed: () {
                                          passwordVisible = !passwordVisible;
                                          passwordStreamController
                                              .add(passwordVisible);
                                        },
                                      ),
                                      hintText: "Password",
                                      hintStyle: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(color: Colors.grey)),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your password';
                                    } else if (value.length < 8) {
                                      return 'Password must be at least 8 characters long';
                                    }
                                    return null;
                                  },
                                  onSaved: (value) => context
                                      .read<LoginCubit>()
                                      .updateForm("password", value),
                                  keyboardType: TextInputType.visiblePassword,
                                  textInputAction: TextInputAction.done,
                                  onFieldSubmitted: (value) {
                                    if (formKey.currentState!.validate()) {
                                      formKey.currentState?.save();
                                      context.read<LoginCubit>().login();
                                    }
                                  },
                                ),
                              );
                            }),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Text(
                    "Forgot password?",
                    textAlign: TextAlign.right,
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: Colors.blue, fontFamily: FontFamily.w700),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      fixedSize: Size(MediaQuery.sizeOf(context).width, 50),
                      backgroundColor:
                          Color.alphaBlend(Colors.blue, Colors.white)),
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      formKey.currentState?.save();
                      context.read<LoginCubit>().login();
                    }
                  },
                  child: context.watch<LoginCubit>().state.isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text("Login",
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(color: Colors.white)),
                ),
                const SizedBox(height: 30),
                Center(
                  child: Text(
                    'Or',
                    style: TextStyle(
                        fontSize: deviseWidth * .040, color: Colors.grey),
                  ),
                ),
                const SizedBox(height: 30),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Icon(
                    Icons.facebook,
                    color: Colors.blue,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    'Login with facebook',
                    style: context.theme.titleMedium!.copyWith(
                        color: Colors.blue, fontFamily: FontFamily.w700),
                  ),
                ]),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don't have an account?  ",
                        style: context.theme.titleMedium),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                                builder: (context) => SignInScreen()));
                      },
                      child: Text(
                        'Sign up',
                        style: context.theme.titleMedium!.copyWith(
                            color: Colors.blue, fontFamily: FontFamily.w700),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class HomeScreen {}
