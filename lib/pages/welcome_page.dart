import 'package:email_validator/email_validator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_case/services/apis/auth_apis.dart';
import 'package:smart_case/theme/color.dart';
import 'package:smart_case/widgets/auth_text_field.dart';
import 'package:smart_case/widgets/custom_icon_holder.dart';
import 'package:smart_case/widgets/custom_images/custom_image.dart';
import 'package:smart_case/widgets/wide_button.dart';
import 'package:toast/toast.dart';
import 'package:url_launcher/url_launcher.dart';

import '../util/smart_case_init.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  final ToastContext toast = ToastContext();

  bool enabled = true;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    toast.init(context);
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: _buildBody(),
    );
  }

  _buildBody() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ListView(
        children: [
          Column(
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
              const SizedBox(
                height: 40,
              ),
              Text(
                (currentUsername != null)
                    ? 'Welcome, ${currentUsername!}'
                    : 'Welcome',
                style: const TextStyle(
                    color: AppColors.white,
                    fontSize: 40,
                    fontWeight: FontWeight.w100),
              ),
              const SizedBox(
                height: 30,
              ),
              (currentUserEmail == null || currentUserEmail == '')
                  ? AuthTextField(
                      controller: emailController,
                      hintText: 'email',
                      enabled: enabled,
                      obscureText: false,
                      isEmail: true,
                      style: const TextStyle(color: AppColors.white),
                      borderSide: const BorderSide(color: AppColors.white),
                      fillColor: AppColors.primary,
                    )
                  : currentUserImage != null
                      ? CustomImage(currentUserImage)
                      : const CustomIconHolder(
                          width: 120,
                          height: 120,
                          graphic: Icons.account_circle,
                          bgColor: AppColors.white,
                          radius: 90,
                          size: 135,
                          isProfile: true,
                        ),
              const SizedBox(
                height: 20,
              ),
              AuthPasswordTextField(
                controller: passwordController,
                hintText: 'password',
                enabled: enabled,
                borderSide: const BorderSide(color: AppColors.white),
                style: const TextStyle(color: AppColors.white),
                fillColor: AppColors.primary,
                iconColor: AppColors.inActiveColor,
              ),
              const SizedBox(
                height: 10,
              ),
              (enabled) ? WideButton(
                name: 'Login',
                onPressed: _onPressed,
                bgColor: AppColors.gray,
                textStyle: const TextStyle(color: Colors.white, fontSize: 20),
              ) : const CircularProgressIndicator(color: AppColors.gray,),
              const SizedBox(
                height: 10,
              ),
              TextButton(
                onPressed: () {},
                child: const Text(
                  'Forgot password?',
                  style: TextStyle(
                    color: AppColors.white,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              _buildTextWithLink('contact us: ', 'info@infosectechno.com'),
              const SizedBox(
                height: 8,
              ),
              _buildTextWithAction('+256 (0)770456789'),
              const SizedBox(
                height: 8,
              ),
              Text(
                'copyright @ ${DateTime.now().year} SmartCase Manager',
                style: const TextStyle(
                  color: AppColors.inActiveColor,
                  fontWeight: FontWeight.w100,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  _buildTextWithLink(String data, String link) {
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

  _buildTextWithAction(String data) {
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
    if (EmailValidator.validate(
        currentUserEmail != '' && currentUserEmail != null
            ? currentUserEmail!
            : emailController.text)) {
      setState(() {
        enabled = false;
      });

      AuthApis.signInUser(
          currentUserEmail != '' && currentUserEmail != null
              ? currentUserEmail!
              : emailController.text,
          passwordController.text,
          onSuccess: _signUserIn,
          onNoUser: _handleWrongEmail,
          onWrongPassword: _handleWrongPass,
          onError: _handleError,
          onErrors: _handleErrors);
    } else {
      Toast.show("Email not valid",
          duration: Toast.lengthLong, gravity: Toast.bottom);
    }
  }

  _signUserIn() async {
    FocusManager.instance.primaryFocus?.unfocus();
    Navigator.popUntil(context, (route) => false);
    Navigator.pushNamed(context, '/root');

    await storage.write(key: 'email', value: emailController.text);
    await storage.write(key: 'name', value: currentUser.firstName);
    await storage.write(key: 'image', value: currentUser.avatar);
  }

  _handleWrongEmail() {
    Toast.show("User not found",
        duration: Toast.lengthLong, gravity: Toast.bottom);
    setState(() {
      enabled = true;
    });
  }

  _handleErrors(e) {
    Toast.show(e.toString(), duration: Toast.lengthLong, gravity: Toast.bottom);
    setState(() {
      enabled = true;
    });
  }

  _handleWrongPass() {
    Toast.show("Incorrect password",
        duration: Toast.lengthLong, gravity: Toast.bottom);
    setState(() {
      enabled = true;
    });
  }

  _handleError() {
    Toast.show("An error occurred",
        duration: Toast.lengthLong, gravity: Toast.bottom);
    setState(() {
      enabled = true;
    });
  }

  _getCurrentUserData() async {
    String? email = await storage.read(key: 'email');
    String? name = await storage.read(key: 'name');
    String? image = await storage.read(key: 'image');

    setState(() {
      currentUserEmail = email;
      currentUsername = name;
      currentUserImage = image;
    });
  }

  @override
  void initState() {
    _getCurrentUserData();
    super.initState();
  }
}
