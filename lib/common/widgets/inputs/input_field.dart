import 'package:flutter/material.dart';
import 'package:substandard_products/common/extension/text_styles.dart';
import 'package:substandard_products/common/extension/theme_colors.dart';

import '../../styles/color_constants.dart';
import '../../styles/dimens.dart';

class InputField extends StatefulWidget {
  const InputField({
    super.key,
    required this.controller,
    required this.hintText,
    this.suffixIcon,
    this.validator,
    this.editingConplete,
    this.errorText,
    this.obscureText = false,
    this.maxlines = 1,
    this.onChanged,
    this.enabled = true,
    this.inputType = TextInputType.text,
    required this.labelText,
  });
  final TextEditingController controller;
  final String hintText, labelText;
  final String? errorText;
  final String? Function(String?)? validator;
  final Widget? suffixIcon;
  final int maxlines;
  final bool obscureText, enabled;

  final TextInputType? inputType;
  final Function(String)? onChanged;
  final Function? editingConplete;

  @override
  State<InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: SizedBox(
        child: TextFormField(
          readOnly: false,
          obscureText: widget.obscureText,
          enabled: widget.enabled,
          maxLines: widget.maxlines,
          controller: widget.controller,
          onChanged: widget.onChanged,
          onFieldSubmitted: widget.onChanged,
          onEditingComplete: () => widget.editingConplete,
          onTapOutside: (event) => widget.editingConplete,
          keyboardType: widget.inputType ?? TextInputType.text,
          validator: widget.validator,
          decoration: InputDecoration(
              label: Text(
                widget.labelText,
                style: context.labelLarge!
                    .copyWith(fontWeight: FontWeight.w400, color: greyColor),
              ),
              fillColor: context.scaffoldColor,
              errorText: widget.errorText,
              filled: true,
              hintText: widget.hintText,
              hintStyle: context.bodySmall!.copyWith(color: greyColor),
              suffixIcon: widget.suffixIcon,
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(kSmall),
                borderSide: const BorderSide(color: greyColor, width: 0.7),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(kSmall),
                //borderSide: const BorderSide(color: greyColor, width: 0.7),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(kSmall),
                borderSide: BorderSide(color: context.errorColor, width: 0.7),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(kSmall),
                borderSide: const BorderSide(color: greyColor, width: 0.7),
              ),
              errorStyle: TextStyle(color: context.errorColor)),
        ),
      ),
    );
  }
}
