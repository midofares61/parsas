import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parsas2/shared/components/components.dart';
import 'package:parsas2/shared/network/local/chach_helper.dart';
import 'package:parsas2/shared/network/remote/dio_helper.dart';
import 'cubit/bloc_observer.dart';
import 'cubit/cubit_app.dart';
import 'cubit/state_app.dart';
import 'layout/home_layout.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  Bloc.observer = MyBlocObserver();
  await CacheHelper.init();
  DioHelper.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => CubitApp()..getItems()..getSection()..getOffer(),
      child: BlocConsumer<CubitApp, StateApp>(
          listener: (context, state) {},
      builder: (context, state) {
      var cubit = CubitApp.get(context);
      final isDesktop = MediaQuery.of(context).size.width >= 500;
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Parsas',
        home: HomeLayout(),
      );}),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(const Duration(seconds: 5)).then((value) => {
      navigateToFinish(context: context,widget:HomeLayout())
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        color: Colors.black.withOpacity(0.9),
        child: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.white,
                                offset: Offset(0,0),
                                blurRadius: 5
                            )
                          ]
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Image(image: AssetImage("assets/images/appstore.png",),width: 100,)),
                  SizedBox(height: 30,),
                  Text("Mizo Downloader",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.white),)
                ],
              ),
            ),
            Text("Powered by Mohamed Fares",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500,color: Colors.white),),
            SizedBox(height: 20,)
          ],
        ),
      ),
    );
  }
}

