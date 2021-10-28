import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ppadmin/src/config/constants.dart';
import 'package:ppadmin/src/config/theme_data.dart';
import 'package:ppadmin/src/routes/routes.dart';
import 'package:shared/shared.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (ctx) => AuthenticationBloc()),
        BlocProvider(create: (ctx) => ArmsRegisterBloc()),
        BlocProvider(create: (ctx) => CollectRegisterBloc()),
        BlocProvider(create: (ctx) => MovementRegisterBloc()),
        BlocProvider(create: (ctx) => WatchRegisterBloc()),
        BlocProvider(create: (ctx) => CrimeRegisterBloc()),
        BlocProvider(create: (ctx) => DeathRegisterBloc()),
        BlocProvider(create: (ctx) => FireRegisterBloc()),
        BlocProvider(create: (ctx) => MissingRegisterBloc()),
        BlocProvider(create: (ctx) => PublicPlaceRegisterBloc()),
        BlocProvider(create: (ctx) => IllegalRegisterBloc()),
        BlocProvider(create: (ctx) => AlertBloc()),
        BlocProvider(create: (ctx) => NewsBloc()),
        BlocProvider(create: (ctx) => UsersBloc()),
        BlocProvider(create: (ctx) => PoliceStationBloc()),
        BlocProvider(create: (ctx) => KayadeBloc()),
      ],
      child: MaterialApp(
          title: STR_APP_NAME,
          debugShowCheckedModeBanner: false,
          theme: myTheme,
          onGenerateRoute: routes),
    );
  }
}
