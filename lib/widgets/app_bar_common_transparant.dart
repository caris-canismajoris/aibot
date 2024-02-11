import '../config.dart';

class AppAppBarCommonTr extends StatelessWidget implements PreferredSizeWidget {
  final GestureTapCallback? actionOnTap, leadingOnTap;
  final String? title, actionIcon;
  final bool isAction, isBalanceShow;

  const AppAppBarCommonTr(
      {Key? key,
      this.title,
      this.actionOnTap,
      this.actionIcon,
      this.leadingOnTap,
      this.isAction = false,
      this.isBalanceShow = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChatLayoutController>(builder: (chatCtrl) {
      return Stack(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  // SizedBox(
                  //   height: 15,
                  //   width: 15,
                  //   child: SvgPicture.asset(
                  //           appCtrl.isRTL || appCtrl.languageVal == "ar"
                  //               ? eSvgAssets.rightArrow1
                  //               : eSvgAssets.leftArrow,
                  //           height: 10,
                  //           colorFilter: ColorFilter.mode(
                  //               appCtrl.appTheme.sameWhite, BlendMode.srcIn))
                  //       .inkWell(onTap: leadingOnTap),
                  // ),
                  const HSpace(Sizes.s34),
                  SizedBox(
                    child: chatCtrl.isLongPress
                        ? Text("${chatCtrl.selectedIndex.length} selected",
                            style: AppCss.outfitExtraBold22
                                .textColor(appCtrl.appTheme.sameWhite))
                        : Row(
                            children: [
                              const CachedNetworkImageLayout(),
                              const HSpace(Sizes.s10),
                              Text(
                                appCtrl.selectedCharacter["title"]
                                    .toString()
                                    .tr,
                                style: AppCss.outfitExtraBold22
                                    .textColor(appCtrl.appTheme.sameWhite),
                              ),
                            ],
                          ),
                  ),
                  Text(title!.tr,
                      overflow: TextOverflow.clip,
                      style: AppCss.outfitSemiBold22
                          // outfitSemiBold22
                          .textColor(appCtrl.appTheme.sameWhite))
                  // Expanded(
                  //     child: Text(title!.tr,
                  //         overflow: TextOverflow.clip,
                  //         style: AppCss.outfitblack14
                  //         // outfitSemiBold22
                  //             .textColor(appCtrl.appTheme.sameWhite))),
                ],
              ),
              const CommonBalance().marginSymmetric(horizontal: Insets.i20)
            ],
          ).paddingSymmetric(vertical: Insets.i25)
        ],
      );
    });
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

// AppBar(
//         automaticallyImplyLeading: false,
//         elevation: 0,
//         toolbarHeight: Sizes.s70,
//         backgroundColor: appCtrl.appTheme.primary,
//         actions: [
//           if (isBalanceShow)   const CommonBalance().marginOnly(right: Insets.i20,top: Insets.i10,bottom: Insets.i10),
//           if (isAction)
//             SvgPicture.asset(actionIcon!)
//                 .paddingSymmetric(horizontal: Insets.i20)
//                 .inkWell(onTap: actionOnTap)
//         ],
//         title: Row(children: [

//           SizedBox(
//             height: 15,
//             width: 15,
//             child: SvgPicture.asset(appCtrl.isRTL || appCtrl.languageVal == "ar" ? eSvgAssets.rightArrow1 : eSvgAssets.leftArrow,
//                 height: 10,
//                 colorFilter: ColorFilter.mode(
//                     appCtrl.appTheme.sameWhite,
//                     BlendMode.srcIn))

//                 .inkWell(onTap: leadingOnTap),
//           ),
//           const HSpace(Sizes.s17),
//           Expanded(
//             child: Text(title!.tr,overflow: TextOverflow.clip,
//                 style:
//                 AppCss.outfitSemiBold22.textColor(appCtrl.appTheme.sameWhite))
//           )
//         ]));
