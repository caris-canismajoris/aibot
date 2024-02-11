import 'package:flutter/services.dart';
import '../../../config.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return true;
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/backgroundwp/bgwp6.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Opacity(
                opacity:  0.85,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // const LoginImageLayout(),
                  // const VSpace(Sizes.s20),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 22,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(
                          22,
                        ),
                      ),
                      width: double.infinity,
                      child: const LoginBody()
                          .paddingSymmetric(horizontal: Insets.i20),
                    ),
                  ),
                ],
              ).paddingOnly(
                bottom: Insets.i10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
