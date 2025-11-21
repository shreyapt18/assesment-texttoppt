import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_shreya/authentication/data/auth_repo.dart';
import 'package:task_shreya/authentication/bloc/auth_bloc.dart';
import 'package:task_shreya/authentication/bloc/auth_event.dart';
import 'package:task_shreya/authentication/bloc/auth_state.dart';
import 'package:task_shreya/authentication/bloc/theme_bloc/theme_bloc.dart';
import '../bloc/theme_bloc/theme_event.dart';
import '../bloc/theme_bloc/theme_state.dart';
import 'home_screen.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, themeState) {
        return BlocProvider(
          create: (_) => AuthBloc(AuthRepository()),
          child: Scaffold(
            appBar: AppBar(
              title: Text("Login"),
              actions: [
                IconButton(
                  icon: Icon(Icons.brightness_6),
                  onPressed: () {
                    context.read<ThemeBloc>().add(ToggleThemeEvent());
                  },
                ),
              ],
            ),
            backgroundColor: themeState?.themeData.scaffoldBackgroundColor,
            body: BlocConsumer<AuthBloc, AuthState>(
              listener: (context, state) {
                if (state is AuthSuccess) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => HomeScreen(
                        loggedInEmail: emailController.text.trim(),
                      ),
                    ),
                  );
                } else if (state is AuthFailure) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              builder: (context, state) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Container(
                      width: 350,
                      padding: EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: themeState.themeData.cardColor,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 10,
                            spreadRadius: 2,
                            offset: Offset(0, 4),
                          )
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Center(
                            child: Text(
                              "Login",
                              style: themeState.themeData.textTheme.headlineSmall?.copyWith(
                                fontSize: 36, // set your desired font size
                                fontWeight: FontWeight.bold, // optional
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          TextField(
                            controller: emailController,
                            decoration: InputDecoration(
                              labelText: "Email",
                              prefixIcon: Icon(Icons.email),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                          SizedBox(height: 15),
                          TextField(
                            controller: passwordController,
                            obscureText: true,
                            decoration: InputDecoration(
                              labelText: "Password",
                              prefixIcon: Icon(Icons.lock),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                          SizedBox(height: 25),
                          state is AuthLoading
                              ? CircularProgressIndicator()
                              : SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                final email =
                                emailController.text.trim();
                                final password =
                                passwordController.text.trim();
                                context
                                    .read<AuthBloc>()
                                    .add(LoginEvent(email, password));
                              },
                              style: ElevatedButton.styleFrom(
                                padding:
                                EdgeInsets.symmetric(vertical: 14),
                                backgroundColor: themeState
                                    .themeData.colorScheme.primary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Text(
                                "Login",
                                style: TextStyle(
                                    fontSize: 18,
                                    color: themeState
                                        .themeData.colorScheme.onPrimary),
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          TextButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => SignupScreen()),
                              );
                            },
                            child: Text(
                              "Create an account",
                              style: TextStyle(
                                color: themeState.themeData.colorScheme.primary,
                                fontSize: 16,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  } }
