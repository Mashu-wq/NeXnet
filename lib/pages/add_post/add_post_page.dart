import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nexnet/constants/routes.dart';
//import 'package:nexnet/pages/add_post/upload_api_image.dart';
import 'package:nexnet/services/auth/auth_services.dart';
import 'package:nexnet/services/cloud/cloud_post/cloud_post.dart';
import 'package:nexnet/services/cloud/cloud_post/cloud_post_service.dart';
import 'package:nexnet/services/cloud/cloud_user/cloud_user.dart';
import 'package:nexnet/services/cloud/cloud_user/cloud_user_service.dart';
import 'package:nexnet/services/storage/firebase_file_storage.dart';
import 'package:nexnet/utilities/picker/pick_image.dart';
import 'package:uuid/uuid.dart';
//import 'package:http/http.dart' as http;

class AddPostPage extends StatefulWidget {
  const AddPostPage({super.key});

  @override
  State<AddPostPage> createState() => _AddPostPageState();
}

class _AddPostPageState extends State<AddPostPage> {
  
  late final TextEditingController _captionController;

  final currentUser = AuthService.firebase().currentUser!;
  String get userId => currentUser.id;

  XFile? _image;

  @override
  void initState() {
    _captionController = TextEditingController();
    super.initState();
  }

  Future addPost() async {
    if (_image != null) {
      final postUrl = await FirebaseFileStorage().uploadPostImage(
        userId: userId,
        image: File(_image!.path),
        imageName: _image!.name,
      );

      String postId = const Uuid().v1();
      final user = await CloudUserService.firebase().getUser(userId: userId);
      final profileUrl = user!.profileUrl;

      CloudPost cloudPost = CloudPost(
        userId: userId,
        postId: postId,
        profileUrl: profileUrl!,
        fullName: user.fullName,
        profession: user.profession,
        publishedTime: DateTime.now(),
        postUrl: postUrl,
        likes: const [],
        caption: _captionController.text,
      );
      CloudPostService.firebase().createNewPost(cloudPost);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            pinned: true,
            backgroundColor: const Color.fromARGB(255, 83, 136, 162),
            centerTitle: false,
            elevation: 0,
            title: const Text('Add Post'),
            actions: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 12, 10),
                child: ElevatedButton(
                  onPressed: () {
                    addPost();
                    if (!mounted) return;
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 83, 136, 162),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  child: const Text(
                    'Post',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(58.0),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Container(
                  padding: const EdgeInsets.only(left: 8),
                  height: 44,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(120, 40),
                          backgroundColor:
                              const Color.fromARGB(255, 83, 136, 162),
                          elevation: 1,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(22),
                          ),
                        ),
                        onPressed: () async {
                          
                          //getImage();
                          final image = await pickImage(ImageSource.gallery);
                          if (image != null) {
                            
                            setState(() {
                             
                              _image = image;
                            });
                          }
                           else {
                            // throw exception in ui
                          }
                        },
                        child: const Text('Attach Image'),
                      ),
                      const VerticalDivider(),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(120, 40),
                          backgroundColor:
                              const Color.fromARGB(255, 83, 136, 162),
                          elevation: 1,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(22),
                          ),
                        ),
                        onPressed: () async {
                          final image = await pickImage(ImageSource.camera);
                          if (image != null) {
                            setState(() {
                              _image = image;
                            });
                          } else {
                            // throw exception in ui
                          }
                        },
                        child: const Text('Capture photo'),
                      ),
                      const VerticalDivider(),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(120, 40),
                          backgroundColor:
                              const Color.fromARGB(255, 83, 136, 162),
                          elevation: 1,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(22),
                          ),
                        ),
                        onPressed: () async {
                          Navigator.of(context).pushReplacementNamed(
                            createGigRoute,
                            // (Route<dynamic> route) => false,
                          );
                        },
                        child: const Text('Create gig'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: FutureBuilder(
              future: CloudUserService.firebase().getUser(userId: userId),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final cloudUser = snapshot.data as CloudUser;
                  return Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: _image != null
                        ? PostCard(
                            profileUrl: cloudUser.profileUrl ?? '',
                            postUrl: _image!.path,
                            userName: cloudUser.userName,
                            profession: cloudUser.profession,
                          )
                        : const SizedBox.shrink(),
                  );
                } else {
                  return const SizedBox.shrink();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class PostCard extends StatelessWidget {
  final String postUrl;
  final String profileUrl;
  final String userName;
  final String profession;
  const PostCard(
      {super.key,
      required this.profileUrl,
      required this.postUrl,
      required this.userName,
      required this.profession});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      height: 550,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(
          Radius.circular(36),
        ),
        color: Colors.black54,
        image:
            DecorationImage(fit: BoxFit.cover, image: FileImage(File(postUrl))),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 20,
            left: 20,
            right: 10,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.black54, width: 2),
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(profileUrl),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userName,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(profession)
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Positioned(
            bottom: 0,
            left: 15,
            right: 20,
            child: TextField(
              // controller: _captionController,
              maxLines: 2,
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(
                hintText: 'Caption your shot.',
                border: InputBorder.none,
                hintStyle: TextStyle(fontSize: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
