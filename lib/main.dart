import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'authentication/presentation/login_screen.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://tppspvyokkvyvtfimsnr.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InRwcHNwdnlva2t2eXZ0Zmltc25yIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjM2MTg4NDEsImV4cCI6MjA3OTE5NDg0MX0.MEx8C-3uHs53pxzLVRQAhkxkvO0VrBJxVASh1InQRYM',
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MagicSlides BLoC Auth',
      home: LoginScreen(),
    );
  }
}
