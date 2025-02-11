import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zelio_social/config/common.dart';
import 'package:zelio_social/model/result.dart';
import 'package:zelio_social/social/auth/cubit/login_cubit/login_cubit.dart';
import 'package:zelio_social/social/auth/cubit/signup_cubit/signup_cubit.dart';
import 'package:zelio_social/social/auth/loginscreen.dart';
import 'package:zelio_social/social/auth/model/login_model.dart';
import 'package:zelio_social/social/auth/service/login_services.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool passwordVisible = false;

late StreamSubscription<bool> passwordSubscription;
final passwordStreamController = StreamController<bool>()..add(true);


  final registerKey = GlobalKey<FormState>();
  final passwordKey = GlobalKey<FormFieldState>();

@override
  void dispose() {
    passwordSubscription.cancel();
    passwordStreamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: registerKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                          "Sign Up",
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
                const SizedBox(height: 10),
                BlocConsumer<SignupCubit, Result<User>>(
                  listener: (context, state) {
                    if (state.data != null) {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => BlocProvider(
                            create: (context) =>
                                LoginCubit(context.read<LoginServices>()),
                            child: const LoginScreen(),
                          ),
                        ),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Signup successfull!"),
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
                              prefixIcon: Icon(Icons.group_outlined),
                              prefixIconColor: Colors.black,
                              hintText: "Name",
                              hintStyle: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(color: Colors.grey),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your name';
                              }
    
                              return null;
                            },
                            onSaved: (value) => context
                                .read<SignupCubit>()
                                .updateForm("username", value),
                            textInputAction: TextInputAction.next,
                          ),
                        ),
                        const SizedBox(height: 30),
                        Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Text("Email",
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
                                prefixIcon: Icon(Icons.email_outlined),
                                prefixIconColor: Colors.black,
                                hintText: "Email",
                                hintStyle: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(color: Colors.grey)),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your email';
                              }
                              final regex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                              if (!regex.hasMatch(value)) {
                                return 'Please enter a valid email address';
                              }
                              return null;
                            },
                            onSaved: (value) => context
                                .read<SignupCubit>()
                                .updateForm("email", value),
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
                                        color: Color.fromARGB(255, 218, 217, 217),
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
                                      borderRadius: BorderRadius.circular(30),
                                      borderSide: BorderSide.none,
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30),
                                      borderSide: BorderSide.none,
                                    ),
                                    prefixIcon: Icon(Icons.lock_outline),
                                    prefixIconColor: Colors.black,
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                          passwordVisible
                                              ? Icons.visibility_off
                                              : Icons.visibility,
                                          color: Colors.black),
                                      onPressed: () {
                                        passwordVisible = !passwordVisible;
                                        passwordStreamController.add(passwordVisible);
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
                                    .read<SignupCubit>()
                                    .updateForm("password", value),
                                keyboardType: TextInputType.visiblePassword,
                                textInputAction: TextInputAction.done,
                                onFieldSubmitted: (value) {
                                  if (registerKey.currentState!.validate()) {
                                    registerKey.currentState!.save();
                                    context.read<SignupCubit>().signup();
                                  }
                                },
                              ),
                            );
                          }
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 50),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                      backgroundColor: Colors.blue,
                      fixedSize: Size(MediaQuery.sizeOf(context).width, 50)),
                  onPressed: () {
                    if (registerKey.currentState!.validate()) {
                      registerKey.currentState!.save();
                      context.read<SignupCubit>().signup();
                    }
                  },
                  child: context.watch<SignupCubit>().state.isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text("Sign Up",
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(color: Colors.white)),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Already have an account?  ",
                        style: context.theme.titleMedium),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                                builder: (context) => LoginScreen()));
                      },
                      child: Text(
                        'Log In',
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
