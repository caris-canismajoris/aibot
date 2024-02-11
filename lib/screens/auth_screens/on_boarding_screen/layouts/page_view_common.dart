import '../../../../config.dart';
import 'bottom_button.dart';
import 'bottom_layout_text.dart';

class PageViewCommon extends StatelessWidget {
  final dynamic data;
  final GestureTapCallback? onTap;
  final String? title, description;

  const PageViewCommon(
      {Key? key, this.onTap, this.data, this.title, this.description})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // return GetBuilder<OnBoardingController>(
    //   builder: (onBoardingCtrl) {
    //     return Column(
    //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //       children: [
    //         const LanguageDropDownLayout(),
    //         OnBoardBottomLayoutText(
    //           title: title,
    //           description: description,
    //         ),
    //         Stack(
    //           alignment: Alignment.topRight,
    //           children: [
    //             SizedBox(
    //                 height: MediaQuery.of(context).size.height < 534
    //                     ? MediaQuery.of(context).size.height * 0.3
    //                     : MediaQuery.of(context).size.height * 0.58,
    //                 width: MediaQuery.of(context).size.height < 534
    //                     ? MediaQuery.of(context).size.height * 0.3
    //                     : MediaQuery.of(context).size.height * 0.58,
    //                 child: Stack(
    //                   alignment: Alignment.center,
    //                   children: [
    //                     Image.asset(eImageAssets.dBg2),
    //                     Row(
    //                     mainAxisAlignment: MainAxisAlignment.center,
    //                     children: List<Widget>.generate(
    //                       onBoardingCtrl.onBoardingLists.length,
    //                       (index) => InkWell(
    //                         onTap: () {
    //                           onBoardingCtrl.pageCtrl.animateToPage(index,
    //                               duration: const Duration(milliseconds: 300),
    //                               curve: Curves.easeIn);
    //                         },
    //                         child: const SizedBox(
    //                                 height: Sizes.s22, width: Sizes.s22)
    //                             .decorated(
    //                               color: onBoardingCtrl.selectIndex >= index
    //                                   ? appCtrl.appTheme.primary
    //                                   : appCtrl.appTheme.primary
    //                                       .withOpacity(0.2),
    //                               borderRadius: const BorderRadius.all(
    //                                 Radius.circular(
    //                                   AppRadius.r10,
    //                                 ),
    //                               ),
    //                             )
    //                             .paddingSymmetric(
    //                               horizontal: Insets.i3,
    //                             ),
    //                       ),
    //                     ),
    //                   ),
    //                     // // OnBoardBottomButtonLayout(
    //                     // //   onTap: onTap,
    //                     // // ),
    //                 //     Image.network(
    //                 //   data,
    //                 //   fit: BoxFit.cover,
    //                 // ),
    //                   ],
    //                 )
    //                 // Image.network(
    //                 //   data,
    //                 //   fit: BoxFit.cover,
    //                 // ),
    //                 ).paddingOnly(top: Insets.i45),
    //             // const LanguageDropDownLayout(),
    //           ],
    //         ),
    //         OnBoardBottomButtonLayout(
    //                 onTap: onTap,
    //               ),

    //         // Row(
    //         //   mainAxisAlignment: MainAxisAlignment.center,
    //         //   children: List<Widget>.generate(
    //         //     onBoardingCtrl.onBoardingLists.length,
    //         //     (index) => InkWell(
    //         //       onTap: () {
    //         //         onBoardingCtrl.pageCtrl.animateToPage(index,
    //         //             duration: const Duration(milliseconds: 300),
    //         //             curve: Curves.easeIn);
    //         //       },
    //         //       child: const SizedBox(height: Sizes.s5, width: Sizes.s22)
    //         //           .decorated(
    //         //             color: onBoardingCtrl.selectIndex >= index
    //         //                 ? appCtrl.appTheme.primary
    //         //                 : appCtrl.appTheme.primary.withOpacity(0.2),
    //         //             borderRadius: const BorderRadius.all(
    //         //               Radius.circular(
    //         //                 AppRadius.r10,
    //         //               ),
    //         //             ),
    //         //           )
    //         //           .paddingSymmetric(
    //         //             horizontal: Insets.i3,
    //         //           ),
    //         //     ),
    //         //   ),
    //         // ),
    //         const VSpace(Sizes.s10),
    //         // OnBoardBottomLayout(
    //         //   title: title,
    //         //   description: description,
    //         //   onTap: onTap,
    //         // ),
    //       ],
    //     );
    //   },
    // );
    return GetBuilder<OnBoardingController>(
      builder: (onBoardingCtrl) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const LanguageDropDownLayout(),
            OnBoardBottomLayoutText(
              title: title,
              description: description,
            ),
            Stack(
              alignment: Alignment.topRight,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  height: MediaQuery.of(context).size.height < 534
                      ? MediaQuery.of(context).size.height * 0.3
                      : MediaQuery.of(context).size.height * 0.58,
                  width: MediaQuery.of(context).size.height < 534
                      ? MediaQuery.of(context).size.height * 0.3
                      : MediaQuery.of(context).size.height * 0.58,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(22),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(22),
                            child: (data != null)
                                ? Image.network(
                                    data,
                                    fit: BoxFit.cover,
                                  )
                                : Image.asset(
                                    eImageAssets.dBg2,
                                    fit: BoxFit.fill,
                                  ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 22,
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List<Widget>.generate(
                              onBoardingCtrl.onBoardingLists.length,
                              (index) => InkWell(
                                onTap: () {
                                  onBoardingCtrl.pageCtrl.animateToPage(
                                    index,
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeIn,
                                  );
                                },
                                child: const SizedBox(
                                  height: Sizes.s22,
                                  width: Sizes.s22,
                                )
                                    .decorated(
                                      color: onBoardingCtrl.selectIndex >= index
                                          ? appCtrl.appTheme.primary
                                          : appCtrl.appTheme.primary
                                              .withOpacity(0.2),
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(AppRadius.r10),
                                      ),
                                      border: Border.all(
                                        color: appCtrl.appTheme.txt,
                                      ),
                                    )
                                    .paddingSymmetric(
                                      horizontal: Insets.i3,
                                    ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            OnBoardBottomButtonLayout(
              onTap: onTap,
            ),
          ],
        );
      },
    );
  }
}
