import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smart_case/widgets/custom_images/custom_image.dart';

import '../services/apis/auth_apis.dart';
import '../theme/color.dart';
import '../util/smart_case_init.dart';

class LoginPromptPage extends StatelessWidget {
  const LoginPromptPage({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.immersiveSticky,
      overlays: [SystemUiOverlay.top],
    );
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
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
                              const Text(
                                "Hey! Welcome",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w300),
                              ),
                              const SizedBox(height: 30),
                              OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  side:
                                      const BorderSide(color: AppColors.gray45),
                                  fixedSize: Size.fromWidth(
                                      MediaQuery.of(context).size.width * .75),
                                ),
                                onPressed: () =>
                                    Navigator.pushNamed(context, "/login"),
                                child: Text(
                                  'Continue as ${currentUsername!}',
                                  style: const TextStyle(
                                      color: AppColors.gray45, fontSize: 20),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(
                                  top: 10,
                                  bottom: 10,
                                ),
                                child: const Text(
                                  "- Or -",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w300),
                                ),
                              ),
                              FilledButton(
                                style: OutlinedButton.styleFrom(
                                  backgroundColor: AppColors.gray45,
                                  side:
                                      const BorderSide(color: AppColors.gray45),
                                  fixedSize: Size.fromWidth(
                                      MediaQuery.of(context).size.width * .75),
                                ),
                                onPressed: () {
                                  AuthApis.signOutUser().then((value) {
                                    // Navigator.pushNamed(context, '/login');
                                    Navigator.pushNamed(context, '/');
                                  });
                                },
                                child: const Text(
                                  'Change user',
                                  style: TextStyle(
                                      color: Colors.black54, fontSize: 20),
                                ),
                              ),
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
}
