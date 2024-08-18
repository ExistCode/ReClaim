import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:email_validator/email_validator.dart";
import 'package:reclaim/core/models/app_user.dart';
import 'package:reclaim/core/navigation/navigation.dart';
import 'package:reclaim/core/providers/user_provider.dart';
import 'package:reclaim/features/authentication/presentation/screens/sign_up_screen.dart';
import 'package:reclaim/features/wallet/presentation/screens/wallet_auth_screen.dart';
import 'package:reclaim/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:reclaim/features/wallet/presentation/screens/wallet_regist_screen.dart';
import '../../../../core/theme/colors.dart' as custom_colors;
import '../widgets/custom_error_dialog.dart';
import 'dart:async';

class LogInScreen extends StatefulWidget {
  static const routeName = '/log-in-screen';
  const LogInScreen({super.key});

  @override
  _LogInScreenState createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  UserProvider _userProvider = UserProvider();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _auth = FirebaseAuth.instance;

  // Stream to listen for authentication state changes
  late StreamSubscription<User?> _authStateChangesSubscription;

  @override
  void initState() {
    super.initState();
    // Listen for authentication state changes
    _authStateChangesSubscription = _auth.authStateChanges().listen((user) {
      if (user != null) {
        // User is signed in
        AppUser appuser = AppUser(
          uid: user.uid,
          email: user.email,
          // Add other necessary properties
        );
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => WalletAuthScreen(user: appuser),
          ),
        );
      } else {
        // User is signed out
        // Do nothing, stay on the login screen
      }
    });
  }

  @override
  void dispose() {
    // Cancel the subscription when the widget is disposed
    _authStateChangesSubscription.cancel();
    super.dispose();
  }

  Future<UserCredential?> _signIn() async {
    try {

      if (!EmailValidator.validate(_emailController.text)) {
        showErrorDialog(context, 'Invalid email');
        return null;
      }

      final userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      ).timeout(const Duration(seconds: 6), onTimeout: () {
        throw TimeoutException('The request has timed out');
      });
      print('User signed in');

      User? firebaseUser = userCredential.user;
      if (firebaseUser != null) {
        AppUser user = await _userProvider.fetchUserById(firebaseUser.uid) as AppUser;
        _userProvider.setCurrentUser(user);
        // AppUser user = AppUser(
        //   uid: firebaseUser.uid,
        //   email: firebaseUser.email,
        //   name: firebaseUser.displayName,
        //   // Add other necessary properties
        // );
        // Navigate to DashboardScreen with the user object
        print("before navigate email: ${_userProvider.getCurrentUserEmail()}");
        print("before navigate address?: ${_userProvider.getCurrentUserWalletAddress()}");

        if (user.walletAddress != null) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => DashboardScreen(user: user),
            ),
          );
        } else {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => WalletAuthScreen(user: user),
            ),
          );
        }
      }
      return userCredential;

    } catch (e) {
      String errorMessage;
      if (e is TimeoutException) {
        errorMessage = 'The request has timed out';
      } else if (e is FirebaseAuthException) {
        errorMessage = 'Invalid email or password';
      } else {
        errorMessage = e.toString();
      }
      showErrorDialog(context, errorMessage);
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: custom_colors.primaryBackground,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Image.asset(
                'assets/images/app-logo.png',
                height: 50,
                width: 50,
              ),
              const SizedBox(height: 60),
              const Text(
                'Welcome to ReClaim',
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const Text(
                'Let\'s get started!',
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 80),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: custom_colors.darkGray,
                ),
                child: Column(
                  children: [
                    const Text(
                      'Log In',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: custom_colors.accentGreen),
                        ),
                      ),
                      style: const TextStyle(color: Colors.white),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _passwordController,
                      decoration: const InputDecoration(
                        labelText: 'Password',
                        border: OutlineInputBorder(),
                      ),
                      style: const TextStyle(color: Colors.white),
                      obscureText: true,
                    ),
                    const SizedBox(height: 40),
                    ElevatedButton(
                      onPressed: () async {
                        final userCredential = await _signIn();
                        if (userCredential != null) {
                          // Handle successful login
                        }
                      },
                      child: const Text('Log In'),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Don\'t have an account?', style: TextStyle(color: Colors.white)),
                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => SignUpScreen())
                            );   
                          },
                          child: const Text('Sign Up'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
