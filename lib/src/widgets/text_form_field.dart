import 'package:flutter/material.dart';

import '../constants.dart';

class InputField extends StatelessWidget {
  const InputField({
    Key? key,
    required this.focusNode,
    required this.textController,
    required this.label,
    required this.icons,
  }) : super(key: key);

  final FocusNode focusNode;
  final TextEditingController textController;
  final String label;
  final Icon icons;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: Constants.kHPadding,
      child: TextFormField(
        obscureText: label == "Password" ? true : false,
        controller: textController,
        autofocus: false,
        onFieldSubmitted: (value) {
          FocusScope.of(context).requestFocus(focusNode);
        },
        decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.blue),
                borderRadius: Constants.kBorderRadius),
            focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.blue),
                borderRadius: Constants.kBorderRadius),
            hintStyle: const TextStyle(color: Colors.blue),
            filled: true,
            fillColor: Colors.transparent,
            hintText: label,
            prefixIcon: icons),
      ),
    );
  }
}
