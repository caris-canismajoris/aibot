import 'package:aibot/config.dart';

class Setting extends StatelessWidget {
  final settingCtrl = Get.put(SettingController());

  Setting({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SettingController>(
      builder: (context) {
        return DirectionalityRtl(
          child: Scaffold(
            key: settingCtrl.scaffoldKey,
            backgroundColor: appCtrl.appTheme.bg1,
            drawer: const CommonDrawer(),
            // appBar: AppBar(
            //     leadingWidth: Sizes.s70,
            //     // leading: const CommonMenuIcon().inkWell(
            //     //     onTap: () =>
            //     //         settingCtrl.scaffoldKey.currentState!.openDrawer()),
            //     automaticallyImplyLeading: false,
            //     backgroundColor: appCtrl.appTheme.primary,
            //     title: Text(appFonts.setting.tr,
            //         style: AppCss.outfitExtraBold22
            //             .textColor(appCtrl.appTheme.sameWhite))),
            body: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/backgroundwp/bgwp2.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SingleChildScrollView(
                  child: Column(
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: Sizes.s34),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                  22,
                                ),
                                border: Border.all(
                                  color: appCtrl.appTheme.white,
                                )
                              ),
                              width: double.infinity,
                              height: Sizes.s200,
                              child: Image.asset(
                                'assets/images/backgroundwp/bgwp1.png',
                                fit: BoxFit.cover,
                                // eImageAssets.settingBg,
                              )
                                  .marginOnly(
                                      top: Insets.i25,
                                      left: Insets.i20,
                                      right: Insets.i20,
                                      bottom: Insets.i20)
                                  .decorated(
                                    borderRadius: BorderRadius.circular(
                                      22,
                                    ),
                                  ),
                            ),
                          ),
                          Column(
                            children: [
                              const SettingUser(),
                              const VSpace(Sizes.s10),
                              Text(
                                settingCtrl.userName ?? "Welcome to ChatBot",
                                style: AppCss.outfitBold24 //Medium14
                                    .textColor(appCtrl.appTheme.black), //txt),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const VSpace(Sizes.s20),
                      ...settingCtrl.settingList
                          .asMap()
                          .entries
                          .map(
                            (e) => e.value["title"] == "logout"
                                ? appCtrl.isGuestLogin
                                    ? Container()
                                    : SettingList(index: e.key, data: e.value)
                                        .marginSymmetric(horizontal: Insets.i20)
                                : SettingList(index: e.key, data: e.value)
                                    .marginSymmetric(horizontal: Insets.i20),
                          )
                          .toList(),
                    ],
                  ).marginOnly(bottom: Insets.i25),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
