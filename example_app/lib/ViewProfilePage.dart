import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class ViewProfilePage extends StatefulWidget {
  final Map<String, dynamic> profileData;

  ViewProfilePage({required this.profileData});

  @override
  _ViewProfilePageState createState() => _ViewProfilePageState();
}

class _ViewProfilePageState extends State<ViewProfilePage> {
  late Future<Uint8List> imageUrlFuture;

  @override
  void initState() {
    super.initState();
    imageUrlFuture = fetchImage(widget.profileData['email']); // Set imageUrlFuture here
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
      
      final imageUrl = await response.stream.bytesToString();
    setState(() {
        imageUrlFuture = fetchImage(userEmail);
      });
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



  Future<Uint8List> fetchImage(String email) async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost:3000/api/user/profile/image/$email'),
      );

      if (response.statusCode == 200) {
        return Uint8List.fromList(response.bodyBytes); // Convert response body to Uint8List
      } else {
        print('Failed to fetch image');
        return Uint8List(0); // Return an empty Uint8List in case of failure
      }
    } catch (e) {
      print('Error fetching image: $e');
      return Uint8List(0); // Return an empty Uint8List in case of error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('View Profile'),
      ),
      body: 
      Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FutureBuilder<Uint8List>(
              future: imageUrlFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error fetching image');
                } else if (snapshot.data != null && snapshot.data!.isNotEmpty) {
                  return Column(
                    children: [
                      //////
                      Padding(
                        padding: const EdgeInsets.only(bottom: 40),
                        child: Text(
                          '${widget.profileData['username']}`s Profile',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      ////
                       SizedBox(height: 40),
                      Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        CircleAvatar(
                          radius: 120,
                          backgroundImage: MemoryImage(snapshot.data!),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton.icon(
                            onPressed: () {
                              // Call a function to handle image update
                              uploadImageAndGetUrl(widget.profileData['email']);
                            },
                            icon: Icon(Icons.edit),
                            label: Text(''), // Empty label to make it smaller
                            style: ElevatedButton.styleFrom(
                              primary: Colors.transparent, // Set background color to transparent
                              padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0), // Adjust padding
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              } else {
                return Text('No image available.');
              }
            },
          ),
            SizedBox(height: 40),
            Text(
              'Email: ${widget.profileData['email']}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18, 
              ),
            ),
            Text(
              'Username: ${widget.profileData['username']}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18, 
              ),
            ),
            Text(
              'Phone Number: ${widget.profileData['phonenumber']}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18, 
              ),
            ),
            Text(
              'Address: ${widget.profileData['address']}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }

}
