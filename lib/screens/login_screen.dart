import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news_app/providers/auth_provider.dart';
import 'package:news_app/screens/signup_screen.dart';
import 'package:news_app/utilities/constants.dart';
import 'package:news_app/utilities/extensions.dart';
import 'package:news_app/utilities/scaffold.dart';

import 'home/home_screen.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  void dispose() {
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
                      "Log in",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                    Spacer(),
                    // Icon(Icons.close_outlined)
                  ],
                ),
                32.height,
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
                        suffixIcon: const Icon(Icons.visibility))),
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
                            .signInWithEmailAndPassword(
                                emailController.text, passwordController.text);
                        response.fold(
                          (error) => ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(error),
                            ),
                          ),
                          (signedIn) {
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
                    child: const Center(child: Text("Log in"))),
                24.height,
                const Divider(),
                24.height,
                Center(
                  child: Column(
                    children: [
                      const Text("Don't have an account?"),
                      4.height,
                      InkWell(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SignUpScreen(),
                            ),
                          );
                        },
                        child: Text(
                          "Sign up",
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
      )),
    );
  }
}
