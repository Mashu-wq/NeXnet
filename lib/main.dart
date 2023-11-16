import 'package:flutter/material.dart';
import 'package:nexnet/constants/routes.dart';
import 'package:nexnet/pages/add_post/add_post_page.dart';
import 'package:nexnet/pages/add_post/create_gig_page.dart';
import 'package:nexnet/pages/authentication/login_page.dart';
import 'package:nexnet/pages/authentication/signup_detail_page.dart';
import 'package:nexnet/pages/authentication/signup_page.dart';
import 'package:nexnet/pages/chat/chat_page.dart';
import 'package:nexnet/pages/home/comments_page.dart';
import 'package:nexnet/pages/home/home_screen.dart';
//import 'package:nexnet/pages/profile/edit_profile_page.dart';
import 'package:nexnet/pages/profile/profile_page.dart';
import 'package:nexnet/pages/root_page.dart';
import 'package:nexnet/pages/serach/search_page.dart';
import 'package:nexnet/services/auth/auth_services.dart';



void main() {
  WidgetsFlutterBinding.ensureInitialized();
  //await Firebase.initializeApp(
  //options: DefaultFirebaseOptions.currentPlatform,
//);
  runApp(
    MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'NeXnet',
    theme: ThemeData(brightness: Brightness.light),
    home:
    const AuthenticationWrapper(),
     routes: {
        loginRoute: (context) => const LogInPage(),
        signupRoute: (context) => const SignUpPage(),
        rootRoute:(context) => const RootPage(),
        signupDetailRoute:(context) => const SignupDetailPage(),
        homeRoute: (context) => const HomeScreen(),
        searchRoute: (context) => const SearchPage(),
        chatRoute:(context) => const ChatPage(),
        addPostRoute: (context) => const AddPostPage(),
        postCommentRoute: (context) => const CommentsPage(),
        profileRoute: (context) => const ProfilePage(),
        createGigRoute:(context) => const CreateGigPage(),
      },
  )); 
}

class AuthenticationWrapper extends StatefulWidget {
  const AuthenticationWrapper({super.key});

  @override
  State<AuthenticationWrapper> createState() => _AuthenticationWrapperState();
}

class _AuthenticationWrapperState extends State<AuthenticationWrapper> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AuthService.firebase().initialize(),
      builder: ((context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = AuthService.firebase().currentUser;
            if (user != null) {
              return const RootPage();
            } else {
              return const LogInPage();
            }
            default:
            return const CircularProgressIndicator();
        }
      }),
    );
  }
}


//color: Color.fromARGB(255, 83, 136, 162),
