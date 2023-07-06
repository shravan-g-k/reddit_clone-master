import 'dart:io';
import 'dart:typed_data';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/features/auth/controller/auth_controller.dart';

import '../../../core/common/error_text.dart';
import '../../../core/constants/constants.dart';
import '../../../core/utils.dart';
import '../../../palletes.dart';
import '../../../responsive/responsive.dart';
import '../../auth/screens/loading_screen.dart';
import '../controller/user_profile_controller.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  final String uid;
  const EditProfileScreen({super.key, required this.uid});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  File? bannerFile;
  File? profileFile;
  Uint8List? bannerWebFile;
  Uint8List? profileWebFile;
  late TextEditingController nameController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: ref.read(userProvider)!.name);
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  void selectBannerImage() async {
    final res = await pickImage();
    if (res != null) {
      if (kIsWeb) {
        setState(() {
          bannerWebFile = res.files.first.bytes;
        });
        return;
      } else {
        setState(() {
          bannerFile = File(res.files.first.path!);
        });
      }
    }
  }

  void selectProfileImage() async {
    final res = await pickImage();
    if (res != null) {
      if (kIsWeb) {
        setState(() {
          profileWebFile = res.files.first.bytes;
        });
        return;
      } else {
        setState(() {
          profileFile = File(res.files.first.path!);
        });
      }
    }
  }

  void save() {
    ref.read(userProfileControllerProvider.notifier).editCommunity(
          bannerFile: bannerFile,
          profilefile: profileFile,
          name: nameController.text.trim(),
          context: context,
          bannerWebFile: bannerWebFile,
          profileWebFile: profileWebFile,
        );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(userProfileControllerProvider);
    final currentTheme = ref.watch(themeNotifierProvider);
    return ref.watch(getUserDataProvider(widget.uid)).when(
          data: (user) {
            return Scaffold(
              backgroundColor: currentTheme.backgroundColor,
              appBar: AppBar(
                title: const Text("Edit Profile"),
                centerTitle: false,
                actions: [
                  TextButton(
                    onPressed: save,
                    child: const Text('Save'),
                  ),
                ],
              ),
              body: isLoading
                  ? const Loader()
                  : Responsive(
                    child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 200,
                              child: Stack(
                                children: [
                                  GestureDetector(
                                    onTap: selectBannerImage,
                                    child: DottedBorder(
                                      borderType: BorderType.RRect,
                                      radius: const Radius.circular(10),
                                      dashPattern: const [10, 4],
                                      strokeCap: StrokeCap.round,
                                      color: currentTheme
                                          .textTheme.bodyText2!.color!,
                                      child: Container(
                                          width: double.infinity,
                                          height: 150,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: bannerWebFile != null
                                              ? Image.memory(bannerWebFile!)
                                              : bannerFile != null
                                                  ? Image.file(bannerFile!)
                                                  : user.banner.isEmpty ||
                                                          user.banner ==
                                                              Constants
                                                                  .bannerDefault
                                                      ? const Center(
                                                          child: Icon(
                                                            Icons
                                                                .camera_alt_rounded,
                                                            size: 40,
                                                          ),
                                                        )
                                                      : Image.network(
                                                          user.banner)),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 20,
                                    left: 20,
                                    child: GestureDetector(
                                      onTap: selectProfileImage,
                                      child: profileWebFile != null
                                          ? CircleAvatar(
                                              radius: 32,
                                              backgroundImage:
                                                  MemoryImage(profileWebFile!),
                                            )
                                          : CircleAvatar(
                                              backgroundImage: profileFile != null
                                                  ? Image.file(profileFile!).image
                                                  : Image.network(user.profile)
                                                      .image,
                                            ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            TextField(
                              controller: nameController,
                              decoration: InputDecoration(
                                  filled: true,
                                  hintText: 'Name',
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                        color: Colors.blue,
                                      ),
                                      borderRadius: BorderRadius.circular(10)),
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.all(18)),
                            )
                          ],
                        ),
                      ),
                  ),
            );
          },
          error: (error, stackTrace) => ErrorText(error: error.toString()),
          loading: () => const Loader(),
        );
  }
}
