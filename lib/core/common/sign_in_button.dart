import 'package:flutter/material.dart';
import 'package:reddit_clone/palletes.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/auth/controller/auth_controller.dart';
import '../constants/constants.dart';

class SignInButton extends ConsumerWidget {
  final bool isFromLogin;
  const SignInButton({super.key, this.isFromLogin = true});

  void signInWithGoogle(BuildContext context, WidgetRef ref) {
    ref.read(authControllerProvider.notifier).signInWithGoogle(context,isFromLogin);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton.icon(
      onPressed: () => signInWithGoogle(context, ref),
      icon: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Image.asset(
          Constants.googlePath,
          width: 35,
        ),
      ),
      label: const Text(
        'Continue with Google',
        style: TextStyle(fontSize: 18),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Pallete.greyColor,
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
}
