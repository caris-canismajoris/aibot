import '../../../../config.dart';

class QuickViewAllLayout extends StatelessWidget {
  const QuickViewAllLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(appFonts.quickAdvice.tr,
              style: AppCss.outfitSemiBold22 //16
                  .textColor(appCtrl.appTheme.txt)),
          Text(appFonts.viewAll.tr,
              style: AppCss.outfitSemiBold16 //12
                  .textColor(appCtrl.appTheme.txt)) //primary))
              .inkWell(
              onTap: () =>
                  Get.toNamed(routeName.quickAdvisor))
        ]).paddingSymmetric(vertical: Insets.i20);
  }
}
