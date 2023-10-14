import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_case/data/data.dart';
import 'package:smart_case/theme/color.dart';
import 'package:smart_case/widgets/auth_text_field.dart';
import 'package:smart_case/widgets/custom_images/custom_image.dart';
import 'package:smart_case/widgets/wide_button.dart';
import 'package:url_launcher/url_launcher.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: _buildBody(),
    );
  }

  _buildBody() {
    return Padding(
      padding: const EdgeInsets.all(16),
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
          const SizedBox(
            height: 40,
          ),
          const Text(
            'Welcome',
            style: TextStyle(
                color: AppColors.white,
                fontSize: 40,
                fontWeight: FontWeight.w100),
          ),
          const SizedBox(
            height: 30,
          ),
          AuthTextField(
            controller: emailController,
            hintText: 'email',
            obscureText: false,
          ),
          const SizedBox(
            height: 20,
          ),
          AuthPasswordTextField(
            controller: passwordController,
            hintText: 'password',
          ),
          const SizedBox(
            height: 10,
          ),
          WideButton(
            name: 'Login',
            onPressed: _onPressed,
            bgColor: AppColors.gray,
            textStyle: const TextStyle(color: Colors.white, fontSize: 20),
          ),
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
                  ..onTap = () {
                    launchUrl(Uri(
                      scheme: "mailto",
                      path: "support@homepal.org",
                      query: encodeQueryParameters(<String, String>{
                        'subject': 'Support mail',
                      }),
                    ));
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
    if (emailController.text == userEmail &&
        passwordController.text == userPassword) {
      Navigator.pushNamed(context, '/home');
    }
  }
}
