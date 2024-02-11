import '../../../../config.dart';

class OnBoardBottomButtonLayout extends StatelessWidget {
  final GestureTapCallback? onTap;
  // final String? title, description;
  const OnBoardBottomButtonLayout({
    Key? key,
    // this.description,
    // this.title,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 22,
        right: 22,
        bottom: 22,
      ),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          // SizedBox(
          //   height: Sizes.s215,
          //   width: double.infinity,
          //   child: Column(
          //     mainAxisAlignment: MainAxisAlignment.start,
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     children: [
          //       Stack(
          //         alignment: Alignment.topCenter,
          //         children: [
          //           Image.asset(eImageAssets.container,
          //               color: appCtrl.isTheme
          //                   ? appCtrl.appTheme.boxBg
          //                   : appCtrl.appTheme.white,
          //               fit: BoxFit.fill,
          //               height: Sizes.s200,
          //               width: double.infinity),
          //           // Column(
          //           //   children: [
          //           //     Text(title!,
          //           //         style: AppCss.outfitMedium22
          //           //             .textColor(appCtrl.appTheme.txt)),
          //           //     const VSpace(Sizes.s5),
          //           //     Divider(
          //           //         height: 2,
          //           //         thickness: 2,
          //           //         color: appCtrl.appTheme.primary,
          //           //         endIndent: 180,
          //           //         indent: 180),
          //           //     const VSpace(Sizes.s10),
          //           //     SizedBox(
          //           //       width: Sizes.s292,
          //           //       child: Text(
          //           //         description!,
          //           //         textAlign: TextAlign.center,
          //           //         style: AppCss.outfitMedium16
          //           //             .textColor(appCtrl.appTheme.lightText)
          //           //             .textHeight(
          //           //               1.5,
          //           //             ),
          //           //       ),
          //           //     ),
          //           //   ],
          //           // ).paddingOnly(top: Insets.i30),
          //         ],
          //       ),
          //     ],
          //   ),
          // ),
          Row(
            children: [
              Flexible(
                // flex: 3,
                child: Container(
                  height: Sizes.s52,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    border: Border.all(
                      color: appCtrl.appTheme.secondary,
                    ),

                    // gradient: RadialGradient(
                    //   colors: [
                    //     appCtrl.appTheme.secondary,
                    //     appCtrl.appTheme.primary
                    //   ],
                    //   center: const Alignment(
                    //     -0.9,
                    //     -0.4,
                    //   ),
                    // ),
                    borderRadius: BorderRadius.circular(Sizes.s22),
                  ),
                  child: Center(
                    child: Text(
                      style: AppCss.outfitMedium16
                          .textColor(appCtrl.appTheme.textField),
                      "Next",
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 12,
              ),
              SizedBox(
                height: Sizes.s52,
                width: Sizes.s52,
                child: SvgPicture.asset(
                  eSvgAssets.rightArrow,
                  fit: BoxFit.scaleDown,
                ),
              )
                  // .inkWell(onTap: onTap)
                  .decorated(
                shape: BoxShape.circle,
                color: Colors.transparent,
                border: Border.all(
                  color: appCtrl.appTheme.primary,
                  width: 2,
                ),
                // gradient: RadialGradient(
                //   colors: [
                //     appCtrl.appTheme.secondary,
                //     appCtrl.appTheme.primary
                //   ],
                //   center: const Alignment(
                //     -0.9,
                //     -0.4,
                //   ),
                // ),
              ),
            ],
          ).inkWell(onTap: onTap),
        ],
      ).marginOnly(bottom: Insets.i3),
    );
  }
}
