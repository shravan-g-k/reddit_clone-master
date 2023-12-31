import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/core/common/sign_in_button.dart';
import 'package:reddit_clone/features/auth/controller/auth_controller.dart';
import 'package:reddit_clone/responsive/responsive.dart';

import '../../../core/constants/constants.dart';
import 'loading_screen.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  void singInAsGuest(WidgetRef ref, BuildContext context) {
    ref.read(authControllerProvider.notifier).signInAsGuest(context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(authControllerProvider);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Image.asset(
          Constants.logoPath,
          height: 40,
        ),
        actions: [
          TextButton(
              onPressed: () => singInAsGuest(ref, context),
              child: const Text(
                'Skip',
                style: TextStyle(fontWeight: FontWeight.bold),
              ))
        ],
      ),
      body: isLoading
          ? const Loader()
          : Column(
              children: [
                const SizedBox(height: 20),
                const Text(
                  'Dive into anything',
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(
                    Constants.loginEmotePath,
                    height: 400,
                  ),
                ),
                const SizedBox(height: 20),
                const Responsive(child: SignInButton())
              ],
            ),
    );
  }
}
