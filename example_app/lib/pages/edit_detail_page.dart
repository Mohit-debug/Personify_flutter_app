import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:image_picker/image_picker.dart';



class EditProfilePage extends StatefulWidget {
  final Map<String, dynamic> userProfileData;
  final Function(Map<String, dynamic>) onUpdate;

  EditProfilePage({required this.userProfileData, required this.onUpdate});

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  String _profileImageUrl = ''; // to Store the image URL

  @override
  void initState() {
    super.initState();
    _emailController.text = widget.userProfileData['email'];
    _usernameController.text = widget.userProfileData['username'];
    _phoneNumberController.text = widget.userProfileData['phonenumber'];
    _addressController.text = widget.userProfileData['address'];
    // _profileImageUrl = widget.userProfileData['profileImageUrl'];
    _profileImageUrl = widget.userProfileData['profileImageUrl'] ?? '';
    // alternate method 
    // if (widget.userProfileData['profileImageUrl'] != null) {
    // _profileImageUrl = widget.userProfileData['profileImageUrl'];
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // CircleAvatar(
              //   backgroundImage: NetworkImage(_profileImageUrl),
              //   radius: 40,
              // ),
              ElevatedButton(
                onPressed: () async {
                  // Implement image uploading logic here
                  // once image is uploaded, set _profileImageUrl with the image URL
                  // implement image uploading logic here
                  String uploadedImageUrl = await uploadImageAndGetUrl(_emailController.text);
                  setState(() {
                    _profileImageUrl = uploadedImageUrl;
                  });
                },
                child: Text('Upload Image'),
              ),
              const SizedBox(height: 12),

              TextField(
                controller: _emailController,
                enabled: false, // Disable editing email
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Username is required';
                  }
                  if (!_isValidUsername(value)) {
                    return 'Username should contain only alphabetic characters and spaces';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _phoneNumberController,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Phone number is required';
                  }
                  if (!isNumeric(value)) {
                    return 'Phone number must be numeric';
                  }
                  if (value.length != 10) {
                    return 'Phone number must be 10 digits long';
                  }
                  if (!_isValidPhoneNumber(value)) {
                    return 'Invalid phone number format';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _addressController,
                decoration: InputDecoration(
                  labelText: 'Address',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState != null &&
                      _formKey.currentState!.validate()) {
                    // Form is valid, proceed with saving changes
                    final updatedData = {
                      'email': _emailController.text,
                      'username': _usernameController.text,
                      'phonenumber': _phoneNumberController.text,
                      'address': _addressController.text,
                    };
                    widget.onUpdate(updatedData);
                    _saveChanges(updatedData);
                    Navigator.pop(context);
                  }
                },
                child: const Text('Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveChanges(Map<String, dynamic> updatedData) async {
    try {
      // Upload the image and obtain the image URL
      //  String uploadedImageUrl = await uploadImageAndGetUrl(_emailController.text); // Replace with your image upload logic

        // Update the 'profileImageUrl' field in the updatedData map
        // updatedData['profileImageUrl'] = uploadedImageUrl;

        final response = await http.put(
          Uri.parse('http://localhost:3000/api/user/profile/update'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(updatedData),
        );

      if (response.statusCode == 200) {
        // Success
        print('Profile updated successfully');
      } else {
        // Error
        print('Failed to update profile');
        print(response.body);
        // Show an error dialog
      }
    } catch (e) {
      print(e.toString());
      // Show an error dialog
    }
  }
}

Future<String> uploadImageAndGetUrl(String userEmail) async {
  print(userEmail);
  try {
    final url = Uri.parse('http://localhost:3000/api/user/profile/upload/${userEmail}');
    final request = http.MultipartRequest('PUT', url);//POST

    // request.headers['Content-Type'] = 'multipart/form-data';

    final imagePicker = ImagePicker();
    final pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedFile == null) {
      print('No image selected');
      return '';
    }

    final image = http.MultipartFile(
      'image', // This key should match the server's expectation
      http.ByteStream(Stream.castFrom(pickedFile.openRead())),
      await pickedFile.length(),
      filename: 'profile_image.jpg',
    );
    request.files.add(image);

    final response = await request.send();
    // final responseString = await response.stream.bytesToString();
    // print('Image upload response: $responseString');
    
    print('Image upload status: ${response.statusCode}');
    
    if (response.statusCode == 200) {
      final imageUrlStream = await response.stream.bytesToString();
      final imageUrl = await response.stream.bytesToString();
      print('Image URL: $imageUrl');
      return imageUrl;
    } else {
      print('Image upload failed');
      print(await response.stream.bytesToString());
      return '';
    }
  } catch (e) {
    print('Image upload error: $e');
    return '';
  }
}



bool isNumeric(String str) {
  if (str == null) {
    return false;
  }
  return double.tryParse(str) != null;
}

bool _isValidPhoneNumber(String phoneNumber) {
  final RegExp phoneNumberRegExp = RegExp(r'^[0-9]{10}$');
  return phoneNumberRegExp.hasMatch(phoneNumber);
}

bool _isValidUsername(String username) {
  final RegExp usernameRegExp = RegExp(r'^[a-zA-Z\s]+$');
  return usernameRegExp.hasMatch(username);
}

