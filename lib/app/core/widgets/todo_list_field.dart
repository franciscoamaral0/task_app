import 'package:flutter/material.dart';

class TodoListField extends StatelessWidget {
  final String label;
  final bool obscureText;
  final IconButton? sufixIconButton;
  final ValueNotifier<bool> obscureTextVN;
  final TextEditingController? controller;
  final FormFieldValidator<String>? validator;
  final FocusNode? focusNode;
  TodoListField(
      {Key? key,
      required this.label,
      this.obscureText = false,
      this.sufixIconButton,
      this.controller,
      this.validator,
      this.focusNode})
      : assert(obscureText == true ? sufixIconButton == null : true,
            'obscureText não pode ser enviado em conjunto com suffixIconButtin'),
        obscureTextVN = ValueNotifier(obscureText),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: obscureTextVN,
      builder: (_, obscureTextValue, child) {
        return TextFormField(
          focusNode: focusNode,
          controller: controller,
          validator: validator,
          decoration: InputDecoration(
            labelText: label,
            labelStyle: const TextStyle(
              fontSize: 15,
              color: Colors.black,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: const BorderSide(color: Colors.red),
            ),
            isDense: true,
            suffixIcon: this.sufixIconButton ??
                (obscureText == true
                    ? IconButton(
                        onPressed: () {
                          obscureTextVN.value = !obscureTextValue;
                        },
                        icon: Icon(obscureTextValue
                            ? Icons.visibility
                            : Icons.visibility_off))
                    : null),
          ),
          obscureText: obscureTextValue,
        );
      },
    );
  }
}
