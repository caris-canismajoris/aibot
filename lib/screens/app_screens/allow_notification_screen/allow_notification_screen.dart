import '../../../config.dart';

class AllowNotificationScreen extends StatelessWidget {
  final allowNotificationCtrl = Get.put(AllowNotificationController());
  AllowNotificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AllowNotificationController>(builder: (_) {
      return Scaffold(
          backgroundColor: appCtrl.appTheme.bg1,
          resizeToAvoidBottomInset: false,
          // appBar: const AppBarCommon(isSystemNavigate: true),
          body: Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/backgroundwp/bgwp2.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(),
                    Column(
                      children: [
                        Image.asset(eImageAssets.message, height: Sizes.s300),
                        const VSpace(Sizes.s40),
                        Text(appFonts.allowNotification.tr,
                            style: AppCss.outfitSemiBold20
                                .textColor(appCtrl.appTheme.txt)),
                        const VSpace(Sizes.s10),
                        Text(appFonts.weWantToGiveYou.tr,
                            textAlign: TextAlign.center,
                            style: AppCss.outfitMedium16
                                .textColor(appCtrl.appTheme.lightText)
                                .textHeight(1.3)),
                      ],
                    ),
                    Column(
                      children: [
                        ButtonCommon(
                          borderColor: appCtrl.appTheme.primary,
                          color: Colors.transparent,
                            title: appFonts.allow,
                            onTap: () => allowNotificationCtrl.onTapAllow()),
                        const VSpace(Sizes.s10),
                        ButtonCommon(
                            title: appFonts.doItLater,
                            color: appCtrl.appTheme.trans,
                            style: AppCss.outfitMedium18
                                .textColor(appCtrl.appTheme.primary),
                            onTap: () => Get.toNamed(routeName.loginScreen,
                                arguments: false))
                      ],
                    )
                  ]).paddingAll(Insets.i40),
            ],
          ));
    });
  }
}
