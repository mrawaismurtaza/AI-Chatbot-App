import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final TextInputType keyboardType;
  final bool obscureText;
  final String? Function(String?)? validator;
  const CustomTextField({super.key,
    required this.controller,
    required this.hintText,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.validator,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {

  late bool _isObscured;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _isObscured = widget.obscuredText;
  }

  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);

    return TextFormField(
      controller: widget.controller,
      decoration: InputDecoration(
        filled: true,
        fillColor: theme.colorScheme.tertiary,
        labelText: widget.hintText,
        labelStyle: theme.textTheme.labellarge,
        border: InputBorder.none,
        suffixIcon: widget.obscureText ?
            IconButton(onPressed: () {
              setState( () {
                _isObscured = !_isObscured;
              });
            }, 
            icon: icon)
      ),
    );
  }
}