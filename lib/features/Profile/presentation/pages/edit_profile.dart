import 'dart:io';
import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:coocoo/features/Profile/domain/profile_user.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:coocoo/features/Profile/presentation/blocs/profile_cubit.dart';
import 'package:coocoo/features/Profile/presentation/blocs/profile_state.dart';
import 'package:coocoo/features/Profile/presentation/components/my_text_field.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditProfile extends StatefulWidget {
  final ProfileUser user;

  EditProfile({super.key, required this.user});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  PlatformFile? imagePickedFile;

  Uint8List? webImage;

  Future<void> pickImage() async {
    final result = await FilePicker.platform
        .pickFiles(type: FileType.image, withData: kIsWeb);

    if (result != null) {
      setState(() {
        imagePickedFile = result.files.first;
        if (kIsWeb) {
          webImage = imagePickedFile!.bytes;
        }
      });
    }
  }

  final TextEditingController biotextcontroller = TextEditingController();

  late final ProfileCubit profileCubit;

  @override
  void initState() {
    super.initState();
    profileCubit = context.read<ProfileCubit>();
  }

  void updateProfile() async {
    final String uid = widget.user.uid;
    final imageMobilePath = kIsWeb ? null : imagePickedFile?.path;
    final imageWebBytes = kIsWeb ? imagePickedFile?.bytes : null;
    final String? newBio =
        biotextcontroller.text.isNotEmpty ? biotextcontroller.text : null;

    if (biotextcontroller.text.isNotEmpty || imagePickedFile != null) {
      profileCubit.UpdatProfile(
          uid: uid,
          newBio: newBio,
          imageMobilePath: imageMobilePath,
          imageWebBytes: imageWebBytes);
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubit, ProfileState>(
      listener: (context, state) {
        if (state is ProfileLoaded) {
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        if (state is ProfileLoading) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  Text("Uploading..."),
                ],
              ),
            ),
          );
        } else {
          return buildEditPage();
        }
      },
    );
  }

  Widget buildEditPage() {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
        foregroundColor: Theme.of(context).colorScheme.primary,
        actions: [
          IconButton(onPressed: updateProfile, icon: Icon(Icons.upload)),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          children: [
            Center(
              child: Container(
                  height: 200,
                  width: 200,
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondary,
                      shape: BoxShape.circle),
                  clipBehavior: Clip.hardEdge,
                  child: (!kIsWeb && imagePickedFile != null)
                      ? Image.file(
                          File(imagePickedFile!.path!),
                          fit: BoxFit.cover,
                        )
                      : (kIsWeb && imagePickedFile != null)
                          ? Image.memory(
                              webImage!,
                              fit: BoxFit.cover,
                            )
                          : CachedNetworkImage(
                              imageUrl: widget.user.profileImageUrl,
                              placeholder: (context, url) =>
                                  const CircularProgressIndicator(),
                              errorWidget: (context, url, Error) => Icon(
                                Icons.person,
                                size: 72,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              imageBuilder: (context, imageProvider) => Image(
                                image: imageProvider,
                                fit: BoxFit.cover,
                              ),
                            )),
            ),
            SizedBox(
              height: 25,
            ),
            Center(
              child: MaterialButton(
                onPressed: pickImage,
                color: Colors.blue,
                child: Text("Pick Image"),
              ),
            ),
            Text("Bio"),
            const SizedBox(height: 25),
            MyTextField(
              controller: biotextcontroller,
              hintText: 'Enter your bio',
              obscureText: false,
            ),
          ],
        ),
      ),
    );
  }
}
