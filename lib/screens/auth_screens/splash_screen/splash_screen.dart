import '../../../config.dart';

class SplashScreen extends StatelessWidget {
  final splashCtrl = Get.put(SplashController());

  var firebaseFirestore =
      FirebaseFirestore.instance.collection("config").snapshots();

  SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SplashController>(builder: (_) {
      print("firebaseFirestore ==> ${firebaseFirestore.length}");
      return StreamBuilder(
          stream: firebaseFirestore,
          builder: (context, snapShot) {
            return Scaffold(
                body: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/backgroundwp/bgwp3.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
                // SizedBox(
                //   width: double.infinity,
                //   height: double.infinity,
                //   child:
                //       // Text("bingung namainnya apa\nhehe...")
                //       Image.asset(eImageAssets.splashBg),
                // ),

                
                // .decorated(
                //     gradient: RadialGradient(
                //         focalRadius: 2,
                //         radius: 2,
                //         colors: [
                //           appCtrl.appTheme.primary.withOpacity(0.5),
                //           appCtrl.appTheme.primary
                //         ],
                //         center: const Alignment(-0.1, 0.1))),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    snapShot.hasData
                        ? Image.asset(eImageAssets.logo,
                            height: 250, width: 250)
                        // Image.network(
                        //     snapShot.data!.docs[0].data()["splashLogo"],
                        //     height: 100,
                        //     width: 100)
                        : Image.asset(eImageAssets.logo,
                            height: 250, width: 250),
                    // Text("Bingung namainnya apa",
                    //     // appFonts.proBot,
                    //     style: AppCss.londrinaMedium70
                    //         .textColor(appCtrl.appTheme.sameWhite))
                  ],
                )
              ],
            ));
          });
    });
  }
}
