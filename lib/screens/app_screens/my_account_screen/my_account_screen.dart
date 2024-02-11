import 'package:aibot/config.dart';

import '../../../widgets/app_bar_common_txt_transparant.dart';

class MyAccountScreen extends StatelessWidget {
  final myAccountCtrl = Get.put(MyAccountController());

  MyAccountScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MyAccountController>(
      builder: (_) {
        return Scaffold(
          // appBar: AppAppBarCommon(
          //     title: appFonts.myAccount, leadingOnTap: () => Get.back()),
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
              Column(
                children: [
                  AppAppBarCommonTxtTr(
                    title: appFonts.myAccount,
                    leadingOnTap: () => Get.back(),
                  ).paddingOnly(
                    top: 26,
                  ).paddingSymmetric(horizontal: 12,),
                  StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .where('id', isEqualTo: myAccountCtrl.id)
                        .limit(1)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return SingleChildScrollView(
                          child: Column(
                            children: [
                              const VSpace(Sizes.s10),
                              UserImage(
                                      name: snapshot.data!.docs[0]
                                          .data()["email"],
                                      image: snapshot.data!.docs[0]
                                          .data()["image"],
                                      isLoading: myAccountCtrl.isLoading)
                                  .inkWell(
                                onTap: () =>
                                    myAccountCtrl.imagePickerOption(context),
                              ),
                              const VSpace(Sizes.s15),
                              Opacity(
                                opacity: 0.75,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                      22,
                                    ),
                                    border: Border.all(
                                      color: appCtrl.appTheme.txt,
                                      width: 2,
                                    ),
                                  ),
                                  child: const AllTextForm()
                                      .paddingSymmetric(
                                          horizontal: Insets.i20,
                                          vertical: Insets.i25)
                                      .authBoxExtension(),
                                ),
                              ),
                              const VSpace(Sizes.s30),
                              ButtonCommon(
                                  title: appFonts.update,
                                  onTap: () => myAccountCtrl.onUpdate()),
                              const VSpace(Sizes.s20),
                              ButtonCommon(
                                  onTap: () => myAccountCtrl.buildPopupDialog(),
                                  title: appFonts.deleteAccount)
                            ],
                          )
                              .paddingSymmetric(horizontal: Insets.i20)
                              .alignment(Alignment.center),
                        );
                      } else {
                        return Container();
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
