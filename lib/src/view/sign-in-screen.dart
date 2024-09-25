import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../Widgets/social_signin.dart';
import '../Widgets/text_data_widget.dart';
import '../Widgets/text_form_field.dart';
import '../bloc/authentication/auth_bloc.dart';
import '../components/image_builder.dart';
import '../components/loader.dart';
import '../components/spacers.dart';
import '../constants.dart';
import '../images.dart';
import '../widgets/login-btn.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  late FocusNode usernameFocus;
  late FocusNode passwordFocus;
  late FocusNode loginBtnFocus;
  late TextEditingController userName;
  late TextEditingController password;

  @override
  void initState() {
    super.initState();
    usernameFocus = FocusNode();
    passwordFocus = FocusNode();
    loginBtnFocus = FocusNode();
    userName = TextEditingController();
    password = TextEditingController();
  }

  @override
  void dispose() {
    usernameFocus.dispose();
    passwordFocus.dispose();
    loginBtnFocus.dispose();
    userName.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthError) {
            buildErrorLayout();
          } else if (state is AuthLoaded) {
            clearTextData();
            Navigator.pushNamedAndRemoveUntil(
              context,
              '/dashboard',
              (Route<dynamic> route) => false,
              arguments: state.username,
            );
          }
        },
        builder: (context, state) {
          if (state is AuthLoading) {
            return LoadingWidget(child: buildInitialInput());
          } else {
            return buildInitialInput();
          }
        },
      ),
    );
  }

  Widget buildInitialInput() => SingleChildScrollView(
        child: Column(
          children: [
            ImageBuilder(imagePath: loginImages[1]),
            HeightSpacer(myHeight: kSpacing),
            InputField(
              focusNode: usernameFocus,
              textController: userName,
              label: "Username",
              icons: const Icon(Icons.person, color: Colors.blue),
            ),
            HeightSpacer(myHeight: kSpacing),
            InputField(
              focusNode: passwordFocus,
              textController: password,
              label: "Password",
              icons: const Icon(Icons.lock, color: Colors.blue),
            ),
            HeightSpacer(myHeight: kSpacing),
            LoginBtn(
              focusNode: loginBtnFocus,
              userName: userName,
              password: password,
            ),
            HeightSpacer(myHeight: kSpacing),
            const SocialSignIn(),
          ],
        ),
      );

  ScaffoldFeatureController buildErrorLayout() =>
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Masukkan username/password dengan benar'),
        ),
      );

  clearTextData() {
    userName.clear();
    password.clear();
  }
}
