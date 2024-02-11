import 'dart:developer';

import '../../../config.dart';

class LoginBody extends StatelessWidget {
  const LoginBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppController>(builder: (appCtrl) {
      log("FIRESEBASE : ${appCtrl.firebaseConfigModel!}");

      return Column(
        children: [
          IntrinsicHeight(
            child: Row(
              children: [
                // VerticalDivider(
                //         thickness: 4, width: 1, color: appCtrl.appTheme.primary)
                //     .backgroundColor(appCtrl.appTheme.error),
                // const HSpace(Sizes.s12),
                SizedBox(
                  width: Sizes.s266
                  // MediaQuery.of(context).size.height < 555 //534
                      // ? Sizes.s266
                      // : Sizes.s300
                      ,
                  child: Text(
                    maxLines: 2,
                    overflow: TextOverflow
                        .ellipsis, // Tambahkan properti overflow di sini
                    softWrap: true, // Tambahkan properti softWrap di sini
                    appFonts.fastResponse.tr,
                    style: AppCss.outfitSemiBold20
                        .textColor(appCtrl.appTheme.txt)
                        .textHeight(
                          1.3,
                        ),
                  ),
                ),
              ],
            ),
          ),
          const VSpace(Sizes.s20),
          Text(
            appFonts.aBuddyWhoAvailable.tr,
            style: AppCss.outfitBold12
                .textColor(appCtrl.appTheme.txt) //lightText)
                .textHeight(
                  1.3,
                ),
          ),
          const VSpace(Sizes.s20),
          Divider(
            thickness: 4,
            // width: 1,
            color: appCtrl.appTheme.txt,
          )..backgroundColor(Colors.transparent),
          // .backgroundColor(appCtrl.appTheme.error),
          const VSpace(Sizes.s20),
          Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 4,
                      color: appCtrl.appTheme.txt,
                    ),
                    borderRadius: BorderRadius.circular(
                      22,
                    ),
                  ),
                  child: ButtonCommon(
                    // borderColor: appCtrl.appTheme.lightText,
                    color: Colors.transparent,
                    title: appFonts.signUp,
                    onTap: () => Get.toNamed(
                      routeName.signUpScreen,
                    ),
                  ),
                ),
              ),
              const HSpace(Sizes.s15),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 4,
                      color: appCtrl.appTheme.txt,
                    ),
                    borderRadius: BorderRadius.circular(
                      22,
                    ),
                  ),
                  child: ButtonCommon(
                    color: Colors.transparent,
                    title: appFonts.signIn,
                    onTap: () => Get.toNamed(
                      routeName.signInScreen,
                    ),
                  ),
                ),
              ),
            ],
          ),
          // const OrLayout(),
          // if (appCtrl.firebaseConfigModel!.isGuestLoginEnable!)
          //   Text(appFonts.continueAsAGuest.tr,
          //           style:
          //               AppCss.outfitMedium16.textColor(appCtrl.appTheme.primary))
          //       .inkWell(onTap: () {
          //     appCtrl.isLogin = true;
          //     appCtrl.isGuestLogin = true;
          //     appCtrl.storage.write(session.isGuestLogin, true);
          //     appCtrl.storage.write(
          //         session.selectedCharacter, appArray.selectCharacterList[3]);
          //     Get.offAllNamed(routeName.dashboard);
          //     appCtrl.update();
          //   })
        ],
      );
    });
  }
}
