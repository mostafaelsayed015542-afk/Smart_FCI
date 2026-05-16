import 'package:chat_bot/features/chat/data/repos/chat_repo.dart';
import 'package:chat_bot/features/chat/data/repos/chat_repo_impl.dart'; // ← new impl
import 'package:chat_bot/features/splash/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ChatBot());
}

class ChatBot extends StatelessWidget {
  const ChatBot({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<ChatRepo>(
      // Provide the concrete implementation that talks to the ngrok API
      create: (context) => ChatRepoImpl(),
      child: ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        child: MaterialApp(
          theme: ThemeData(textTheme: GoogleFonts.nunitoTextTheme()),
          debugShowCheckedModeBanner: false,
          home: const SplashScreen(),
        ),
      ),
    );
  }
}
