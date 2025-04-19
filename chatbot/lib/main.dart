import 'package:chatbot/core/theme/app_theme.dart';
import 'package:chatbot/features/blocs/chat/chat-bloc.dart';
import 'package:chatbot/features/blocs/login/login_bloc.dart';
import 'package:chatbot/features/blocs/profile/profile_bloc.dart';
import 'package:chatbot/features/blocs/signup/signup_bloc.dart';
import 'package:chatbot/features/data/repositories/auth_repository.dart';
import 'package:chatbot/features/data/repositories/chat_repository.dart';
import 'package:chatbot/features/data/repositories/profile_repository.dart';
import 'package:chatbot/features/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


final getIt = GetIt.instance;

void setupDependencies() {
  getIt.registerSingleton<AuthRepository>(AuthRepository());
  getIt.registerFactory<LoginBloc>(() => LoginBloc(authRepository: getIt<AuthRepository>()));
  getIt.registerFactory<SignupBloc>(() => SignupBloc(authRepository: getIt<AuthRepository>()));
   getIt.registerSingleton<ChatRepository>(ChatRepository());
  getIt.registerFactory<ChatBloc>(() => ChatBloc(getIt<ChatRepository>()));

  getIt.registerSingleton<ProfileRepository>(ProfileRepository());
  getIt.registerFactory<ProfileBloc>(() => ProfileBloc(getIt<ProfileRepository>()));
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: "assets/.env");

  await Supabase.initialize(
    anonKey: dotenv.env['SUPABASE_KEY']!,
    url: dotenv.env['SUPABASE_URL']!,
  );

  Gemini.init(apiKey: dotenv.env['GEMINI_API']!,);

  setupDependencies();

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LoginBloc>(create: (_) => getIt<LoginBloc>()),
        BlocProvider<SignupBloc>(create: (_) => getIt<SignupBloc>()),
        BlocProvider<ChatBloc>(create: (_) => getIt<ChatBloc>()),
        BlocProvider<ProfileBloc>(create: (_) => getIt<ProfileBloc>()),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        theme: AppTheme().lightTheme,
        darkTheme: AppTheme().darkTheme,
        themeMode: ThemeMode.system,
        routerConfig: AppRouter.router,
      ),
    );
  }
}
