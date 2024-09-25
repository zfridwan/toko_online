import 'package:flutter/material.dart';

import '../components/spacers.dart';
import '../constants.dart';

class SocialSignIn extends StatelessWidget {
  const SocialSignIn({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Wrap(
          alignment: WrapAlignment.center,
          spacing: 15.5, // Horizontal space between the buttons
          runSpacing: 10.0, // Vertical space between wrapped lines
          children: [
            buildBtn("Sign in with Facebook", Colors.blue, Icons.facebook),
            buildBtn("Sign in with Gmail", Colors.red, Icons.mail),
          ],
        );
      },
    );
  }

  Widget buildBtn(String text, Color btnColor, IconData iconData) => Flexible(
        child: Container(
          constraints: BoxConstraints(
            maxWidth: 192, // Sets a maximum width but allows flexibility
          ),
          height: 40,
          decoration: BoxDecoration(
            borderRadius: kBorderRadius,
            color: btnColor,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                iconData,
                color: Colors.white,
              ),
              const WidthSpacer(myWidth: 7.00),
              Flexible(
                child: Text(
                  text,
                  style: const TextStyle(color: Colors.white),
                  overflow: TextOverflow.ellipsis, // Prevents text overflow
                ),
              ),
            ],
          ),
        ),
      );
}
