import 'package:auto_route/auto_route.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/core/app_info/bloc/app_info_bloc.dart';
import 'package:piapiri_v2/core/app_info/bloc/app_info_event.dart';
import 'package:piapiri_v2/core/config/app_config.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/config/service_locator_manager.dart';

@RoutePage()
class EnvironmentPage extends StatelessWidget {
  const EnvironmentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Environment Page'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Image.asset(
              ImagesPath.darkPiapiriLoginLogo,
              scale: 4,
            ),
          ),
          const SizedBox(
            height: Grid.xxl,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              environmentButton(
                icon: Icons.engineering,
                text: 'Dev',
                onPressed: () {
                  getIt<AppInfoBloc>().add(
                    ChangeEnv(
                      callback: () {
                        AppConfig(
                          flavor: Flavor.dev,
                          name: 'dev',
                          contractUrl: 'https://kycdev.unluco.com/api/Contract/GetFileByte?ContractRefCode=',
                          enquraBaseUrl: 'https://kycdev.unluco.com/api',
                          baseUrl: 'https://devpiapiri.unluco.com/service3',
                          usCapraUrl: 'https://devpiapiricapra.unluco.com:7040',
                          polygonUrl: 'https://api.polygon.io',
                          polygonWssUrl: 'ws://devpiapiripoli.unluco.com:7050/stocks',
                          matriksUrl: 'https://apitest.matriksdata.com',
                          cdnKey: '62f73103-d83f-430c-a3df4ca34aad-3f05-4565',
                          memberKvkk:
                              'https://piapiri-test.b-cdn.net/KVKK%20Form/%C3%9Cnl%C3%BCCo%20-%20Piapiri%20Uygulama%20Ayd%C4%B1nlatma%20Metni(452390804.1).pdf',
                        );
                        ServiceLocatorManager.environmentReset().whenComplete(
                          () => router.pushAndPopUntil(
                            SplashRoute(),
                            predicate: (_) => false,
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
              const SizedBox(
                width: Grid.m,
              ),
              environmentButton(
                icon: Icons.precision_manufacturing,
                text: 'Prod',
                onPressed: () {
                  getIt<AppInfoBloc>().add(
                    ChangeEnv(
                      callback: () {
                        AppConfig(
                          flavor: Flavor.prod,
                          name: 'prod',
                          contractUrl: 'https://kyc.unluco.com/api/Contract/GetFileByte?ContractRefCode=',
                          enquraBaseUrl: 'https://kyc.unluco.com/api',
                          baseUrl: 'https://piapiri.unluco.com/api',
                          usCapraUrl: 'https://piapiricapra.unluco.com',
                          polygonUrl: 'https://api.polygon.io',
                          polygonWssUrl: 'ws://piapiripoli.unluco.com:7050/stocks',
                          matriksUrl: 'https://api.matriksdata.com',
                          cdnKey: '62f73103-d83f-430c-a3df4ca34aad-3f05-4565',
                          memberKvkk:
                              'https://piapiri-std.b-cdn.net/KVKK%20Form/%C3%9Cnl%C3%BCCo%20-%20Piapiri%20Uygulama%20Ayd%C4%B1nlatma%20Metni(452390804.1).pdf',
                        );
                        ServiceLocatorManager.environmentReset().whenComplete(
                          () => router.pushAndPopUntil(
                            SplashRoute(),
                            predicate: (_) => false,
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  InkWell environmentButton({
    required IconData icon,
    required String text,
    required Function() onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 4,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Colors.blue,
            width: 1,
          ),
        ),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                icon,
                size: 40,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                text,
                style: const TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
