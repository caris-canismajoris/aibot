import '../../../../config.dart';

class ChatScreenAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Color? backgroundColor;
  final Widget? leading;

  const ChatScreenAppBar({
    Key? key,
    this.backgroundColor,
    this.leading,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChatLayoutController>(
      builder: (chatCtrl) {
        return AppBar(
          toolbarHeight: 70,
          titleSpacing: 0,
          leading: leading ??
              SvgPicture.asset(eSvgAssets.leftArrow,
                      fit: BoxFit.scaleDown,
                      colorFilter: ColorFilter.mode(
                          appCtrl.appTheme.sameWhite, BlendMode.srcIn))
                  .inkWell(onTap: () {
                Get.back();
                chatCtrl.clearData();
              }),
          automaticallyImplyLeading: false,
          backgroundColor: backgroundColor ?? appCtrl.appTheme.primary,
          actions: [
            chatCtrl.isLongPress
                ? Row(
                    children: [
                      chatCtrl.selectedIndex.length > 1
                          ? Container()
                          : ChatCommonWidget()
                              .commonSvgIcon(eSvgAssets.rotate)
                              .inkWell(
                                onTap: () => chatCtrl.onTapRegenerateResponse(),
                              ),
                      const HSpace(Sizes.s17),
                      ChatCommonWidget().commonSvgIcon(eSvgAssets.copy).inkWell(
                            onTap: () => chatCtrl.onTapCopy(),
                          ),
                      const HSpace(Sizes.s17),
                      ChatCommonWidget()
                          .commonSvgIcon(eSvgAssets.share)
                          .inkWell(
                            onTap: () => chatCtrl.onTapShare(),
                          ),
                      const HSpace(Sizes.s17),
                    ],
                  )
                : const Row(
                    children: [
                      CommonBalance(),
                      SizedBox(
                        width: 12,
                      )
                      // MoreOption(),
                    ],
                  ),
          ],
          title: chatCtrl.isLongPress
              ? Text("${chatCtrl.selectedIndex.length} selected",
                  style: AppCss.outfitExtraBold22
                      .textColor(appCtrl.appTheme.sameWhite))
              : Row(
                  children: [
                    const CachedNetworkImageLayout(),
                    const HSpace(Sizes.s10),
                    Text(
                      appCtrl.selectedCharacter["title"].toString().tr,
                      style: AppCss.outfitExtraBold22
                          .textColor(appCtrl.appTheme.sameWhite),
                    ),
                  ],
                ),
        ).inkWell(
          onTap: () => chatCtrl.onTapRemoveSelectedList(),
        );
      },
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
