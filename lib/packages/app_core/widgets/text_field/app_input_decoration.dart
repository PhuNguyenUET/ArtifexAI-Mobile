import '../../../index.dart';

class AppInputDecoration {
  static InputDecoration normal(
    BuildContext context, {
    String? hintText,
    String? labelText,
    Widget? prefixIcon,
    Widget? suffixIcon,
    // Icon before and outside of the TextFormField border
    Widget? icon,
    EdgeInsets? contentPadding,
    bool enabled = true,
    bool filled = false,
    Color? fillColor,
    double? borderRadius,
    String? counterText,
    TextStyle? counterStyle,
    String? helperText,
    TextStyle? helperStyle,
    TextStyle? errorStyle,
    BoxConstraints? prefixIconConstraints,
  }) {
    final br = borderRadius ?? 12.0;
    final side = BorderSide(color: AppColor.spaceBorder, width: AppStyleConstant.textFieldBorderWidth);
    final focusSide = const BorderSide(color: AppColor.primary, width: AppStyleConstant.textFieldBorderWidth);
    final errorSide = const BorderSide(color: AppColor.alertError, width: AppStyleConstant.textFieldBorderWidth);
    final disabledSide = BorderSide(color: AppColor.spaceBorder.withValues(alpha: 0.4), width: AppStyleConstant.textFieldBorderWidth);

    return InputDecoration(
      counterText: counterText ?? "",
      border:             OutlineInputBorder(borderRadius: BorderRadius.circular(br), borderSide: side),
      enabledBorder:      OutlineInputBorder(borderRadius: BorderRadius.circular(br), borderSide: side),
      focusedBorder:      OutlineInputBorder(borderRadius: BorderRadius.circular(br), borderSide: focusSide),
      focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(br), borderSide: errorSide),
      errorBorder:        OutlineInputBorder(borderRadius: BorderRadius.circular(br), borderSide: errorSide),
      disabledBorder:     OutlineInputBorder(borderRadius: BorderRadius.circular(br), borderSide: disabledSide),
      labelText: labelText,
      labelStyle: context.label1.copyWith(color: AppColor.spaceTextSecondary),
      helperStyle: helperStyle ?? context.subtitle4.copyWith(color: AppColor.spaceTextHint, height: 1.0),
      helperText: helperText ?? ' ',
      errorStyle: errorStyle ?? context.subtitle4.copyWith(color: AppColor.alertErrorSub, height: 1.0),
      counterStyle: counterStyle ?? context.subtitle3.copyWith(color: AppColor.spaceTextHint),
      hintText: hintText,
      hintStyle: context.body3.copyWith(color: AppColor.spaceTextHint, height: 1.0),
      contentPadding: contentPadding,
      prefixIcon: prefixIcon != null
          ? Padding(
              padding: const EdgeInsets.only(left: AppStyleConstant.textFieldHPadding),
              child: prefixIcon,
            )
          : null,
      prefixIconConstraints: prefixIconConstraints ?? AppStyleConstant.textFieldConstraints,
      suffixIcon: suffixIcon != null
          ? Padding(padding: const EdgeInsets.only(right: 0), child: suffixIcon)
          : null,
      suffixIconConstraints: AppStyleConstant.textFieldConstraints,
      icon: icon,
      fillColor: fillColor ?? AppColor.spaceInputFill,
      filled: true,
      enabled: enabled,
    );
  }
}


