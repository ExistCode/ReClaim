import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:email_validator/email_validator.dart';
import 'package:reclaim/core/models/app_user.dart';
import 'package:reclaim/core/navigation/navigation.dart';
import 'package:reclaim/core/providers/user_provider.dart';
import 'package:reclaim/features/authentication/presentation/screens/log_in_screen.dart';
import 'package:reclaim/features/wallet/presentation/screens/wallet_auth_screen.dart';
import 'package:reclaim/features/dashboard/presentation/screens/dashboard_screen.dart';
import '../../../../core/theme/colors.dart' as custom_colors;
import '../widgets/custom_error_dialog.dart';
import 'dart:async';

class SignUpScreen extends StatefulWidget {
  static const routeName = '/sign[up-screen';
  const SignUpScreen({super.key});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  UserProvider _userProvider = UserProvider();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _auth = FirebaseAuth.instance;

  Future<UserCredential?> _signUp() async {
    try {
      if (_passwordController.text != _confirmPasswordController.text) {
        _showAlertDialog('Passwords do not match');
        return null;
      }

      if (!EmailValidator.validate(_emailController.text)) {
        _showAlertDialog('Invalid email');
        return null;
      }

      final userCredential = await _auth
          .createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      ).timeout(const Duration(seconds: 6), onTimeout: () {
        throw TimeoutException('The request has timed out');
      });

      User? firebaseUser = userCredential.user;
      if (firebaseUser != null) {
        AppUser user = AppUser(
          uid: firebaseUser.uid,
          email: firebaseUser.email,
          name: _nameController.text,
          // Add other necessary properties
        );
        await _userProvider.createNewUser(
            user.uid, // Generate or retrieve a unique ID
            user.email ?? '', // Provide a default value if user.email is null
            _nameController.text,'','','',''
        );
        // Navigate to DashboardScreen with the user object
        print("before navigate: ${firebaseUser.email}");
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => WalletAuthScreen(user: user),
          ),
        );
      }
      return userCredential;
    } catch (e) {
      String errorMessage;
      if (e is TimeoutException) {
        errorMessage = 'The request has timed out';
      } else if (e is FirebaseAuthException) {
        errorMessage = 'Invalid email or password';
      } else {
        errorMessage = 'Failed to sign up: ${e.toString()}';
      }
      showErrorDialog(context, errorMessage);
      return null;
    }
  }

  void _showAlertDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
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
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: custom_colors.darkGray,
                ),
                child: Column(
                  children: [
                    const Text(
                      'Join us!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Name',
                        border: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: custom_colors.accentGreen),
                        ),
                      ),
                      style: const TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                          labelStyle: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.w400),
                          labelText: 'Email',
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: custom_colors.accentGreen),
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: custom_colors.accentGreen))),
                      style: const TextStyle(color: Colors.white),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _passwordController,
                      decoration: const InputDecoration(
                          labelStyle: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.w400),
                          labelText: 'Password',
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: custom_colors.accentGreen),
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: custom_colors.accentGreen))),
                      style: const TextStyle(color: Colors.white),
                      obscureText: true,
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _confirmPasswordController,
                      decoration: const InputDecoration(
                          labelStyle: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.w400),
                          labelText: 'Confirm Password',
                          enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: custom_colors.accentGreen)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: custom_colors.accentGreen))),
                      style: const TextStyle(color: Colors.white),
                      obscureText: true,
                    ),
                    const SizedBox(height: 40),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: custom_colors
                            .accentGreen, // Change this to your desired color
                        foregroundColor: Colors
                            .white, // This sets the color of the text and icon
                        padding: EdgeInsets.symmetric(
                            horizontal: 40,
                            vertical: 15), // Optional: for sizing
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              15), // Optional: for rounded corners
                        ),
                      ),
                      onPressed: () async {
                        final userCredential = await _signUp();
                        if (userCredential != null) {
                          // Handle successful sign up
                        }
                      },
                      child: const Text(
                        'Sign Up',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Already have an account?',
                            style: TextStyle(color: Colors.white)),
                        TextButton(
                          onPressed: () async {
                            await FirebaseAuth.instance.signOut();
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LogInScreen()));
                          },
                          child: const Text(
                            'Log In',
                            style: TextStyle(color: custom_colors.accentGreen),
                          ),
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
