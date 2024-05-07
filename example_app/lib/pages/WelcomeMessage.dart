//https://myaccount.google.com/lesssecureapps?pli=1&rapt=AEjHL4NEzrp-8vNmxhadIMLlr7T_WXfkRqntUshiL0hezD04PTUzWmKnKW4RMyyDNqNVPg1aRoBtI0UHRLMulNS1rEaFw086EA
//allow less secure app...
import 'package:flutter/material.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class WelcomeMessage {
  final String userEmail;
  final String username;

  WelcomeMessage({required this.userEmail, required this.username});

  Future<bool> sendWelcomeEmail() async {
    try {
      final smtpServer = gmail('email.com', 'password');

      final message = Message()
        ..from = Address('mohit@xorlabs.com', 'Example_app')
        ..recipients.add(userEmail)
        ..subject = 'Welcome to EXAMPLE APP'
        ..text = 'Welcome to EXAMPLE APP! We are excited to have you on board.';
      var nameFromSomeInput =
          username; // Use the provided username parameter see in argument
      var yourHtmlTemplate = ''' 
        <!DOCTYPE html>
        <html>
        <head>

          <meta charset="utf-8">
          <meta http-equiv="x-ua-compatible" content="ie=edge">
          <title>Welcome Email</title>
          <meta name="viewport" content="width=device-width, initial-scale=1">
          <style type="text/css">
        
          @media screen {
            @font-face {
              font-family: 'Source Sans Pro';
              font-style: normal;
              font-weight: 400;
              src: local('Source Sans Pro Regular'), local('SourceSansPro-Regular'), url(https://fonts.gstatic.com/s/sourcesanspro/v10/ODelI1aHBYDBqgeIAH2zlBM0YzuT7MdOe03otPbuUS0.woff) format('woff');
            }

            @font-face {
              font-family: 'Source Sans Pro';
              font-style: normal;
              font-weight: 700;
              src: local('Source Sans Pro Bold'), local('SourceSansPro-Bold'), url(https://fonts.gstatic.com/s/sourcesanspro/v10/toadOcfmlt9b38dHJxOBGFkQc6VGVFSmCnC_l7QZG60.woff) format('woff');
            }
          }

          
          body,
          table,
          td,
          a {
            -ms-text-size-adjust: 100%; /* 1 */
            -webkit-text-size-adjust: 100%; /* 2 */
          }

          
          table,
          td {
            mso-table-rspace: 0pt;
            mso-table-lspace: 0pt;
          }

          
          img {
            -ms-interpolation-mode: bicubic;
          }

          
          a[x-apple-data-detectors] {
            font-family: inherit !important;
            font-size: inherit !important;
            font-weight: inherit !important;
            line-height: inherit !important;
            color: inherit !important;
            text-decoration: none !important;
          }

          div[style*="margin: 16px 0;"] {
            margin: 0 !important;
          }

          body {
            width: 100% !important;
            height: 100% !important;
            padding: 0 !important;
            margin: 0 !important;
          }

          
          table {
            border-collapse: collapse !important;
          }

          a {
            color: black;
          }

          img {
            height: auto;
            line-height: 100%;
            text-decoration: none;
            border: 0;
            outline: none;
          }
          </style>

        </head>
        <body style="background-color: #e9ecef;">

          <!-- start preheader -->
          <div class="preheader" style="display: none; max-width: 0; max-height: 0; overflow: hidden; font-size: 1px; line-height: 1px; color: #fff; opacity: 0;">
            A preheader is the short summary text that follows the subject line when an email is viewed in the inbox.
          </div>
          <!-- end preheader -->

          <!-- start body -->
          <table border="0" cellpadding="0" cellspacing="0" width="100%">

            <!-- start logo -->
            <tr>
              <td align="center" bgcolor="#e9ecef">
                <!--[if (gte mso 9)|(IE)]>
                <table align="center" border="0" cellpadding="0" cellspacing="0" width="600">
                <tr>
                <td align="center" valign="top" width="600">
                <![endif]-->
                <table border="0" cellpadding="0" cellspacing="0" width="100%" style="max-width: 600px;">
                  <tr>
                    <td align="center" valign="top" style="padding: 36px 24px;">
                      <a href="https://sendgrid.com" target="_blank" rel="noopener noreferrer" style="display: inline-block;">
                        <img src="//www.html.am/images/html-codes/links/boracay-resort-1000x750.jpg" target="_blank"><img src="//www.html.am/images/html-codes/links/boracay-resort-200x150.jpg"  alt="Logo" border="0" width="48" style="display: block; width: 48px; max-width: 48px; min-width: 48px;">
                      </a>
                    </td>
                  </tr>
                </table>
                <!--[if (gte mso 9)|(IE)]>
                </td>
                </tr>
                </table>
                <![endif]-->
              </td>
            </tr>
            <!-- end logo -->

            <!-- start  -->
            <tr>
              <td align="center" bgcolor="#e9ecef">
                <!--[if (gte mso 9)|(IE)]>
                <table align="center" border="0" cellpadding="0" cellspacing="0" width="600">
                <tr>
                <td align="center" valign="top" width="600">
                <![endif]-->
                <table border="0" cellpadding="0" cellspacing="0" width="100%" style="max-width: 600px;">
                  <tr>
                    <td bgcolor="#ffffff" align="left">
                      <img src="//www.html.am/images/html-codes/links/boracay-resort-1000x750.jpg" target="_blank"><img src="//www.html.am/images/html-codes/links/boracay-resort-200x150.jpg"  alt="Welcome" width="600" style="display: block; width: 100%; max-width: 100%;">
                    </td>
                  </tr>
                </table>
                <!--[if (gte mso 9)|(IE)]>
                </td>
                </tr>
                </table>
                <![endif]-->
              </td>
            </tr>
            <!-- end  -->

            <!-- start copy block -->
            <tr>
              <td align="center" bgcolor="#e9ecef">
                <!--[if (gte mso 9)|(IE)]>
                <table align="center" border="0" cellpadding="0" cellspacing="0" width="600">
                <tr>
                <td align="center" valign="top" width="600">
                <![endif]-->
                <table border="0" cellpadding="0" cellspacing="0" width="100%" style="max-width: 600px;">

                  <!-- start copy -->
                  <tr>
                    <td bgcolor="#ffffff" align="left" style="padding: 24px; font-family: 'Source Sans Pro', Helvetica, Arial, sans-serif; font-size: 16px; line-height: 24px;">
                      <h1 style="margin: 0 0 12px; font-size: 32px; font-weight: 400; line-height: 48px;">Welcome, To Example App!</h1>
                      <p style="margin: 0;">Thank you for signing up with Example App. We strive to produce high quality email templates that you can use for your transactional or marketing needs.</p>
                    </td>
                  </tr>
                  <!-- end copy -->

                  <!-- start button -->
                  <tr>
                    <td align="left" bgcolor="#ffffff">
                      <table border="0" cellpadding="0" cellspacing="0" width="100%">
                        <tr>
                          <td align="center" bgcolor="#ffffff" style="padding: 12px;">
                            <table border="0" cellpadding="0" cellspacing="0">
                              <tr>
                                <td align="center" bgcolor="#1a82e2" style="border-radius: 6px;">
                                  <a href="https://sendgrid.com" target="_blank" rel="noopener noreferrer" style="display: inline-block; padding: 16px 36px; font-family: 'Source Sans Pro', Helvetica, Arial, sans-serif; font-size: 16px; color: #ffffff; text-decoration: none; border-radius: 6px;">EXAMPLE APP</a>
                                </td>
                              </tr>
                            </table>
                          </td>
                        </tr>
                      </table>
                    </td>
                  </tr>
                  <!-- end  -->

                  <!-- start  -->
                  <tr>
                    <td align="left" bgcolor="#ffffff" style="padding: 24px; font-family: 'Source Sans Pro', Helvetica, Arial, sans-serif; font-size: 16px; line-height: 24px; border-bottom: 3px solid #d4dadf">
                      <p style="margin: 0;">Warm Regards,<br> Example app</p>
                    </td>
                  </tr>
                  <!-- end  -->

                </table>
                <!--[if (gte mso 9)|(IE)]>
                </td>
                </tr>
                </table>
                <![endif]-->
              </td>
            </tr>
            <!-- end copy block -->

            <!-- start footer -->
            <tr>
              <td align="center" bgcolor="#e9ecef" style="padding: 24px;">
                <!--[if (gte mso 9)|(IE)]>
                <table align="center" border="0" cellpadding="0" cellspacing="0" width="600">
                <tr>
                <td align="center" valign="top" width="600">
                <![endif]-->
                <table border="0" cellpadding="0" cellspacing="0" width="100%" style="max-width: 600px;">

                  <!-- start permission -->
                  <tr>
                    <td align="center" bgcolor="#e9ecef" style="padding: 12px 24px; font-family: 'Source Sans Pro', Helvetica, Arial, sans-serif; font-size: 14px; line-height: 20px; color: #666;">
                      <p style="margin: 0;">You received this email because we received a request for your account. If you didn't request [type_of_action] you can safely delete this email.</p>
                    </td>
                  </tr>
                  <!-- end permission -->

                  <!-- start unsubscribe -->
                  <tr>
                    <td align="center" bgcolor="#e9ecef" style="padding: 12px 24px; font-family: 'Source Sans Pro', Helvetica, Arial, sans-serif; font-size: 14px; line-height: 20px; color: #666;">
                      <p style="margin: 0;">To stop receiving these emails, you can <a href="https://sendgrid.com" target="_blank" rel="noopener noreferrer">unsubscribe</a> at any time.</p>
                      <p style="margin: 0;">Example app</p>
                    </td>
                  </tr>
                  <!-- end unsubscribe -->

                </table>
                <!--[if (gte mso 9)|(IE)]>
                </td>
                </tr>
                </table>
                <![endif]-->
              </td>
            </tr>
            <!-- end footer -->

          </table>
          <!-- end body -->

        </body>
        </html>
      ''';

      message.html = yourHtmlTemplate.replaceAll('{{NAME}}', nameFromSomeInput);

      final sendResponse = await send(message, smtpServer);

      if (sendResponse.toString().startsWith('250')) {
        print('Welcome email sent to $userEmail');
        return true;
      } else {
        print('Failed to send welcome email');
        return false;
      }
    } catch (e) {
      print("Error sending welcome email: $e");
      return false;
    }
  }
}
