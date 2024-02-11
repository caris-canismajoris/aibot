// import '../../../config.dart';

// class SignInScreen extends StatefulWidget {
//   const SignInScreen({Key? key}) : super(key: key);

//   @override
//   State<SignInScreen> createState() => _SignInScreenState();
// }

// class _SignInScreenState extends State<SignInScreen> {
//   GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
//   final signInCtrl = Get.put(SignInController());

//   @override
//   Widget build(BuildContext context) {
//     return GetBuilder<SignInController>(
//       builder: (_) {
//         return Scaffold(
//           key: scaffoldKey,
//           backgroundColor: appCtrl.appTheme.bg1,
//           appBar: const AppBarCommon(
//             isArrow: false,
//           ),
//           body: Stack(
//             children: [
//               Container(
//                 decoration: BoxDecoration(
//                   image: DecorationImage(
//                     image: AssetImage(
//                         'assets/images/background/bg6.png'), // Sesuaikan path dengan lokasi gambar Anda
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//               ),
//               ListView(
//                 children: [
//                   const VSpace(Sizes.s5),
//                   Form(
//                     key: signInCtrl.signInGlobalKey,
//                     child: const SingleChildScrollView(
//                       child: SignInTextField(),
//                     ),
//                   ).paddingSymmetric(
//                       horizontal: Insets.i20, vertical: Insets.i15),
//                   // textCommon.simplyUseTextAuth(),
//                 ],
//               ).height(MediaQuery.of(context).size.height),
//               if (signInCtrl.isLoading == true)
//                 const Center(
//                   child: CircularProgressIndicator(),
//                 ),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }

import '../../../config.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final signInCtrl = Get.put(SignInController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SignInController>(
      builder: (_) {
        return Scaffold(
          key: scaffoldKey,
          backgroundColor:
              Colors.transparent, // Atur latar belakang menjadi transparan
          // appBar: const AppBarCommon(
          //   isArrow: false,
          // ),
          body: Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/backgroundwp/bgwp4.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Opacity(
                opacity: 0.75,
                child: Center(
                  child: ListView(
                    children: [
                      Column(
                        mainAxisAlignment:
                            MainAxisAlignment.center, // Tengahkan vertikal
                        children: [
                          const VSpace(Sizes.s5),
                          Form(
                            key: signInCtrl.signInGlobalKey,
                            child: const SingleChildScrollView(
                              child: SignInTextField(),
                            ),
                          ).paddingSymmetric(
                            horizontal: Insets.i20,
                            vertical: Insets.i15,
                          ),
                          // textCommon.simplyUseTextAuth(),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              if (signInCtrl.isLoading == true)
                const Center(
                  child: CircularProgressIndicator(),
                ),
            ],
          ),
        );
      },
    );
  }
}
