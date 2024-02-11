import '../../../../config.dart';

class LanguageDropDownLayout extends StatelessWidget {
  const LanguageDropDownLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OnBoardingController>(
      builder: (onBoardingCtrl) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: Sizes.s160,
              //
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: Insets.i10),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: appCtrl.appTheme.primary.withOpacity(0.8),
                  ),
                  color: Colors
                      .transparent, //appCtrl.appTheme.primary.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(AppRadius.r8),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DropdownButtonHideUnderline(
                    child: ButtonTheme(
                      alignedDropdown: true,
                      child: DropdownButton(
                        value: onBoardingCtrl.langValue,
                        style: AppCss.outfitSemiBold16
                            .textColor(appCtrl.appTheme.txt),
                        icon: SvgPicture.asset(
                          eSvgAssets.rightArrow,
                          fit: BoxFit.scaleDown,
                        ),
                        // SvgPicture.asset(
                        //   eSvgAssets.dropDown,
                        //   colorFilter: ColorFilter.mode(
                        //     appCtrl.appTheme.txt,
                        //     BlendMode.srcIn,
                        //   ),
                        // ),
                        isDense: true,
                        isExpanded: true,
                        hint: Text(
                          appFonts.english.toString().tr,
                          style: AppCss.outfitSemiBold16
                              .textColor(appCtrl.appTheme.txt.withOpacity(0.6)),
                        ),
                        items: onBoardingCtrl.selectLanguageLists
                            .asMap()
                            .entries
                            .map(
                          (e) {
                            return DropdownMenuItem(
                              value: "${e.value.title}",
                              child: Row(
                                children: [
                                  // Image.asset(e.value.image!,
                                  //     height: Sizes.s30),
                                  // const HSpace(Sizes.s6),
                                  Text(
                                    e.value.title!.toString().tr,
                                    overflow: TextOverflow.ellipsis,
                                    style: AppCss.outfitSemiBold16
                                        .textColor(appCtrl.appTheme.txt),
                                  ).width(Sizes.s55),
                                ],
                              ),
                              onTap: () =>
                                  onBoardingCtrl.onLanguageSelectTap(e.value),
                            );
                          },
                        ).toList(),
                        onChanged: (val) async {
                          onBoardingCtrl.langValue = val.toString();
                          onBoardingCtrl.update();
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ).paddingOnly(
              top: Insets.i50,
              bottom: Insets.i10,
            ),

            // SizedBox(
            //   width: Sizes.s106,
            //   child: DropdownButtonHideUnderline(
            //     child: ButtonTheme(
            //       child: DropdownButton(
            //         value: onBoardingCtrl.langValue,
            //         borderRadius: const BorderRadius.all(
            //           Radius.circular(AppRadius.r8),
            //         ),
            //         style:
            //             AppCss.outfitSemiBold16.textColor(appCtrl.appTheme.txt),
            //         icon: SvgPicture.asset(
            //           eSvgAssets.dropDown,
            //           colorFilter: ColorFilter.mode(
            //               appCtrl.appTheme.txt, BlendMode.srcIn),
            //         ),
            //         isDense: true,
            //         isExpanded: true,
            //         hint: Text(appFonts.english.toString().tr),
            //         items:
            //             onBoardingCtrl.selectLanguageLists.asMap().entries.map(
            //           (e) {
            //             return DropdownMenuItem(
            //               value: e.value.title,
            //               child: Row(
            //                 children: [
            //                   Image.asset(e.value.image!, height: Sizes.s30),
            //                   const HSpace(Sizes.s6),
            //                   Text(e.value.title!.toString().tr,
            //                           overflow: TextOverflow.ellipsis)
            //                       .width(Sizes.s55),
            //                 ],
            //               ),
            //               onTap: () =>
            //                   onBoardingCtrl.onLanguageSelectTap(e.value),
            //             );
            //           },
            //         ).toList(),
            //         onChanged: (val) async {
            //           onBoardingCtrl.langValue = val.toString();
            //           onBoardingCtrl.update();
            //         },
            //       ).paddingOnly(
            //         top: Insets.i50,
            //         bottom: Insets.i10,
            //       ),
            //     ),
            //   ),
            // ),
            if (onBoardingCtrl.selectIndex != 2)
              //
              // SizedBox(
              //   width: Sizes.s50,
              //   child: Container(
              //     padding: const EdgeInsets.symmetric(horizontal: Insets.i10),
              //     decoration: BoxDecoration(
              //       color: appCtrl.appTheme.primary.withOpacity(0.1),
              //       borderRadius: BorderRadius.circular(AppRadius.r8),
              //     ),
              //     child: Text(
              //       appFonts.skip.tr,
              //       style: AppCss.outfitMedium16.textColor(
              //         appCtrl.appTheme.lightText,
              //       ),
              //     ).inkWell(
              //       onTap: () {
              //         appCtrl.isOnboard = true;
              //         appCtrl.storage.write("isOnboard", appCtrl.isOnboard);
              //         appCtrl.update();
              //         Get.toNamed(routeName.allowNotificationScreen);
              //       },
              //     ).paddingOnly(top: Insets.i50, bottom: Insets.i10),
              //   ),
              // )
              SizedBox(
                width: Sizes.s70,
                height: Sizes.s45,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Insets.i10,
                    vertical: Insets.i10,
                  ),
                  decoration: BoxDecoration(
                      color: appCtrl.appTheme.lightText.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(AppRadius.r8),
                      border: Border.all(
                        color: appCtrl.appTheme.txt,
                        width: 2,
                      )),
                  child: Text(
                    appFonts.skip.tr,
                    style: AppCss.outfitMedium16
                        .textColor(appCtrl.appTheme.textField),
                  ).inkWell(
                    onTap: () {
                      appCtrl.isOnboard = true;
                      appCtrl.storage.write("isOnboard", appCtrl.isOnboard);
                      appCtrl.update();
                      Get.toNamed(routeName.allowNotificationScreen);
                    },
                  ),
                ),
              ).paddingOnly(
                top: Insets.i50,
                bottom: Insets.i10,
              ),
          ],
        ).paddingSymmetric(horizontal: Insets.i20);
      },
    );
  }
}
