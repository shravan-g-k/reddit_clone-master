import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/core/common/error_text.dart';
import 'package:reddit_clone/core/common/sign_in_button.dart';
import 'package:reddit_clone/features/auth/screens/loading_screen.dart';
import 'package:reddit_clone/features/community/controller/community_controller.dart';
import 'package:reddit_clone/models/community_model.dart';
import 'package:routemaster/routemaster.dart';

import '../../auth/controller/auth_controller.dart';

class CommunityListDrawer extends ConsumerWidget {
  const CommunityListDrawer({super.key});

  void navigateToCreateCommunity(BuildContext context) {
    Routemaster.of(context).push('/create-community');
  }

  void navigateToCommunity(BuildContext context, Community community) {
    Routemaster.of(context).push('/r/${community.name}');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;
    final isGuest = !user.isAuthenticated;

    return SafeArea(
      child: Drawer(
        child: Column(
          children: [
            isGuest
                ? const SignInButton()
                : ListTile(
                    leading: const Icon(Icons.add),
                    title: const Text('Create a community'),
                    onTap: () => navigateToCreateCommunity(context),
                  ),
              if(!isGuest)
            ref.watch(userCommunitiesProvider).when(
                  data: (communities) {
                    return Expanded(
                      child: ListView.builder(
                        itemBuilder: (context, index) {
                          final community = communities[index];
                          return ListTile(
                            leading: CircleAvatar(
                                backgroundImage:
                                    NetworkImage(community.avatar)),
                            title: Text('r/${community.name}'),
                            onTap: () {
                              navigateToCommunity(context, community);
                            },
                          );
                        },
                        itemCount: communities.length,
                      ),
                    );
                  },
                  error: (error, stackTrace) {
                    return ErrorText(error: error.toString());
                  },
                  loading: () => const Loader(),
                )
          ],
        ),
      ),
    );
  }
}
