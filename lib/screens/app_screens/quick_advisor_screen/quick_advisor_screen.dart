import '../../../config.dart';
import '../../../widgets/app_bar_common_txt_transparant.dart';

class QuickAdvisorScreen extends StatelessWidget {
  final quickAdvisorCtrl = Get.put(QuickAdvisorController());

  QuickAdvisorScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<QuickAdvisorController>(
      builder: (quickAdvisorCtrl) {
        return DirectionalityRtl(
          child: Scaffold(
            // appBar: AppAppBarCommon(
            //     title: appFonts.quickAdvice, leadingOnTap: () => Get.back()),
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
                ListView(
                  children: [
                    AppAppBarCommonTxtTr(
                      title: appFonts.quickAdvice,
                      leadingOnTap: () => Get.back(),
                    ).paddingOnly(top: 22,).paddingSymmetric(horizontal: 12,),
                    SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection("categoryAccess")
                            .snapshots(),
                        builder: (context, snapShot) {
                          if (snapShot.hasData) {
                            appCtrl.categoryAccessModel =
                                CategoryAccessModel.fromJson(
                                    snapShot.data!.docs[0].data());
                            appCtrl.storage.write(session.categoryConfig,
                                appCtrl.categoryAccessModel);
                            quickAdvisorCtrl.getQuickData();
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                quickAdvisorCtrl.favoriteDataList.isNotEmpty
                                    ? Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            appFonts.favoriteQuickAdvisor.tr,
                                            style: AppCss.outfitSemiBold16
                                                .textColor(
                                                    appCtrl.appTheme.txt),
                                          ).paddingOnly(bottom: Insets.i15),
                                          const FavoriteList(),
                                        ],
                                      ).paddingOnly(bottom: Insets.i30)
                                    : Container(),
                                const QuickAdvisorListCommon(),
                              ],
                            ).paddingAll(Insets.i20);
                          } else {
                            return Container();
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
