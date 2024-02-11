import '../../../config.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final signUpCtrl = Get.put(SignUpController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SignUpController>(
      builder: (_) {
        return Scaffold(
          key: scaffoldKey,
          backgroundColor: Colors.transparent,
          // appBar: const AppBarCommon(isArrow: false),
          body: Stack(
            alignment: Alignment.center,
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
                opacity:  0.75,
                child: ListView(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const VSpace(Sizes.s5),
                        SizedBox(
                          width: double.infinity,
                          child: Form(
                            key: signUpCtrl.signUpGlobalKey,
                            child: const SignUpField(),
                          ),
                        ).authBoxExtension(),
                        // textCommon.simplyUseTextAuth(),
                      ],
                    ).paddingSymmetric(horizontal: Insets.i20, vertical: Insets.i15),
                  ],
                ),
              ),
              if (signUpCtrl.isLoading == true)
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
