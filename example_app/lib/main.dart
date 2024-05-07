import 'package:example_app/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import './pages/details_page.dart';
import 'ForgotPassword_page.dart';
import 'pages/EmailVerification.dart';
import 'pages/register_page.dart';
import 'pages/admin_panel_page.dart';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform,);
  // await Firebase.initializeApp();
  
  final fcmToken = await FirebaseMessaging.instance.getToken();
  print(fcmToken);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'User Profile App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: UserProfilePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class UserProfilePage extends StatefulWidget {
  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  static const String baseURL = 'http://localhost:3000/api';

  void _fetchUserProfileData() async {
    final String email = _emailController.text.trim();
    final String password = _passwordController.text.trim();

    try {
      final response = await http.get(
        Uri.parse('$baseURL/user/login?email=$email&password=$password'),
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final userProfileData = [data];

        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return Center(child: CircularProgressIndicator());
          },
        );
        
        await Future.delayed(Duration(seconds: 2));
        
        Navigator.of(context).pop(); 
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => ProfileDetailsPage(
            userProfileData: userProfileData,
            signedInUserEmail: email, 
            admin: data['admin'] == true, 
          ),
        ));
      } else if (response.statusCode == 404) {
        // User not found
        print('User not found');
        _showErrorDialog("User not found.");
      }  else {
        // Login Error
        print('Login failed');
        print(response.body);
        _showErrorDialog(
            "Login failed. Please check your credentials and try again.");
      }
    } catch (e) {
      print(e.toString());
      _showErrorDialog("Something went wrong, please try again.");
    }
  }

  void _showSuccessDialog(String message, VoidCallback onClose) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Success'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                onClose(); // Call the provided callback function
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }


  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  // void _navigateToForgotPasswordPage(BuildContext context) async {
  //   final result = await Navigator.of(context).push(
  //     MaterialPageRoute(
  //       builder: (context) => ForgotPasswordPage(email: _emailController.text.trim()),
  //     ),
  //   );

  //   // Handle the result returned from ForgotPasswordPage, if needed.
  //   if (result != null) {
  //     // Process the result here, if any.
  //   }
  // }

  void _navigateToForgotPasswordPage(BuildContext context) async {
  final result = await Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) => const EmailVerification(),
    ),
  );

  // handle the result returned from EmailVerificationPage
  if (result != null) {
    // process the result here
  }

  // after successful verification navigate to the ForgotPasswordPage
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) => ForgotPasswordPage(email: _emailController.text.trim()),
    ),
  );
}
bool _isPasswordVisible = false; 

@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login & Fetch User Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Image.asset("assets/images/Login.png"),
            ),
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.only(top: 160),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _passwordController,
                            obscureText: !_isPasswordVisible,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              border: OutlineInputBorder(),
                              suffixIcon: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _isPasswordVisible = !_isPasswordVisible;
                                  });
                                },
                                child: Icon(
                                  _isPasswordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(
                                builder: (context) =>
                                    ForgotPasswordPage(email: _emailController.text),
                              ));
                            },
                            child: Text(
                              'Forgot Password',
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                                color: Colors.blue,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Center(
                      child: ElevatedButton(
                        onPressed: _fetchUserProfileData,
                        child: Center(child: const Text('Login!')),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 10),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => RegisterPage(),
                          ));
                        },
                        child: Center(child: const Text('Register as User')),
                      ),
                    ),
                    ElevatedButton(
                  onPressed: () {
                    // Navigate to the admin panel page
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => adminRegistration()),
                    );
                  },
                  child: const Text('Register as Admin'),
                ),

                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}


