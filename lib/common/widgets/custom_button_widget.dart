import 'package:sixam_mart_delivery/util/dimensions.dart';
import 'package:sixam_mart_delivery/util/styles.dart';
import 'package:flutter/material.dart';

class CustomButtonWidget extends StatelessWidget {
  final Function? onPressed;
  final String buttonText;
  final bool transparent;
  final EdgeInsets? margin;
  final double? height;
  final double? width;
  final double? fontSize;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? fontColor;
  final double radius;
  const CustomButtonWidget({super.key, this.onPressed, required this.buttonText, this.transparent = false, this.margin, this.width, this.height,
    this.fontSize, this.icon, this.backgroundColor, this.fontColor, this.radius = Dimensions.radiusSmall + 3});

  @override
  Widget build(BuildContext context) {

    final ButtonStyle flatButtonStyle = TextButton.styleFrom(
      backgroundColor: onPressed == null ? Theme.of(context).disabledColor : transparent
        ? Colors.transparent : backgroundColor ?? Theme.of(context).primaryColor,
      minimumSize: Size(width != null ? width! : 1170, height != null ? height! : 50),
      padding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius)),
    );

    return Padding(
      padding: margin == null ? const EdgeInsets.all(0) : margin!,
      child: TextButton(
        onPressed: onPressed as void Function()?,
        style: flatButtonStyle,
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [

          icon != null ? Icon(
            icon, color: transparent ? Theme.of(context).primaryColor : Theme.of(context).cardColor, size: 20,
          ) : const SizedBox(),
          SizedBox(width: icon != null ? Dimensions.paddingSizeExtraSmall : 0),

          Text(buttonText, textAlign: TextAlign.center, style: PoppinsBold.copyWith(
            color: transparent ? Theme.of(context).primaryColor : fontColor ?? Theme.of(context).cardColor,
            fontSize: fontSize ?? Dimensions.fontSizeLarge,
          )),

        ]),
      ),
    );
  }
}
