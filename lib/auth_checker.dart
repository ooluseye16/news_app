import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news_app/providers/auth_provider.dart';
import 'package:news_app/screens/home/home_screen.dart';
import 'package:news_app/screens/login_screen.dart';

class AuthChecker extends ConsumerWidget {
  const AuthChecker({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    return Scaffold(
      body: authState.when(
        data: (data) {
          if (data != null) {
            return const HomeScreen();
          }
          return const LoginScreen();
        },
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (e, trace) => Center(
          child: Text(e.toString()),
        ),
      ),
    );
  }
}
