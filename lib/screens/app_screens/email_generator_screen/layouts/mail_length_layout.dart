import '../../../../config.dart';
import '../temp_email_gen/temp_email_gen_controller.dart';

class MailLengthLayout extends StatelessWidget {
  const MailLengthLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TempEmailGeneratorController>(builder: (emailGeneratorCtrl) {
      return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: emailGeneratorCtrl.mailLengthLists
              .asMap()
              .entries
              .map((e) => Text(e.value.toString().tr,
                  style: AppCss.outfitSemiBold14.textColor(
                      emailGeneratorCtrl.value >= e.key
                          ? appCtrl.appTheme.primary
                          : appCtrl.appTheme.lightText)))
              .toList());
    });
  }
}
