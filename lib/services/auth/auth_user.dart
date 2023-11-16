import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/material.dart';

@immutable
class AuthUser {
  final String id;
  final String email;
  final bool isEmailVerified;
  const AuthUser({
    required this.id,
    required this.email,
    required this.isEmailVerified,
  });

// it is basically ask user to provide user (if .fromFirebase called) and set the value in var
  factory AuthUser.fromFirebase(User user) => AuthUser(
        id: user.uid,
        email: user.email!,
        isEmailVerified: user.emailVerified,
      );
}
