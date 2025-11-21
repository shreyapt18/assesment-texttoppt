// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:task_shreya/authentication/presentation/home_screen.dart';
//
// import 'authentication/bloc/theme_bloc/theme_bloc.dart';
// import 'authentication/presentation/login_screen.dart';
//
//
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//
//   await Supabase.initialize(
//     url: 'https://tppspvyokkvyvtfimsnr.supabase.co',
//     anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InRwcHNwdnlva2t2eXZ0Zmltc25yIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjM2MTg4NDEsImV4cCI6MjA3OTE5NDg0MX0.MEx8C-3uHs53pxzLVRQAhkxkvO0VrBJxVASh1InQRYM',
//   );
//
//   runApp(
//     BlocProvider(
//       create: (_) => ThemeBloc(),
//       child: MyApp(),
//     ),
//   );
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<ThemeBloc, ThemeState>(
//       builder: (context, state) {
//         return MaterialApp(
//           debugShowCheckedModeBanner: false,
//           title: 'MagicSlides BLoC Auth',
//           theme: state.theme,
//           home: LoginScreen(),
//         );
//       },
//     );
//   }
// }



import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'authentication/bloc/theme_bloc/theme_state.dart';
import 'authentication/presentation/login_screen.dart';
import 'authentication/bloc/theme_bloc/theme_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'YOUR_SUPABASE_URL',
    anonKey: 'YOUR_SUPABASE_KEY',
  );

  runApp(
    BlocProvider(
      create: (_) => ThemeBloc(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, themeState) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'MagicSlides BLoC Auth',
          theme: themeState?.themeData,
          home: LoginScreen(),
        );
      },
    );
  }
}
