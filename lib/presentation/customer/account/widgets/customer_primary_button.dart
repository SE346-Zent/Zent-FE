import 'package:flutter/material.dart';
import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/themes/dimens.dart';
import 'package:zent_fe/presentation/common/core/themes/text_styles.dart';

class CustomerPrimaryButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final IconData? icon;
  final bool isLoading;

  const CustomerPrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
  });

  @override
  State<CustomerPrimaryButton> createState() => _CustomerPrimaryButtonState();
}

class _CustomerPrimaryButtonState extends State<CustomerPrimaryButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final buttonChild = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (widget.icon != null && !widget.isLoading)
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Icon(widget.icon, color: Colors.white, size: 20),
          ),
        widget.isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : Text(
                widget.text,
                style: TextStyles.title.copyWith(color: Colors.white),
              ),
      ],
    );

    return GestureDetector(
      onTapDown: widget.isLoading
          ? null
          : (_) => setState(() => _isPressed = true),
      onTapUp: widget.isLoading
          ? null
          : (_) {
              setState(() => _isPressed = false);
              Future.delayed(
                const Duration(milliseconds: 100),
                widget.onPressed,
              );
            },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedScale(
        scale: _isPressed ? 0.96 : 1.0,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeInOut,
        child: Container(
          width: double.infinity,
          height: 50.0,
          decoration: BoxDecoration(
            color: AppColors.tertiary500,
            borderRadius: BorderRadius.circular(AppDimens.boraMd),
          ),
          child: Material(
            color: Colors.transparent,
            child: Center(child: buttonChild),
          ),
        ),
      ),
    );
  }
}
