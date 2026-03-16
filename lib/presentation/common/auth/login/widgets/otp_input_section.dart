import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/themes/dimens.dart';
import 'package:zent_fe/presentation/common/core/themes/boxshadow.dart';
import 'package:zent_fe/presentation/common/core/themes/text_styles.dart';

class OtpInputSection extends StatefulWidget {
  const OtpInputSection({super.key});

  @override
  State<OtpInputSection> createState() => _OtpInputSectionState();
}

class _OtpInputSectionState extends State<OtpInputSection> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final int _otpLength = 6;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Opacity(
          opacity: 0,
          child: TextField(
            controller: _controller,
            focusNode: _focusNode,
            autofocus: true,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(_otpLength),
            ],
            onChanged: (value) => setState(() {}),
          ),
        ),

        GestureDetector(
          onTap: () => _focusNode.requestFocus(),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(_otpLength, (index) {
              String char = "";
              if (_controller.text.length > index) {
                char = _controller.text[index];
              }

              bool isFocused =
                  (_controller.text.length == index) && _focusNode.hasFocus;

              return _buildOtpBox(char, isFocused);
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildOtpBox(String digit, bool isFocused) {
    bool hasValue = digit.isNotEmpty;
    return Container(
      width: 48,
      height: 48,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: isFocused ? AppColors.surface50 : AppColors.surface50,
        borderRadius: BorderRadius.circular(AppDimens.boraSm),
        border: Border.all(
          color: isFocused
              ? AppColors.tertiary500
              : (hasValue ? AppColors.tertiary500 : AppColors.secondary200),
          width: isFocused ? 2.0 : 1.0,
        ),
        boxShadow: isFocused ? [BoxShadowStyles.raised] : null,
      ),
      child: isFocused && !hasValue
          ? _buildCursor()
          : Text(
              digit,
              style: TextStyles.title.copyWith(fontWeight: FontWeight.bold),
            ),
    );
  }

  Widget _buildCursor() {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 1.0, end: 0.0),
      duration: const Duration(milliseconds: 500),
      builder: (context, value, child) => Opacity(
        opacity: value > 0.5 ? 1 : 0,
        child: Container(width: 2, height: 24, color: AppColors.tertiary500),
      ),
      onEnd: () => setState(() {}),
    );
  }
}
