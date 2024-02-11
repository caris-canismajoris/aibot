import 'package:aibot/config.dart';

import '../../app_screens/essay_writer_screen/temp_essay/temp_essay_screen.dart';
import '../../app_screens/password_generator_screen/temp_pass_gen/temp_pass_gen_screen.dart';
import 'layouts/top_appBar.dart';

class Home extends StatelessWidget {
  final homeCtrl = Get.put(HomeController());

  Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      builder: (_) {
        appCtrl.commonThemeChange();
        return CommonStream(
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            key: homeCtrl.scaffoldKey,
            drawer: const CommonDrawer(),
            body: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/backgroundwp/bgwp4.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                ListView(
                  children: [
                    HomeTopAppBarLayout(
                        onTap: () =>
                            homeCtrl.scaffoldKey.currentState!.openDrawer()),
                    // const DottedLines(),
                    // Expanded(
                    //   child: 
                      // ClipRRect(
                      //   borderRadius: BorderRadius.circular(22),
                        // only(
                        //   bottomLeft: Radius.circular(20),
                        //   bottomRight: Radius.circular(20),
                        // ),

                        // borderRadius: BorderRadius.circular(20),
                        // child: 
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 6),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(22),
                            
                            // only(
                            //   bottomLeft: Radius.circular(20),
                            //   bottomRight: Radius.circular(20),
                            // ),
                          ),
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const QuickViewAllLayout(),
                                // const SizedBox(
                                //   height: Sizes.s12,
                                // ),
                                StreamBuilder(
                                  stream: FirebaseFirestore.instance
                                      .collection("categoryAccess")
                                      .snapshots(),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      appCtrl.categoryAccessModel =
                                          CategoryAccessModel.fromJson(
                                              snapshot.data!.docs[0].data());
                                      appCtrl.storage.write(
                                          session.categoryConfig,
                                          appCtrl.categoryAccessModel);
                                      homeCtrl.getQuickData();
                                      homeCtrl.getFavData();
                                      return GetBuilder<QuickAdvisorController>(
                                        builder: (quickCtrl) {
                                          return quickCtrl
                                                  .favoriteDataList.isNotEmpty
                                              ? const FavoriteList()
                                              : const 
                                              // QuickAdvisorListCommon();
                                              HomeQuickAdviceList();
                                        },
                                      );
                                    } else {
                                      return Container();
                                    }
                                  },
                                ),
                                const VSpace(Sizes.s70),
                              ],
                            )
                                .marginSymmetric(
                                  horizontal: Sizes.s23,
                                )
                                .backgroundColor(
                                  appCtrl.appTheme.txt.withOpacity(0.1),
                                )
                                .border(
                                  color: Colors.white,
                                  all: 2,
                                ),
                          ),
                        ),
                      // ),
                    // )
                    // .marginSymmetric(horizontal: Sizes.s10),
                  ],
                ),
                // AdCommonLayout(
                //     bannerAdIsLoaded: homeCtrl.bannerAdIsLoaded,
                //     // bannerAd: homeCtrl.bannerAd,
                //     currentAd: homeCtrl.currentAd),
              ],
            ),
            // backgroundColor: appCtrl.appTheme.bg1,
            // floatingActionButton: FloatingActionButton(
            //   onPressed: () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //         builder: (context) =>
            //             EssayWriterScreen(), //TempEmailGeneratorScreen() ,//ChatBotScreen(),
            //       ),
            //     );
            //   },
            // ),
          ),
        );
      },
    );
  }
}
