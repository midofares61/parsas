import 'package:carousel_slider/carousel_slider.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../cubit/cubit_app.dart';
import '../../cubit/state_app.dart';
import '../../shared/components/components.dart';
import '../../shared/styles/colors.dart';
import '../show_card/show_card_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String filter="العروض";
  @override
  Widget build(BuildContext context) {
    Future<void> launcherUrl(url) async {
      if (!await launchUrl(url)) {
        throw Exception('Could not launch $url');
      }
    }
    final isDesktop = MediaQuery.of(context).size.width >= 500;
    return BlocConsumer<CubitApp, StateApp>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = CubitApp.get(context);
          final isDesktop = MediaQuery.of(context).size.width >= 500;
          return Directionality(
            textDirection: TextDirection.ltr,
            child: Scaffold(
              appBar: AppBar(
                title: Text("Parsas"),
                actions: [
                  IconButton(onPressed: (){

                  }, icon: Icon(Icons.shopping_cart_outlined)),
                  SizedBox(width: 10,),
                ],
              ),
              body: SingleChildScrollView(
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
                                      "https://sintac.shop/images/gaber.webp"),
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
                                      "https://sintac.shop/images/food/214.webp"),
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
                                      "https://sintac.shop/images/food/218.webp"),
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
                                      "https://sintac.shop/images/food/222.webp"),
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
                        Container(
                          height: 45,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemBuilder: (context, index) => Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    filter = cubit.section![index]["name"];
                                  });
                                },
                                child: Container(
                                    decoration: BoxDecoration(
                                        color:cubit.section![index]["name"]==filter? defaultColor:Colors.white,
                                        borderRadius: BorderRadius.circular(15),
                                        boxShadow: [
                                          BoxShadow(
                                              color: Colors.grey,
                                              offset: Offset(0, 0),
                                              blurRadius: 5)
                                        ]),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 5),
                                    child:
                                        Text("${cubit.section![index]["name"]}",style: TextStyle(color: cubit.section![index]["name"]==filter? Colors.white:Colors.black),)),
                              ),
                            ),
                            separatorBuilder: (context, index) => SizedBox(
                              width: 5,
                            ),
                            itemCount: cubit.section!.length,
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
                            filter == null || entry.value["section_name"] == filter)
                                .map((entry) {
                              final index = entry.key;
                              final item = entry.value;

                              return InkWell(
                                onTap: () {
                                  // showDialog(
                                  //     context: context,
                                  //     builder: (context) {
                                  //       return DialogWidget(
                                  //         padButtom: 10,
                                  //         padLeft: 10,
                                  //         padReight: 10,
                                  //         padTop: 10,
                                  //         radius: 5,
                                  //         dialogContent: Column(
                                  //           children: [
                                  //             Row(
                                  //               children: [
                                  //                 InkWell(
                                  //                   onTap: () {
                                  //                     Navigator.pop(context);
                                  //                   },
                                  //                   child: Icon(Icons.close),
                                  //                 ),
                                  //                 Spacer(),
                                  //                 Text(
                                  //                   "اضافة الي الطلبات",
                                  //                   style: TextStyle(
                                  //                       color: Colors.black),
                                  //                 )
                                  //               ],
                                  //             ),
                                  //             Container(
                                  //               width: double.infinity,
                                  //               height: 1,
                                  //               color: Colors.grey,
                                  //             ),
                                  //           ],
                                  //         ),
                                  //       );
                                  //     });
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
                      Center(child: CircularProgressIndicator()),
                ),
              ),
            ),
          );
        });
  }
}

class DialogWidget extends StatelessWidget {
  Widget dialogContent;
  double? radius;
  double? padTop;
  double? padReight;
  double? padLeft;
  double? padButtom;

  DialogWidget({
    required this.dialogContent,
    this.radius,
    this.padTop,
    this.padReight,
    this.padLeft,
    this.padButtom,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentTextStyle: TextStyle(),
      contentPadding: EdgeInsets.only(
        right: padReight != null ? padReight! : 20,
        left: padLeft != null ? padLeft! : 20,
        top: padTop != null ? padTop! : 20,
        bottom: padButtom != null ? padButtom! : 20,
      ),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(5),
        ),
      ),
      scrollable: true,
      elevation: 0.0,
      content: dialogContent,
    );
  }
}
