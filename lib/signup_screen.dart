import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';
import '../utils/app_colors.dart';
import '../utils/app_paddings.dart';
import 'login_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  String phoneNumberWithCountryCode = '';
  bool _isLoading = false;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> saveUserToDatabase(String uid, String name, String email, String phone) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'profileImageUrl': "",
        'club_id': "",
        'club_name': "",
        'role': "admin",
        'name': name,
        'email': email,
        'phone': phone,
        'createdAt': DateTime.now().toString(),
      });
      print('User data saved successfully');
    } catch (e) {
      print('Error saving user data: $e');
    }
  }

  Future<void> _registerUser() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    setState(() {
      _isLoading = true;
    });

    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      User? user = userCredential.user;
      if (user != null) {
        await saveUserToDatabase(
          user.uid,
          nameController.text.trim(),
          emailController.text.trim(),
          phoneNumberWithCountryCode,
        );

        await user.sendEmailVerification();

        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Registration Successful'),
            content: const Text('Please verify your email. A verification link has been sent.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                  );
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'email-already-in-use':
          errorMessage = 'This email is already registered.';
          break;
        case 'invalid-email':
          errorMessage = 'Invalid email format.';
          break;
        case 'weak-password':
          errorMessage = 'Password should be at least 6 characters.';
          break;
        case 'operation-not-allowed':
          errorMessage = 'Email/Password sign-up is not enabled.';
          break;
        case 'network-request-failed':
          errorMessage = 'Network error. Please check your connection.';
          break;
        default:
          errorMessage = 'Registration failed: ${e.message}';
      }

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Registration Failed'),
          content: Text(errorMessage),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: AppPaddings.all24,
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.blue, size: 28),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Create New\nAccount',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.blue),
                  ),
                  const SizedBox(height: 30),


                  TextFormField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'EMAIL',
                      hintText: 'example@sabanciuniv.edu',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email address';
                      } else if (!value.endsWith('@sabanciuniv.edu')) {
                        return 'Email must be a @sabanciuniv.edu address';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),


                  TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: 'NAME',
                      hintText: 'example',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),


                  IntlPhoneField(
                    decoration: InputDecoration(
                      labelText: 'PHONE',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    initialCountryCode: 'TR',
                    keyboardType: TextInputType.number,
                    disableLengthCheck: false,
                    onChanged: (PhoneNumber phone) {
                      final digitsOnly = phone.number.replaceAll(RegExp(r'[^0-9]'), '');
                      if (RegExp(r'^[0-9]{10}\$').hasMatch(digitsOnly)) {
                        phoneNumberWithCountryCode = phone.countryCode + digitsOnly;
                      }
                    },
                    validator: (value) {
                      if (value == null || value.number.isEmpty) {
                        return 'Please enter your phone number';
                      } else if (!RegExp(r'^[0-9]{10}\$').hasMatch(value.number)) {
                        return 'Phone number must be 10 digits';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 16),


                  TextFormField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'PASSWORD',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    validator: (value) {
                      if (value == null || value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 30),

                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: _isLoading
                        ? const CircularProgressIndicator()
                        : ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: _registerUser,
                      child: const Text('SIGN UP', style: TextStyle(fontSize: 16, color: Colors.white)),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}