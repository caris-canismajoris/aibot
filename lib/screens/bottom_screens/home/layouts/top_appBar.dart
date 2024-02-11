import 'package:lottie/lottie.dart';

import '../../../../config.dart';

class HomeTopAppBarLayout extends StatelessWidget {
  final GestureTapCallback? onTap;
  final settingCtrl = Get.put(SettingController());
   HomeTopAppBarLayout({Key? key, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Container(
        //   width: MediaQuery.of(context).size.width,
        //   padding: const EdgeInsets.only(top: Insets.i80),
        //   decoration: BoxDecoration(
        //     gradient: RadialGradient(
        //       focalRadius: 1,
        //       radius: 1,
        //       center: const Alignment(-0.1, 0.1),
        //       colors: [
        //         appCtrl.appTheme.primaryLight1, //  primary,
        //         appCtrl.appTheme.radialGradient,
        //       ],
        //     ),
        //   ),
        //   child: Lottie.asset(
        //     'assets/lottie/ai.json',
        //     frameRate: FrameRate(10),

        //     // repeat: false,
        //   )
        //       // Image.asset(eImageAssets.homeAppBar, height: Sizes.s170)
        //       .paddingSymmetric(
        //     vertical: Insets.i20,
        //     horizontal: Insets.i35,
        //   ),
        // ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                // const CommonMenuIcon().inkWell(onTap: onTap),
                Column(
                  // mainAxisAlignment: ,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Hi,",
                        style: const TextStyle(
                            fontSize: Sizes.s18, fontWeight: FontWeight.w400)),
                    Text(
                      settingCtrl.userName ?? "Welcome to ChatBot",
                      style: AppCss.outfitSemiBold18 //Medium14
                          .textColor(appCtrl.appTheme.black), //txt),
                    ),
                  ],
                ).paddingOnly(
                  left: 12,
                ),

                // CachedNetworkImage(
                //   imageUrl: appCtrl.firebaseConfigModel!.homeLogo.toString(),
                //   width: Sizes.s106,
                //   imageBuilder: (context, imageProvider) => SizedBox(
                //       width: Sizes.s106,
                //       child: Column(children: [
                //         Image.network(
                //             appCtrl.firebaseConfigModel!.homeLogo.toString(),
                //             width: Sizes.s106,
                //             fit: BoxFit.fill)
                //       ])),
                //   placeholder: (context, url) =>
                //       const CircularProgressIndicator(),
                //   errorWidget: (context, url, error) => const Text(
                //     "", //"Cakaps",
                //     style: TextStyle(
                //       fontSize: 24,
                //       fontWeight: FontWeight.w800,
                //     ),
                //   ),
                //   // Image.asset(eImageAssets.logo1, width: Sizes.s106,),
                // ),
              ],
            ),
            const CommonBalance().marginSymmetric(horizontal: Insets.i20)
          ],
        ).paddingSymmetric(vertical: Insets.i25)
      ],
    );
  }
}
