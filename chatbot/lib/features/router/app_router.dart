import 'dart:io';

import 'package:chatbot/features/presentation/screens/home.dart';
import 'package:chatbot/features/presentation/screens/login.dart';
import 'package:chatbot/features/presentation/screens/signup.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: Supabase.instance.client.auth.currentSession != null ? '/home' : '/login',
    routes: [
      GoRoute(path: '/login', builder: (context, state) => const Login()),
      GoRoute(path: '/signup', builder: (context, state) => const Signup()),
      GoRoute(path: '/home', builder: (context, state) => const Home()),

    //   ShellRoute(
    //     builder: (context, state, child) {
    //       return C
    //     },
    //     routes: [
    //       GoRoute(path: '/home', builder: (context, state) => Home()),
    //     ],
    //   ),
     ], 
    );
}