import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news_app/models/user.dart';
import 'package:news_app/providers/auth_provider.dart';
import 'package:news_app/providers/user_provider.dart';
import 'package:news_app/screens/home/home_screen.dart';
import 'package:news_app/screens/login_screen.dart';
import 'package:news_app/utilities/constants.dart';
import 'package:news_app/utilities/extensions.dart';
import 'package:news_app/utilities/scaffold.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  ValueNotifier<bool> loading = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      loading: loading,
      child: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Text(
                        "Sign up",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                      Spacer(),
                      // Icon(Icons.close_outlined)
                    ],
                  ),
                  32.height,
                  const Text(
                    "Name",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  8.height,
                  TextField(
                    controller: nameController,
                    decoration: inputDecoration,
                  ),
                  20.height,
                  const Text(
                    "Email",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  8.height,
                  TextFormField(
                    controller: emailController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      final bool emailValid = emailRegEx.hasMatch(value!);
                      if (emailValid) {
                        return null;
                      } else {
                        return "Email not valid";
                      }
                    },
                    decoration: inputDecoration,
                  ),
                  20.height,
                  const Text(
                    "Password",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  8.height,
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      final valid = value!.length >= 8;
                      if (valid) {
                        return null;
                      } else {
                        return "Password must be 8 characters or more";
                      }
                    },
                    controller: passwordController,
                    decoration: inputDecoration.copyWith(
                      suffixIcon: const Icon(Icons.visibility),
                    ),
                  ),
                  24.height,
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          loading.value = true;

                          final response = await ref
                              .read(authenticationProvider)
                              .signUpWithEmailAndPassword(emailController.text,
                                  passwordController.text);
                          response.fold(
                            (error) =>
                                ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(error),
                              ),
                            ),
                            (userId) {
                              ref.read(userRepositoryProvider).addUser(User(
                                  id: userId,
                                  name: nameController.text.capitalize()));
                              return Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (context) {
                                    return const HomeScreen();
                                  },
                                ),
                              );
                            },
                          );
                        }
                      },
                      child: const Center(child: Text("Sign up"))),
                  24.height,
                  const Divider(),
                  24.height,
                  Center(
                    child: Column(
                      children: [
                        const Text("Already have an account?"),
                        4.height,
                        InkWell(
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginScreen(),
                              ),
                            );
                          },
                          child: Text(
                            "Log in",
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).primaryColor),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
