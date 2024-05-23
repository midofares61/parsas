import 'dart:async';
import 'dart:math';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:confetti/confetti.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:parsas2/modules/shopping/shopping_screen.dart';
import 'package:parsas2/shared/network/local/chach_helper.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';
import '../cubit/cubit_app.dart';
import '../cubit/state_app.dart';
import '../modules/show_card/show_card_screen.dart';
import '../shared/components/components.dart';
import '../shared/styles/colors.dart';

class HomeLayout extends StatefulWidget {
  HomeLayout({super.key});

  @override
  State<HomeLayout> createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> {
  Future<void> launcherUrl(url) async {
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }
  final controller=ConfettiController();
  final PageStorageBucket bucket = PageStorageBucket();
  late StreamSubscription subscription;
  var isDeviceConnected = false;
  bool isAlertSet = false;
  bool offer = false;
  bool isPlaying = false;
  String? filter="افطار";
  String filterSection="طعام";
  int? numOffer;
  late List filteredSections;
  @override
  void initState() {
    getConnectivity();
    super.initState();
  }

  getConnectivity() =>
      subscription = Connectivity().onConnectivityChanged.listen(
        (ConnectivityResult result) async {
          isDeviceConnected = await InternetConnectionChecker().hasConnection;
          if (!isDeviceConnected && isAlertSet == false) {
            showDialoBox();
            setState(() => isAlertSet = true);
          }
        },
      );
  @override
  void dispose() {
    subscription.cancel();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CubitApp, StateApp>(
      listener: (context, state) {
        if(state is GetSectionSuccessful){
           filteredSections = CubitApp.get(context).section!.where((section) => section["section_name"] == filterSection).toList();
        }
        if(state is GetOfferSuccessful&& CacheHelper.getData(key: "offer")==null){
          setState(() {
            offer=CubitApp.get(context).offer!;
            controller.play();
            Future.delayed(const Duration(seconds: 2)).then((value) => {
              controller.stop()
            }
              );
            Random random = Random();
            numOffer= random.nextInt(10) + 1;
            CacheHelper.SaveData(key: "offer", value: numOffer);
          });
        }
      },
      builder: (context, state) {
        var cubit = CubitApp.get(context);
        final isDesktop = MediaQuery.of(context).size.width >= 500;
        return Directionality(
          textDirection: TextDirection.ltr,
          child: Scaffold(
            appBar: AppBar(
              title: Text("Parsas"),
              actions: [
                InkWell(
                  onTap: () {
                    Share.share(
                        "مرحبا صديقي 👋 قم بتحميل تطبيق parsas من خلال هذا الرابط Gaber.sintac.site/app.apk لتستفيد بأفضل العروض والخصومات علي اشهي الاكلات ");
                    if(CacheHelper.getData(key: "offer")==null || CacheHelper.getData(key: "offer")<=25){
                      Random random = Random();
                      numOffer= random.nextInt(5) + 1;
                      if(CacheHelper.getData(key: "offer")==null){
                        CacheHelper.SaveData(key: "offer", value: numOffer!);
                      }else{
                        int offer=CacheHelper.getData(key: "offer");
                        if((offer+numOffer!)>15){
                          CacheHelper.SaveData(key: "offer", value: 15);
                        }else{
                          CacheHelper.SaveData(key: "offer", value: offer+numOffer!);
                        }

                      }
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.pinkAccent.shade100.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(10)
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 15,vertical:10),
                    child: Row(
                      children: [
                        Text(
                          "مشاركة التطبيق",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(width: 5,),
                        Icon(
                          Icons.share,
                          color:  Colors.black,
                          size: 18,
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 5,),
                Stack(
                  children: [
                    IconButton(onPressed: (){
                      navigateTo(context: context, widget: ShoppingScreen());
                    }, icon: Icon(Icons.shopping_cart_outlined)),
                    if(cubit.carts.length!=0)
                      Container(
                        decoration: BoxDecoration(
                            color: defaultColor,
                            borderRadius: BorderRadius.circular(50)
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 6,vertical: 1),
                        child: Text("${cubit.carts.length}",style: TextStyle(color: Colors.white,fontSize: 12),),
                      )
                  ],
                ),
                SizedBox(width: 10,),
              ],
            ),
            body: Directionality(
              textDirection: TextDirection.rtl,
              child: Stack(
                children: [
                  SingleChildScrollView(
                    child: ConditionalBuilder(
                      condition: cubit.section != null && cubit.items != null,
                      builder: (context) => Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10)),
                              clipBehavior: Clip.antiAlias,
                              child: CarouselSlider(
                                items: [
                                  Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10)),
                                    clipBehavior: Clip.antiAlias,
                                    child: Image(
                                      image: NetworkImage(
                                          "https://sintac.shop/images/food-parsas/50.webp"),
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10)),
                                    clipBehavior: Clip.antiAlias,
                                    child: Image(
                                      image: NetworkImage(
                                          "https://sintac.shop/images/drink-parsas/57.webp"),
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10)),
                                    clipBehavior: Clip.antiAlias,
                                    child: Image(
                                      image: NetworkImage(
                                          "https://sintac.shop/images/food-parsas/31.webp"),
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10)),
                                    clipBehavior: Clip.antiAlias,
                                    child: Image(
                                      image: NetworkImage(
                                          "https://sintac.shop/images/drink-parsas/60.webp"),
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ],
                                options: CarouselOptions(
                                  height: 200,
                                  autoPlay: true,
                                  autoPlayAnimationDuration: Duration(seconds: 1),
                                  autoPlayInterval: Duration(seconds: 3),
                                  initialPage: 0,
                                  reverse: false,
                                  enableInfiniteScroll: true,
                                  autoPlayCurve: Curves.fastOutSlowIn,
                                  viewportFraction: 1.0,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            if(filter!=null)
                            Container(
                              height: 65,
                              child: ListView.separated(
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  final section = filteredSections[index];
                                  return Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          filter = section["name"];
                                        });
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                            border: Border(bottom: BorderSide(color: section["name"] == filter ? defaultColor : Colors.white, width: 3))
                                        ),
                                        padding: EdgeInsets.symmetric(horizontal: 10),
                                        child: Column(
                                          children: [
                                            Image.network(
                                              "https://Parsas.sintac.shop/${section["img"]}",
                                              width: 20,
                                              height: 20,
                                            ),
                                            Text(
                                              "${section["name"]}",
                                              style: TextStyle(color: Colors.black),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                separatorBuilder: (context, index) => SizedBox(width: 5),
                                itemCount: filteredSections.length, // تحديد عدد العناصر
                              ),
                            ),
                            GridView.count(
                                padding: EdgeInsets.all(10),
                                crossAxisCount: isDesktop ? 3 : 2,
                                shrinkWrap: true,
                                mainAxisSpacing: isDesktop ? 20 : 10,
                                crossAxisSpacing: isDesktop ? 20 : 10,
                                childAspectRatio: 1 / 1.20,
                                physics: BouncingScrollPhysics(),
                                children:  cubit.items!
                                    .asMap()
                                    .entries
                                    .where((entry) =>
                                (filter == null ? true : entry.value["section_name_to"] == filter) &&
                                    entry.value["section_name"] == filterSection)
                                    .map((entry) {
                                  final index = entry.key;
                                  final item = entry.value;

                                  return InkWell(
                                    onTap: () {
                                      navigateTo(context: context, widget: ShowCardScreen(card: cubit.items![index], index: index,));
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          boxShadow: [
                                            BoxShadow(
                                                color: Colors.grey, blurRadius: 2),
                                          ],
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(10)),
                                      padding: EdgeInsets.all(5),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Stack(
                                            alignment: AlignmentDirectional.bottomEnd,
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                    BorderRadius.circular(10)),
                                                clipBehavior: Clip.antiAlias,
                                                child: Hero(
                                                  tag: "image-$index",
                                                  child: Image(
                                                    image: NetworkImage(
                                                        "${cubit.items![index]["image"]}"),
                                                    fit: BoxFit.cover,
                                                    height: 120,
                                                    width: double.infinity,
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.all(5.0),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      color: Colors.white
                                                          .withOpacity(0.7),
                                                      borderRadius:
                                                      BorderRadius.circular(50)),
                                                  padding: EdgeInsets.all(5),
                                                  child: Icon(
                                                    Icons.shopping_cart_outlined,
                                                    size: 20,
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Align(
                                            alignment: AlignmentDirectional.topStart,
                                            child: Text(
                                              "${cubit.items![index]["title"]}",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          Spacer(),
                                          Align(
                                            alignment: AlignmentDirectional.topEnd,
                                            child: Text(
                                              "${cubit.items![index]["price1"]} EGP",
                                              style: TextStyle(
                                                  color: defaultColor,
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }).toList())
                          ],
                        ),
                      ),
                      fallback: (context) =>
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              children: [
                            Shimmer.fromColors(
                            baseColor: Colors.grey.shade300, highlightColor: Colors.grey.shade100,
                                  child: Container(
                                    width: double.infinity,
                                    height: 200,
                                    decoration: BoxDecoration(
                                            color: Colors.grey,
                                        borderRadius: BorderRadius.circular(10)),
                                    clipBehavior: Clip.antiAlias,
                                    ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                  Container(
                                    height: 65,
                                    child: ListView.separated(
                                      scrollDirection: Axis.horizontal,
                                      shrinkWrap: true,
                                      itemBuilder: (context, index) {
                                        return Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: Container(
                                            padding: EdgeInsets.symmetric(horizontal: 10),
                                            child: Column(
                                              children: [
                                            Shimmer.fromColors(
                                            baseColor: Colors.grey.shade300, highlightColor: Colors.grey.shade100,
                                              child: CircleAvatar(
                                                radius: 20,
                                              ),
                                            ),
                                            SizedBox(height: 5,),
                                            Shimmer.fromColors(
                                              baseColor: Colors.grey.shade300, highlightColor: Colors.grey.shade100,
                                                  child: Container(
                                                    width: 35,
                                                    height: 10,
                                                    decoration: BoxDecoration(color: Colors.grey,

                                                      borderRadius: BorderRadius.circular(15)
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                      separatorBuilder: (context, index) => SizedBox(width: 5),
                                      itemCount: 5, // تحديد عدد العناصر
                                    ),
                                  ),
                                GridView.count(
                                    padding: EdgeInsets.all(10),
                                    crossAxisCount: isDesktop ? 3 : 2,
                                    shrinkWrap: true,
                                    mainAxisSpacing: isDesktop ? 20 : 10,
                                    crossAxisSpacing: isDesktop ? 20 : 10,
                                    childAspectRatio: 1 / 1.10,
                                    physics: BouncingScrollPhysics(),
                                    children:  List.generate(
        5,
        (index) => InkWell(
                                        onTap: () {
                                          navigateTo(context: context, widget: ShowCardScreen(card: cubit.items![index], index: index,));
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                              boxShadow: [
                                                BoxShadow(
                                                    color: Colors.grey, blurRadius: 2),
                                              ],
                                              color: Colors.white,
                                              borderRadius: BorderRadius.circular(10)),
                                          padding: EdgeInsets.all(5),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              Stack(
                                                alignment: AlignmentDirectional.bottomEnd,
                                                children: [
                                                  Container(
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                        BorderRadius.circular(10)),
                                                    clipBehavior: Clip.antiAlias,
                                                    child:  Shimmer.fromColors(
                                                        baseColor: Colors.grey.shade300, highlightColor: Colors.grey.shade100,
                                                      child: Container(
                                                        width: double.infinity,
                                                        height: 120,
                                                        decoration: BoxDecoration(
                                                          color: Colors.grey,
                                                        ),
                                                      ),
                                                    )
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.all(5.0),
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                          color: Colors.white
                                                              .withOpacity(0.7),
                                                          borderRadius:
                                                          BorderRadius.circular(50)),
                                                      padding: EdgeInsets.all(5),
                                                      child: Icon(
                                                        Icons.shopping_cart_outlined,
                                                        size: 20,
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Align(
                                                alignment: AlignmentDirectional.topStart,
                                                child:  Shimmer.fromColors(
                                                  baseColor: Colors.grey.shade300, highlightColor: Colors.grey.shade100,
                                                  child: Container(
                                                    width: 60,
                                                    height: 15,
                                                    decoration: BoxDecoration(
                                                      color: Colors.grey,
                                                      borderRadius: BorderRadius.circular(15)
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Spacer(),
                                              Align(
                                                alignment: AlignmentDirectional.topEnd,
                                                child: Shimmer.fromColors(
                                                  baseColor: Colors.grey.shade300, highlightColor: Colors.grey.shade100,
                                                  child: Container(
                                                    width: 60,
                                                    height: 15,
                                                    decoration: BoxDecoration(
                                                        color: Colors.grey,
                                                        borderRadius: BorderRadius.circular(15)
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                    )))
                              ],
                            ),
                          ),
                    ),
                  ),
                  if(offer)
                  InkWell(
                    onTap: (){
                      setState(() {
                        offer=false;
                      });
                    },
                    child: Container(
                      width: double.infinity,
                      height: double.infinity,
                      child: Stack(
                        alignment: AlignmentDirectional.topCenter,
                        children: [
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 30.0),
                              child: Stack(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.deepOrange,
                                      borderRadius: BorderRadius.circular(10)
                                    ),
                                    padding: EdgeInsets.symmetric(vertical: 20,horizontal: 25),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text("مبروك لقد حصلت علي خصم",style: TextStyle(fontSize: 35,fontWeight: FontWeight.bold,color: Colors.white),textAlign: TextAlign.center,),
                                        SizedBox(height: 5,),
                                        Text("$numOffer%",style: TextStyle(fontSize: 45,fontWeight: FontWeight.bold,color: Colors.white),textAlign: TextAlign.center,),
                                        SizedBox(height: 5,),
                                        Text("شارك التطبيق واحصل علي المزيد",style: TextStyle(fontSize: 35,fontWeight: FontWeight.bold,color: Colors.white),textAlign: TextAlign.center,),
                                      ],
                                    ),
                                  ),
                                  IconButton(onPressed: (){
                                    setState(() {
                                      offer=false;
                                    });
                                  }, icon: Icon(Icons.close,color: Colors.white,size: 30,))
                                ],
                              ),
                            ),
                          ),
                          ConfettiWidget(
                            confettiController: controller,
                            shouldLoop: true,
                            blastDirection: pi/2,
                            blastDirectionality: BlastDirectionality.explosive,
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            bottomNavigationBar: BottomAppBar(
              child: Container(
                height: 60,
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                          child:InkWell(
                            onTap: (){
                              setState(() {
                                filterSection="طعام";
                                filteredSections = CubitApp.get(context).section!.where((section) => section["section_name"] == filterSection).toList();
                                Map<String, dynamic>? firstItemInSectionFood = cubit.section!.firstWhere((item) => item['section_name'] == 'طعام', orElse: () => null);
                                if(firstItemInSectionFood!["name"]!=null){
                                  filter=firstItemInSectionFood["name"];
                                }else{
                                  filter=null;
                                }
                              });
                            },
                            child: Column(
                              children: [
                                Image.asset("assets/images/food.webp",width: 30,height: 30,),
                                SizedBox(height: 5,),
                                Text("طعام")
                              ],
                            ),
                          )
                      ),
                      Expanded(
                          child:InkWell(
                            onTap: (){
                              setState(() {
                                filterSection="ديلوكس";
                                filteredSections = CubitApp.get(context).section!.where((section) => section["section_name"] == filterSection).toList();
                                Map<String, dynamic>? firstItemInSectionFood = cubit.section!.firstWhere((item) => item['section_name'] == 'ديلوكس', orElse: () => null);
                                if(firstItemInSectionFood!=null){
                                  filter=firstItemInSectionFood["name"];
                                }else{
                                  filter=null;
                                }
                              });
                            },
                            child: Column(
                              children: [
                                Image.asset("assets/images/dilox.webp",width: 30,height: 30,),
                                SizedBox(height: 5,),
                                Text("ديلوكس")
                              ],
                            ),
                          )
                      ),
                      Expanded(
                          child:InkWell(
                            onTap: (){
                              setState(() {
                                filterSection="مشروبات";
                                filteredSections = CubitApp.get(context).section!.where((section) => section["section_name"] == filterSection).toList();
                                Map<String, dynamic>? firstItemInSectionFood = cubit.section!.firstWhere((item) => item['section_name'] == 'مشروبات', orElse: () => null);
                                if(firstItemInSectionFood!=null){
                                  filter=firstItemInSectionFood["name"];
                                }else{
                                  filter=null;
                                }
                              });
                            },
                            child: Column(
                              children: [
                                Image.asset("assets/images/drink.webp",width: 30,height: 30,),
                                SizedBox(height: 5,),
                                Text("مشروبات")
                              ],
                            ),
                          )
                      ),
                      Expanded(
                          child:InkWell(
                            onTap: (){
                              setState(() {
                                filterSection="حلويات";
                                filteredSections = CubitApp.get(context).section!.where((section) => section["section_name"] == filterSection).toList();
                                Map<String, dynamic>? firstItemInSectionFood = cubit.section!.firstWhere((item) => item['section_name'] == 'حلويات', orElse: () => null);
                                if(firstItemInSectionFood!=null){
                                  filter=firstItemInSectionFood["name"];
                                }else{
                                  filter=null;
                                }
                              });
                            },
                            child: Column(
                              children: [
                                Image.asset("assets/images/cupcake.webp",width: 30,height: 30,),
                                SizedBox(height: 5,),
                                Text("حلويات")
                              ],
                            ),
                          )
                      ),
                      Expanded(
                          child:InkWell(
                            onTap: (){
                              setState(() {
                                filterSection="عروض";
                                filteredSections = CubitApp.get(context).section!.where((section) => section["section_name"] == filterSection).toList();
                                Map<String, dynamic>? firstItemInSectionFood = cubit.section!.firstWhere((item) => item['section_name'] == 'عروض', orElse: () => null);
                                if(firstItemInSectionFood!=null){
                                  filter=firstItemInSectionFood["name"];
                                }else{
                                  filter=null;
                                }

                              });
                            },
                            child: Column(
                              children: [
                                Image.asset("assets/images/offers.webp",width: 30,height: 30,),
                                SizedBox(height: 5,),
                                Text("عروض")
                              ],
                            ),
                          )
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  showDialoBox() => showCupertinoDialog<String>(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: const Text("لا يوجد اتصال بالانترنت"),
          content: const Text("من فضلك قم بالتحقق من اتصالك بالانترنت"),
          actions: <Widget>[
            TextButton(
                onPressed: () async {
                  Navigator.pop(context, 'cancel');
                  setState(() => isAlertSet = false);
                  isDeviceConnected =
                      await InternetConnectionChecker().hasConnection;
                  if (!isDeviceConnected) {
                    showDialoBox();
                    setState(() => isAlertSet = true);
                  }
                },
                child: const Text("OK"))
          ],
        ),
      );
}


              // bottomNavigationBar: BottomNavigationBar(
              //   backgroundColor: defaultColor,
              //   selectedItemColor: Colors.black,
              //   unselectedItemColor: Colors.grey,
              //   onTap: (value) {
              //     cubit.changeindex(value);
              //   },
              //   currentIndex: cubit.currentIndex,
              //   items: cubit.bottomItem,
              // ),