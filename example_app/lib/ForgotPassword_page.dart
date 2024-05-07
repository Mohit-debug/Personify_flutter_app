import 'dart:convert';
import 'package:example_app/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ForgotPasswordPage extends StatefulWidget {
  final String email;

  ForgotPasswordPage({required this.email});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();

  void _updatePassword() async {
    final String email = _emailController.text.trim();
    final String newPassword = _newPasswordController.text.trim();

    if (email.isEmpty || newPassword.isEmpty) {
      _showErrorDialog("Please enter your email and a new password.");
      return;
    }

    try {
      final Map<String, dynamic> requestBody = {
        'email': email,
        'newPassword': newPassword,
      };

      final response = await http.put(
        Uri.parse('http://localhost:3000/api/user/forgotPassword'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        // Password update successful
        print('Password updated successfully');
        // _showSuccessDialog("Password Updated Successfully");
        // Navigate to UserProfilePage
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => UserProfilePage()), 
      );
      } else {
        // Error
        print('Password update failed');
        print(response.body);
        _showErrorDialog("Failed to update password. Please try again.");
      }
    } catch (e) {
      print(e.toString());
      _showErrorDialog("Something went wrong, please try again.");
    }
  }

  void _showSuccessDialog(String message) {
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

  bool _isNewPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Change Password')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Email TextField
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
                hintText: 'Enter your email',
              ),
            ),
            SizedBox(height: 16), // Add spacing between fields

            // New Password TextField
            TextField(
              controller: _newPasswordController,
              decoration: InputDecoration(
                labelText: 'New Password',
                border: OutlineInputBorder(),
                hintText: 'Enter your new password',
                suffixIcon: GestureDetector(
                  onTap: () {
                    setState(() {
                      _isNewPasswordVisible = !_isNewPasswordVisible;
                    });
                  },
                  child: Icon(
                    _isNewPasswordVisible ? Icons.visibility : Icons.visibility_off,
                    color: Colors.grey,
                  ),
                ),
              ),
              obscureText: !_isNewPasswordVisible,
            ),


            SizedBox(height: 20),

            // Update Password Button
            ElevatedButton(
              onPressed: _updatePassword,
              child: Text('Update Password'),
            ),
          ],
        ),
      ),
    );
  }
}
