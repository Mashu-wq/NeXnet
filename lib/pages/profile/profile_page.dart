import 'package:flutter/material.dart';
import 'package:nexnet/constants/routes.dart';
import 'package:nexnet/enums/menu_actions.dart';
import 'package:nexnet/pages/add_post/add_post_page.dart';
import 'package:nexnet/pages/chat/chat_detail_page.dart';
//import 'package:nexnet/pages/profile/edit_profile_page.dart';
//import 'package:nexnet/pages/chat/chat_detail_page.dart';
//import 'package:nexnet/pages/profile/edit_profile_page.dart';
import 'package:nexnet/pages/profile/tabs/posts_tab.dart';
import 'package:nexnet/pages/profile/tabs/services_tab.dart';
import 'package:nexnet/services/auth/auth_services.dart';
import 'package:nexnet/services/cloud/cloud_user/cloud_user.dart';
import 'package:nexnet/services/cloud/cloud_user/cloud_user_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key, this.userId});
  final String? userId;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  final currentUser = AuthService.firebase().currentUser!;
  String get currentUserId => currentUser.id;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
    tabController.addListener(() {
      // setState(() {});
    });
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  Future<bool> follow(CloudUser followUser) async {
    final user =
        await CloudUserService.firebase().getUser(userId: currentUserId);
    final res = await CloudUserService.firebase().followUser(user!, followUser);

    setState(() {});
    return res;
  }

  Future<String> isfollowing(CloudUser followUser) async {
    final user =
        await CloudUserService.firebase().getUser(userId: currentUserId);
    final res =
        await CloudUserService.firebase().isFollowing(user!, followUser);
    if (res) {
      return 'following';
    } else {
      return 'follow';
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: CloudUserService.firebase()
          .getUser(userId: widget.userId ?? currentUserId),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            if (snapshot.hasData) {
              final cloudUser = snapshot.data as CloudUser;
              return Scaffold(
                backgroundColor: Colors.white,
                appBar: AppBar(
                  backgroundColor: const Color.fromARGB(255, 59, 78, 87),
                  elevation: 0,
                  centerTitle: true,
                  leading: widget.userId == null
                      ? Padding(
                          padding: const EdgeInsets.fromLTRB(10, 10, 0, 7),
                          child: IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const AddPostPage(),
                                ),
                              );
                            },
                            icon: Image.asset(
                              'assets/icons/plus.png',
                              color: Colors.grey.shade300,
                            ),
                          ),
                        )
                      : null,
                  title: Text(
                    '@${cloudUser.userName}',
                    style: const TextStyle(fontSize: 18),
                  ),
                  actions: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 9, 9, 9),
                      child: PopupMenuButton(
                        icon: Image.asset(
                          'assets/icons/menu.png',
                          color: Colors.grey.shade300,
                        ),
                        onSelected: (value) async {
                          switch (value) {
                            case MenuAction.logout:
                              await AuthService.firebase().logout();
                              if (!mounted) return;
                              Navigator.of(context).popAndPushNamed(
                                loginRoute,
                              );
                          }
                        },
                        itemBuilder: (context) {
                          return [
                            const PopupMenuItem(
                              value: MenuAction.logout,
                              child: Text('Log out'),
                            ),
                          ];
                        },
                      ),
                    ),
                  ],
                ),
                body: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Container(
                            alignment: Alignment.centerRight,
                            child: Column(
                              children: [
                                Text(
                                  cloudUser.following.length.toString(),
                                  style: const TextStyle(
                                    color: Colors.black87,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                const Text(
                                  'Following',
                                  style: TextStyle(color: Colors.black87),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            height: 72,
                            width: 72,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: const Color.fromARGB(255, 59, 78, 87),
                                width: 3,
                              ),
                            ),
                            child: CircleAvatar(
                              backgroundImage:
                                  NetworkImage(cloudUser.profileUrl!),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            alignment: Alignment.centerLeft,
                            child: Column(
                              children: [
                                Text(
                                  cloudUser.follower.length.toString(),
                                  style: const TextStyle(
                                    color: Colors.black87,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                const Text(
                                  'Followers',
                                  style: TextStyle(
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
    
                    // username
                    Padding(
                      padding: const EdgeInsets.fromLTRB(26, 18, 26, 14),
                      child: Column(
                        children: [
                          Text(
                            '${cloudUser.fullName} | ${cloudUser.profession}',
                            maxLines: 1,
                            style: const TextStyle(
                              color: Colors.black87,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(
                            height: 14,
                          ),
                          cloudUser.description != null
                              ? Text(
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  cloudUser.description!,
                                  style: const TextStyle(
                                    color: Colors.black87,
                                  ),
                                )
                              : const SizedBox.shrink(),
                        ],
                      ),
                    ),
    
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        /*ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(140, 40),
                            backgroundColor:
                                //                            const Color.fromARGB(255, 59, 78, 87),
                                Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(0.0),
                            ),
                          ),
                          onPressed: () async {
                            widget.userId != null
                                ? await follow(cloudUser)
                                : Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const EditProfile(),
                                      // ChatDetailPage(sendToUser: cloudUser),
                                      //EditProfilePage
                                    ),
                                  );
                          },
                          child: FutureBuilder(
                            future: isfollowing(cloudUser),
                            builder: (context, snapshot) {
                              switch (snapshot.connectionState) {
                                case ConnectionState.done:
                                  if (snapshot.hasData) {
                                    final isFollowing = snapshot.data as String;
                                    return Text(
                                      widget.userId != null
                                          ? isFollowing
                                          : 'Edit Profile',
                                    );
                                  } else {
                                    return const Center(
                                      child: Center(
                                        child: Text(
                                          '',
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      ),
                                    );
                                  }
    
                                default:
                                  return const CircularProgressIndicator();
                              }
                            },
                          ),
                        ),*/
                        widget.userId != null
                            ? const SizedBox(
                                width: 12,
                              )
                            : const SizedBox.shrink(),
                        widget.userId != null
                            ? ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  minimumSize: const Size(140, 40),
                                  backgroundColor:
                                      const Color.fromARGB(255, 59, 78, 87),
                                  elevation: 1,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(22),
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ChatDetailPage(sendToUser: cloudUser),
                                    ),
                                  );
                                },
                                child: const Text(
                                  'Contact',
                                  style: TextStyle(color: Colors.white),
                                ),
                              )
                            : const SizedBox.shrink(),
                      ],
                    ),
                    TabBar(
                      controller: tabController,
                      indicatorColor: Colors.transparent,
                      padding: const EdgeInsets.only(top: 14),
                      tabs: [
                        Tab(
                          icon: tabController.index == 0
                              ? Image.asset(
                                  'assets/icons/grid-2.png',
                                  color: Colors.black87,
                                  height: 18,
                                )
                              : Image.asset(
                                  'assets/icons/grid.png',
                                  color: Colors.black87,
                                  height: 18,
                                ),
                        ),
                        Tab(
                          icon: tabController.index == 1
                              ? Image.asset(
                                  'assets/icons/list-2.png',
                                  color: Colors.black87,
                                  height: 20,
                                )
                              : Image.asset(
                                  'assets/icons/list.png',
                                  color: Colors.black87,
                                  height: 20,
                                ),
                        ),
                        Tab(
                          icon: tabController.index == 2
                              ? Image.asset(
                                  'assets/icons/info-button.png',
                                  color: Colors.black87,
                                  height: 20,
                                )
                              : Image.asset(
                                  'assets/icons/information.png',
                                  color: Colors.black87,
                                  height: 20,
                                ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: TabBarView(
                        controller: tabController,
                        children: const [
                          PostsTab(),
                          ServicesTab(),
                          ServicesTab(),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return const Scaffold(
                body: Center(
                  child: Center(
                    child: Text(
                      'No internet connection',
                      style: TextStyle(color: Colors.black87),
                    ),
                  ),
                ),
              );
            }
          default:
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
        }
      },
    );
  }
}
