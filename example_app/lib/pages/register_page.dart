import 'dart:convert';
import 'package:example_app/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'WelcomeMessage.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);
  
  

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>(); 
  File? _pickedImage;


  void _register() async {
    

  final String email = _emailController.text.trim();
  final String username = _usernameController.text.trim();
  final String password = _passwordController.text;
  final String phone = _phoneController.text.trim();
  final String address = _addressController.text.trim();

  if (email.isEmpty || username.isEmpty || password.isEmpty || phone.isEmpty || address.isEmpty) {
    _showErrorDialog("All fields are required to be filled");
    return;
  }

  if (!_formKey.currentState!.validate()) { // Validate the form
      return;
  }

    
    try {
      final Map<String, dynamic> body = {
        'email': _emailController.text,
        'username': _usernameController.text,
        'password': _passwordController.text,
        'phonenumber': int.parse(_phoneController.text),
        'address': _addressController.text,
      };
  final request = http.MultipartRequest(
      'POST', 
      Uri.parse('http://localhost:3000/api/user/login'),
    );

    // image file to req
    if (_pickedImage != null) {
      request.files.add(
        await http.MultipartFile.fromPath('image', _pickedImage!.path),
      );
    }

    // other fields to req
   for (var entry in body.entries) {
  request.fields[entry.key] = entry.value.toString();
}

    final response = await request.send();

      if (response.statusCode == 200) {
          // Success
          print('Registration successful');
          
          // Send welcome email
          WelcomeMessage welcomeMessage = WelcomeMessage(userEmail: _emailController.text, username: _usernameController.text);
          bool emailSent = await welcomeMessage.sendWelcomeEmail();

          if (emailSent) {
            print('Welcome email sent');
          } else {
            // print('Failed to send welcome email');
          }

          showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return Center(child: CircularProgressIndicator());
          },
        );
        
        await Future.delayed(Duration(seconds: 2));

          // Show success dialog then navigation
          _showSuccessDialog("Account Created Successfully", () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => UserProfilePage(),
              ),
            );
          });
        }

      else {
        // Error
        print('Registration failed');
       
      }
    } catch (e) {
      print(e.toString());
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
                onClose(); //  callback function
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
   void _pickImage() async {
    final pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _pickedImage = File(pickedImage.path);
      });
    }
  }

  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Registration Page')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form( 
          key: _formKey, 
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Email TextField
              TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                    hintText: 'Enter your email',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Email is required';
                    }

                    // Validate email format using regular expression
                    if (!_isValidEmail(value)) {
                      return 'Enter a valid email address';
                    }
                    return null; // No validation error
                  },
                ),

              SizedBox(height: 16),

              // Username TextField
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(),
                  hintText: 'Enter your username',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Username is required';
                  }
                  if (!_isAlpha(value)) {
                    return 'Username must contain only letters and spaces';
                  }
                  return null;
                },
              ),
              
              SizedBox(height: 16),

              // Password TextField
              TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                    hintText: 'Enter your password',
                    suffixIcon: GestureDetector(
                      onTap: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                      child: Icon(
                        _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  obscureText: !_isPasswordVisible,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Password is required';
                    }
                    if (value.length < 8) {
                      return 'Password must be at least 8 characters long';
                    }
                    // Add additional password validation if needed
                    return null;
                  },
                ),



              SizedBox(height: 16),

              // Phone Number TextField
              TextFormField(
                  controller: _phoneController,
                  decoration: InputDecoration(
                    labelText: 'Phone Number',
                    border: OutlineInputBorder(),
                    hintText: 'Enter your phone number',
                  ),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Phone number is required';
                    }

                    // Validate if the phone number is numeric
                    if (!isNumeric(value)) {
                      return 'Phone number must be numeric';
                    }

                    // Validate if the phone number has a length of 10
                    if (value.length != 10) {
                      return 'Phone number must be 10 digits long';
                    }

                    return null; // No validation error
                  },
                ),

              SizedBox(height: 16),

              // Address TextField
              TextFormField(
                controller: _addressController,
                decoration: InputDecoration(
                  labelText: 'Address',
                  border: OutlineInputBorder(),
                  hintText: 'Enter your address',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Address is required';
                  }
                  // Add additional address validation if needed
                  return null;
                },
              ),
              SizedBox(height: 20),
              
              ElevatedButton(
                onPressed: _pickImage, // Call the function to pick an image
                child: Text('Upload Image'),
              ),

              Padding(
                padding: const EdgeInsets.only(top: 10,bottom: 10),
                child: ElevatedButton(
                  onPressed: _register,
                  child: Text('Create an Account'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Sign in'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

bool _isValidEmail(String email) {
  if (email == null) {
    return false;
  }
  final pattern = r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$';
  return RegExp(pattern).hasMatch(email);
}


bool _isAlpha(String text) {
  final RegExp alphaRegExp = RegExp(r'^[a-zA-Z\s]+$');
  return alphaRegExp.hasMatch(text);
}



bool isNumeric(String str) {
  if (str == null) {
    return false;
  }
  return double.tryParse(str) != null;
}