import '../../../../config.dart';

class SelectLangButtonCommon extends StatelessWidget {
  final String title;
  final double? padding, margin, radius, height, fontSize, width, widthBorder;
  final GestureTapCallback? onTap;
  final TextStyle? style;
  final Color? color, fontColor, borderColor;
  final Widget? icon;
  final FontWeight? fontWeight;
  final bool isGradient;

  const SelectLangButtonCommon(
      {Key? key,
      required this.title,
      this.padding,
      this.margin = 0,
      this.radius = AppRadius.r8,
      this.height = 46,
      this.fontSize = FontSizes.f30,
      this.onTap,
      this.style,
      this.color,
      this.fontColor,
      this.icon,
      this.borderColor,
      this.width,
      this.widthBorder,
      this.isGradient = true,
      this.fontWeight = FontWeight.w700})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: width ?? MediaQuery.of(context).size.width,
        height: height,
        margin: EdgeInsets.symmetric(horizontal: margin!),
        decoration: BoxDecoration(
            border: Border.all(
              color: borderColor ?? appCtrl.appTheme.trans,
              width: widthBorder ?? 1.0,// ?? MediaQuery.of(context).size.width,
            ),
            gradient: isGradient
                ? const LinearGradient(colors: [
                    Color.fromARGB(255, 56, 1, 255),
                    Color.fromARGB(255, 0, 215, 243),
                    Color.fromARGB(255, 56, 56, 56),
                  ], begin: Alignment(9, 2), end: Alignment(-2, -2))
                : null,
            color: color,
            borderRadius: BorderRadius.circular(radius!)),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          if (icon != null)
            Row(children: [icon ?? const HSpace(0), const HSpace(Sizes.s10)]),
          Text(title.tr,
              textAlign: TextAlign.center,
              style: style ??
                  AppCss.outfitSemiBold16.textColor(appCtrl.appTheme.black)) //sameWhite))
        ])).inkWell(onTap: onTap);
  }
}
