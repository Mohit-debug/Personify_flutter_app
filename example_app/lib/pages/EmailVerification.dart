import 'package:example_app/ForgotPassword_page.dart';
import 'package:example_app/main.dart';
import 'package:flutter/material.dart';
import 'package:email_otp/email_otp.dart';

// import 'package:email_otp/email_otp.dart';
// import 'package:flutter_email_verification/details_of_person/details_person.dart';
// import 'package:flutter_email_verification/pages/login_pages.dart';


class EmailVerification extends StatefulWidget {
  const EmailVerification({Key? key}) : super(key: key);

  @override
  State<EmailVerification> createState() => _EmailVerificationState();
}

class _EmailVerificationState extends State<EmailVerification> {
  TextEditingController email = TextEditingController();
  TextEditingController otp = TextEditingController();
  EmailOTP myauth = EmailOTP();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Verificaltion of Email'),
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Card(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: email,
                        decoration: const InputDecoration(hintText: "User Email"),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Email is required';
                          }
                          if (!_isValidEmail(value)) {
                            return 'Enter a valid email address';
                          }

                          return null; 
                        },
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        myauth.setConfig(
                          appEmail: "7455867051mohit@gmail.com",
                          appName: "Email OTP",
                          userEmail: email.text,
                          otpLength: 6,
                          otpType: OTPType.digitsOnly,
                        );
                        if (await myauth.sendOTP() == true) {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            content: Text("OTP has been sent"),
                          ));
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            content: Text("Oops, OTP send failed"),
                          ));
                        }
                      },
                      child: const Text("Send OTP"),
                    ),
                  ],
                ),
              ),
              Card(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: otp,
                        decoration: const InputDecoration(hintText: "Enter OTP"),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        if (await myauth.verifyOTP(otp: otp.text) == true) {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            content: Text("OTP is verified"),
                          ));
                          // Navigate to ForgotPasswordPage
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ForgotPasswordPage(email: email.text)),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            content: Text("Invalid OTP"),
                          ));
                        }
                      },
                      child: const Text("Verify"),
                    ),
                  ],
                ),
              )
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

