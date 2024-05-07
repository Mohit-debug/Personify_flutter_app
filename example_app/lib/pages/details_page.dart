import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../ViewProfilePage.dart';
import '../main.dart';
import './edit_detail_page.dart';

class ProfileDetailsPage extends StatefulWidget {
  final List<Map<String, dynamic>> userProfileData;
  final bool admin;
  final String signedInUserEmail;

  const ProfileDetailsPage({
    required this.userProfileData,
    required this.signedInUserEmail,
    required this.admin,
  });

  @override
  _ProfileDetailsPageState createState() => _ProfileDetailsPageState();
}

class _ProfileDetailsPageState extends State<ProfileDetailsPage> {
  bool _isLoading = false;
  String _error = '';

  void initState() {
    super.initState();
    _fetchAllUserProfiles(); // Fetch all user profiles
  }

  Future<void> _fetchAllUserProfiles() async {
    setState(() {
      _isLoading = true;
      _error = '';
    });

    try {
      final response = await http.get(
        Uri.parse('http://localhost:3000/api/user/login/all'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List<dynamic>;
        final List<Map<String, dynamic>> userProfileData = [];
        

        for (final profile in data) {
          final email = profile['email'];
          print(profile);
    
         final imageResponse = await http.get(
        Uri.parse('http://localhost:3000/api/user/profile/image/$email'),
      );

         if (imageResponse.statusCode == 200) {
        print('Image fetched successfully for $email');
        profile['image'] = imageResponse.bodyBytes;
      } else {
        print('Failed to fetch image for $email');
      }
          userProfileData.add(Map<String, dynamic>.from(profile));
        }

        setState(() {
          widget.userProfileData.clear();
          widget.userProfileData.addAll(userProfileData);
          _isLoading = false;
        });
      } else {
        print('Failed to fetch all profiles');
        setState(() {
          _error = "Failed to fetch all profiles. Please try again.";
          _isLoading = false;
        });
      }
    } catch (e) {
      print(e.toString());
      setState(() {
        _error = "Something went wrong, please try again.";
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All User Profiles'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  // Navigate to the UserProfilePage
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => UserProfilePage()),
                  );
                },
                child: Text('Logout'),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: _isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : _error.isNotEmpty
                    ? Center()
                    : Center(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            columns: [
                               DataColumn(label: Text('Avatar', style: TextStyle(fontWeight: FontWeight.bold))),
                              DataColumn(label: Text('Email', style: TextStyle(fontWeight: FontWeight.bold))),
                              DataColumn(label: Text('Username', style: TextStyle(fontWeight: FontWeight.bold))),
                              DataColumn(label: Text('Phone Number', style: TextStyle(fontWeight: FontWeight.bold))),
                              DataColumn(label: Text('Address', style: TextStyle(fontWeight: FontWeight.bold))),
                              DataColumn(label: Text('Action', style: TextStyle(fontWeight: FontWeight.bold))),
                            ],
                            rows: widget.userProfileData.map((profile) {
                              final email = profile['email'];
                              final bool isCurrentUser = email == widget.signedInUserEmail;

                              return DataRow(cells: [
                              DataCell(
                                CircleAvatar(
                                  backgroundImage: profile['image'] != null
                                      ? MemoryImage(profile['image']) as ImageProvider
                                      : AssetImage('assets/images/Login.png'), // Provide a default image
                                  radius: 20,
                                ),
                              ),
                              DataCell(Text(email)),
                              DataCell(Text(profile['username'])),
                              DataCell(Text(profile['phonenumber'])),
                              DataCell(Text(profile['address'])),
                              DataCell(
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    ElevatedButton.icon(
                                      onPressed: () => _navigateToEditProfilePage(context, profile),
                                      icon: Icon(Icons.edit),
                                      label: Text(''),
                                    ),
                                    if (showDeleteButton(profile)) // Check if delete button should be shown
                                      Padding(
                                        padding: const EdgeInsets.only(left: 10),
                                        child: ElevatedButton.icon(
                                          onPressed: () => _deleteUserProfile(profile['email']),
                                          icon: Icon(Icons.delete),
                                          label: Text(''),
                                        ),
                                      ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: ElevatedButton.icon(
                                        onPressed: () {
                                          _navigateToViewProfilePage(context, profile);
                                        },
                                        icon: Icon(Icons.view_list),
                                        label: Text(''),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ]);
                            }).toList(),
                          ),
                        ),
                      ),
                ),
              ],
            ),
          );
        }

  void _navigateToViewProfilePage(BuildContext context, Map<String, dynamic> profile) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ViewProfilePage(profileData: profile),
      ),
    );
  }

  void _deleteUserProfile(String email) async {
    try {
      final response = await http.delete(
        Uri.parse('http://localhost:3000/api/user/profile/delete?email=$email'),
      );

      if (response.statusCode == 200) {
        // Success
        print('Profile deleted successfully');
        // Navigate back to the UserProfilePage
        Navigator.pop(context);
      } else {
        // Error
        print('Failed to delete profile');
        print(response.body);
        setState(() {
          _error = "Failed to delete profile. Please try again.";
          _isLoading = false;
        });
      }
    } catch (e) {
      print(e.toString());
      setState(() {
        _error = "Something went wrong, please try again.";
        _isLoading = false;
      });
    }
  }

  void _navigateToEditProfilePage(BuildContext context, Map<String, dynamic> profile) async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EditProfilePage(
          userProfileData: profile,
          onUpdate: _handleProfileUpdate,
        ),
      ),
    );


    if (result != null) {
      _handleProfileUpdate(result);
    }
  }

  void _handleProfileUpdate(Map<String, dynamic> updatedData) {
    setState(() {
      final String email = updatedData['email'];
      final int index = widget.userProfileData.indexWhere((profile) => profile['email'] == email);
      if (index != -1) {
        widget.userProfileData[index]['username'] = updatedData['username'];
        widget.userProfileData[index]['phonenumber'] = updatedData['phonenumber'].toString();
        widget.userProfileData[index]['address'] = updatedData['address'];
      }
    });
  }

  bool showEditButtons(Map<String, dynamic> profile) {
  final bool isCurrentUser = profile['email'] == widget.signedInUserEmail;
  final bool isAdmin = profile['admin'] ?? false; 
  return true; 
}

bool showDeleteButton(Map<String, dynamic> profile) {
  final bool isCurrentUser = profile['email'] == widget.signedInUserEmail;
  final bool isAdmin = profile['admin'] ?? false; 

  return (isCurrentUser && isAdmin) || (!isAdmin && (widget.admin || isCurrentUser));
}
}
