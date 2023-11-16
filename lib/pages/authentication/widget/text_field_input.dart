import 'package:flutter/material.dart';


class TextFieldInput extends StatelessWidget {
  final TextEditingController textEditingController;
  final TextInputType textInputType;
  final String hintText;
  final bool isPassword;
  final int maxLines;
  const TextFieldInput(
      {super.key,
      required this.textEditingController,
      required this.textInputType,
      required this.hintText,
      this.isPassword = false,
      this.maxLines = 1
      });

  @override
  Widget build(BuildContext context) {
    final textFieldBorder = OutlineInputBorder(
      //borderSide: Divider.createBorderSide(context),
      borderRadius: BorderRadius.circular(18.0)
    );
    return TextField(
      controller: textEditingController,
      keyboardType: textInputType,
      obscureText: isPassword,
      maxLines: maxLines,
      decoration: InputDecoration(
        fillColor:const Color.fromARGB(255, 204, 218, 225),
        hintText: hintText,
        border: textFieldBorder,
        focusedBorder: textFieldBorder,
        enabledBorder: textFieldBorder,
        filled: true,
      ),
    );
  }
}
