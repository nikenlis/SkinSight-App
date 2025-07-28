import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import 'package:skinsight/core/theme/app_color.dart';

class ProfileFormItems extends StatefulWidget {
  final String? title;
  final bool obsecureText;
  final TextEditingController? controller;
  final bool isShowTitle;
  final bool iconVisibility;
  final Function(String)? onFieldSubmitted;
  final bool isShowHint;
  final String? hintTitle;
  final String? errorText;
  //final bool isError;
  final bool readOnly;
  final List<TextInputFormatter> textInputFormatter;
  final TextInputAction textInputAction;
  final TextInputType textInputType;
  final FocusNode? focusNode;
  final Function(String)? onChanged;
  final String? Function(String?)? validator;

  const ProfileFormItems({
    super.key,
    this.title,
    this.obsecureText = false,
    this.controller,
    this.isShowTitle = true,
    this.iconVisibility = false,
    this.onFieldSubmitted,
    //this.isError = false,
    this.errorText,
    this.readOnly = false,
    this.isShowHint = false,
    this.hintTitle,
    required this.textInputFormatter,
    required this.textInputAction,
    required this.textInputType,
    this.focusNode,
    this.onChanged,
    this.validator,
  });

  @override
  State<ProfileFormItems> createState() => _ProfileFormItemsState();
}

class _ProfileFormItemsState extends State<ProfileFormItems> {
  late bool _obsecureText;

  @override
  void initState() {
    super.initState();
    _obsecureText = widget.obsecureText;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.isShowTitle)
          Text(
            widget.title!,
            style: Theme.of(context)
                .textTheme
                .titleSmall
                ?.copyWith(fontSize: 14, fontWeight: regular),
          ),
        if (widget.isShowTitle)
          const SizedBox(
            height: 6,
          ),
        TextFormField(
          obscureText: _obsecureText,
          controller: widget.controller,
          readOnly: widget.readOnly,
          inputFormatters: widget.textInputFormatter,
          textInputAction: widget.textInputAction,
          keyboardType: widget.textInputType,
          style: Theme.of(context)
              .textTheme
              .titleSmall
              ?.copyWith(fontSize: 16, fontWeight: regular, color: Colors.black),
          decoration: InputDecoration(
              hintText: widget.isShowHint ? widget.hintTitle : null,
              hintStyle: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontSize: 16,
                  fontWeight: regular,
                  color: blackColor.withValues(alpha: 0.5)),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(
                    color: blackColor.withValues(alpha: 0.4), width: 1.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: mainColor, width: 1.0),
              ),
              errorText: widget.errorText,
              errorStyle: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontSize: 16, fontWeight: regular, color: redColor),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: redColor, width: 1),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
              isDense: true,
              filled: true,
              fillColor: lightBackgroundColor,
              suffixIcon: widget.iconVisibility
                  ? IconButton(
                      onPressed: () {
                        setState(() {
                          _obsecureText = !_obsecureText;
                        });
                      },
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      icon: Icon(
                        _obsecureText ? Icons.visibility_off_outlined : Icons.visibility_off_outlined,
                        color: blackColor.withValues(alpha: 0.6),
                        size: 20,
                      ))
                  : null,

                  prefixIcon: Icon(Iconsax.user_edit)
                  ),
              
          onFieldSubmitted: widget.onFieldSubmitted,
          focusNode: widget.focusNode,
          onChanged: widget.onChanged,
          validator: widget.validator,
        ),
      ],
    );
  }
}
