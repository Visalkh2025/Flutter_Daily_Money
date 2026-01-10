import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final bool obscureText;
  final TextInputType? keyboardType;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;

  const CustomTextField({
    super.key,
    required this.label,
    required this.hint,
    required this.controller,
    this.validator,
    this.obscureText = false,
    this.keyboardType,
    this.suffixIcon,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  String? _errorText;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 1),
          decoration: BoxDecoration(
            color: const Color(0xFFF7F7F9),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 0),
              TextFormField(
                controller: widget.controller,
                obscureText: widget.obscureText,
                keyboardType: widget.keyboardType,
                validator: (value) {
                  if (widget.validator != null) {
                    final error = widget.validator!(value);
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (mounted) {
                        setState(() {
                          _errorText = error;
                        });
                      }
                    });
                  }
                  return null;
                },
                autovalidateMode: AutovalidateMode.onUserInteraction,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
                decoration: InputDecoration(
                  labelText: widget.label,
                  labelStyle: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                  hintText: widget.hint,
                  hintStyle: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.grey[400]),
                  errorStyle: const TextStyle(height: 0),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: const EdgeInsets.only(top: 4, bottom: 8),
                  suffixIcon: widget.suffixIcon,
                  suffixIconConstraints: const BoxConstraints(
                    minWidth: 40,
                    minHeight: 40,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (_errorText != null)
          Padding(
            padding: const EdgeInsets.only(left: 16.0, top: 4.0),
            child: Text(
              _errorText!,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.red, fontSize: 12),
            ),
          ),
      ],
    );
  }
}
