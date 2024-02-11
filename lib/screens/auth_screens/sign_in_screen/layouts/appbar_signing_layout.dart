import 'package:flutter/services.dart';

import '../../../../config.dart';


class AppBarSingInCommon extends StatelessWidget implements PreferredSizeWidget {
  final bool isArrow, isSystemNavigate;
  final Widget widgets;
  const AppBarSingInCommon({
    Key? key,
    required this.widgets,// = const SizedBox.shrink(),
    this.isArrow = true,
    this.isSystemNavigate = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: appCtrl.appTheme.bg1,
        elevation: 0,
        leading: isArrow
            ? SvgPicture.asset(eSvgAssets.leftArrow, fit: BoxFit.scaleDown)
                .inkWell(
                    onTap: isSystemNavigate
                        ? () => Get.back()
                        : () {
                            SystemNavigator.pop();
                          })
            : null);
    // title:
    // Image.asset(eImageAssets.proBot,
    //     height: Sizes.s38, width: Sizes.s130));
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
