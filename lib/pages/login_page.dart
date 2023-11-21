import 'dart:ui';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_secure_storage/get_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_case/services/apis/auth_apis.dart';
import 'package:smart_case/theme/color.dart';
import 'package:smart_case/widgets/auth_text_field.dart';
import 'package:smart_case/widgets/custom_images/custom_image.dart';
import 'package:smart_case/widgets/wide_button.dart';
import 'package:url_launcher/url_launcher.dart';

import '../util/smart_case_init.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final globalKey = GlobalKey();

  bool isAuthingUser = false;
  bool isSendingResetRequest = false;
  bool hasFocus1 = false;
  bool hasFocus2 = false;
  bool shownChangeUser = true;
  var _height = 40.0;

  String? email;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: _buildBody(),
    );
  }

  Widget _buildTextWithLink(String data, String link) {
    return Column(
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: data,
                style: GoogleFonts.lato(
                    textStyle: Theme.of(context).textTheme.displayLarge,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    fontStyle: FontStyle.italic,
                    color: AppColors.white),
              ),
              TextSpan(
                text: link,
                style: GoogleFonts.lato(
                    textStyle: Theme.of(context).textTheme.displayLarge,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    fontStyle: FontStyle.italic,
                    decoration: TextDecoration.underline,
                    decorationColor: AppColors.white,
                    color: AppColors.white),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    launchUrl(Uri(
                      scheme: "mailto",
                      path: "info@infosectechno.com",
                      query: encodeQueryParameters(<String, String>{
                        'subject': 'Infosec Technologies Info mail',
                      }),
                    ));
                  },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTextWithAction(String data) {
    return Column(
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: data,
                style: GoogleFonts.lato(
                    textStyle: Theme.of(context).textTheme.displayLarge,
                    fontSize: 15,
                    fontStyle: FontStyle.italic,
                    decoration: TextDecoration.underline,
                    decorationColor: AppColors.white,
                    color: AppColors.white),
                recognizer: TapGestureRecognizer()
                  ..onTap = () async {
                    await FlutterPhoneDirectCaller.callNumber('+256770456789');
                  },
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  String? encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map((MapEntry<String, String> e) =>
            '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
  }

  _onPressed() {
    if (emailController.text.isNotEmpty) {
      if (EmailValidator.validate(emailController.text.trim())) {
        if (passwordController.text.isNotEmpty) {
          setState(() {
            isAuthingUser = true;
            shownChangeUser = false;
          });

          AuthApis.checkIfUserExists(
            emailController.text.trim(),
            onError: _handleError,
            onNoUser: _handleWrongEmail,
          ).then(
            (url) => AuthApis.signInUser(
              url!,
              emailController.text.trim(),
              passwordController.text.trim(),
              onSuccess: _signUserIn,
              onWrongPassword: _handleWrongPass,
              onError: _handleError,
            ).then(
              (user) => AuthApis.uploadFCMToken(emailController.text.trim()),
            ),
          );
        } else {
          Fluttertoast.showToast(
              msg: "No Password provided",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: AppColors.red,
              textColor: AppColors.white,
              fontSize: 16.0);
        }
      } else {
        Fluttertoast.showToast(
            msg: "Email not valid",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: AppColors.red,
            textColor: AppColors.white,
            fontSize: 16.0);
      }
    } else {
      Fluttertoast.showToast(
          msg: "No email provided",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: AppColors.red,
          textColor: AppColors.white,
          fontSize: 16.0);
    }
  }

  _signUserIn() async {
    final box = GetSecureStorage(
        password: 'infosec_technologies_ug_smart_case_law_manager');

    FocusManager.instance.primaryFocus?.unfocus();
    Navigator.popUntil(context, (route) => false);
    Navigator.pushNamed(context, '/root');

    box.write('email', emailController.text.trim());
    box.write('name', currentUser.firstName);
    box.write('image', currentUser.avatar);
  }

  _handleWrongEmail() {
    Fluttertoast.showToast(
        msg: "User not found",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: AppColors.red,
        textColor: AppColors.white,
        fontSize: 16.0);
    setState(() {
      isAuthingUser = false;
    });
  }

  _handleWrongPass() {
    Fluttertoast.showToast(
        msg: "Incorrect password",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: AppColors.red,
        textColor: AppColors.white,
        fontSize: 16.0);
    setState(() {
      isAuthingUser = false;
    });
  }

  _handleError() {
    Fluttertoast.showToast(
        msg: "An error occurred",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: AppColors.red,
        textColor: AppColors.white,
        fontSize: 16.0);
    setState(() {
      isAuthingUser = false;
    });
  }

  Widget _buildLoginBody() {
    return Column(
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'Hello, We are happy to see you here.',
              style: TextStyle(
                  color: AppColors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w300),
            ),
          ],
        ),
        const SizedBox(
          height: 30,
        ),
        Focus(
          child: AuthTextField(
            hintText: 'email',
            enabled: !isAuthingUser,
            controller: emailController,
            obscureText: false,
            isEmail: true,
            style: const TextStyle(color: AppColors.gray45),
            borderSide: const BorderSide(color: AppColors.gray45),
            fillColor: Colors.transparent,
          ),
          onFocusChange: (hasFocus) {
            if (hasFocus2) {
              hasFocus2 = false;
            }
            hasFocus1 = true;
            (hasFocus1) ? _height = 0 : _height = 40;
            setState(() {});
          },
        ),
        const SizedBox(height: 10),
        Focus(
          child: AuthPasswordTextField(
            controller: passwordController,
            hintText: 'password',
            enabled: !isAuthingUser,
            borderSide: const BorderSide(color: AppColors.gray45),
            style: const TextStyle(color: AppColors.gray45),
            fillColor: Colors.transparent,
            iconColor: AppColors.gray45,
          ),
          onFocusChange: (hasFocus) {
            if (hasFocus1) {
              hasFocus1 = false;
            }
            hasFocus2 = true;
            (hasFocus2) ? _height = 0 : _height = 40;
            setState(() {});
          },
        ),
        const SizedBox(
          height: 10,
        ),
        (isAuthingUser)
            ? const CupertinoActivityIndicator(
                color: AppColors.gray45,
                radius: 20,
              )
            : WideButton(
                name: 'Login',
                onPressed: _onPressed,
                bgColor: AppColors.gray45,
                textStyle: const TextStyle(color: Colors.black54, fontSize: 20),
              ),
        const SizedBox(
          height: 10,
        ),
        if (email != null && email!.isNotEmpty && shownChangeUser)
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppColors.gray45),
            ),
            onPressed: () {
              // locator<NavigationService>().navigateToSignIn("/login");
              Navigator.pushNamed(context, '/sign_in');
            },
            child: Text(
              'Back to ${currentUsername ?? "user"}',
              style: const TextStyle(color: AppColors.gray45, fontSize: 20),
            ),
          ),
        const SizedBox(
          height: 10,
        ),
        TextButton(
          onPressed: () {
            setState(() {});
          },
          child: const Text(
            'Forgot password?',
            style: TextStyle(
              color: AppColors.white,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFooter() {
    return Column(
      children: [
        _buildTextWithLink('contact us: ', 'info@infosectechno.com'),
        const SizedBox(height: 8),
        _buildTextWithAction('+256 (0)770456789'),
        const SizedBox(height: 8),
        Text(
          'copyright @ ${DateTime.now().year} SmartCase Manager',
          style: const TextStyle(
            color: AppColors.inActiveColor,
            fontWeight: FontWeight.w300,
          ),
        ),
      ],
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                        decoration: BoxDecoration(
                            color: const Color.fromRGBO(0, 0, 0, 1)
                                .withOpacity(0.2),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(30))),
                        width: MediaQuery.of(context).size.width * 0.9,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CustomImage(
                                "assets/images/splash.png",
                                trBackground: true,
                                isNetwork: false,
                                width: MediaQuery.of(context).size.width * .6,
                                imageFit: BoxFit.contain,
                                radius: 0,
                              ),
                              _buildLoginBody(),
                              const SizedBox(height: 10),
                              _buildFooter(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  _getCurrentUserData() async {
    final box = GetSecureStorage(
        password: 'infosec_technologies_ug_smart_case_law_manager');

    email = box.read('email');

    setState(() {});
  }

  @override
  void initState() {
    _getCurrentUserData();
    super.initState();
  }
}
