import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../cubit/cubit_app.dart';
import '../../cubit/state_app.dart';
import '../../shared/components/components.dart';
import '../../shared/network/local/chach_helper.dart';
import '../shopping_complete/shopping_complete.dart';

class ShoppingScreen extends StatefulWidget {
  const ShoppingScreen({super.key});

  @override
  State<ShoppingScreen> createState() => _ShoppingScreenState();
}

class _ShoppingScreenState extends State<ShoppingScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CubitApp, StateApp>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = CubitApp.get(context);
          final isDesktop = MediaQuery.of(context).size.width >= 500;
          return Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
                appBar: AppBar(
                  title: Text("عربة التسوق"),
                ),
                body: Column(
                  children: [
                    if(CacheHelper.getData(key: "offer")!=null)
                      Column(
                        children: [
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(vertical: 5,horizontal: 10),
                            decoration: BoxDecoration(
                              color: Colors.red,

                            ),
                            child: Text("لديك خصم ${CacheHelper.getData(key: "offer")}%",style: TextStyle(color: Colors.white),textAlign: TextAlign.center,),
                          ),
                          SizedBox(height: 10,)
                        ],
                      ),
                    Expanded(
                      child: ConditionalBuilder(
                        condition: cubit.carts.isNotEmpty,
                        builder: (context)=>Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            children: [
                              Expanded(
                                child: ListView.separated(
                                    itemBuilder: (context, index) => Container(
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(10),
                                          boxShadow: [
                                            BoxShadow(
                                                color: Colors.grey,
                                                offset: Offset(0, 0),
                                                blurRadius: 5)
                                          ]),
                                      child: Row(
                                        children: [
                                          Container(
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(5)
                                              ),
                                              clipBehavior: Clip.antiAlias,
                                              child: Image(
                                                image:
                                                NetworkImage("${cubit.carts[index].image}"),
                                                width: 100,
                                                height: 100,
                                              )),
                                          SizedBox(width: 10,),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text("الصنف : ${cubit.carts[index].name}"),
                                                SizedBox(height: 5,),
                                                Text("العدد : ${cubit.carts[index].count}"),
                                                if(cubit.carts[index].size!=null)
                                                  Column(
                                                    children: [
                                                      SizedBox(height: 5,),
                                                      Text("الحجم : ${cubit.carts[index].size}"),
                                                    ],
                                                  ),
                                                if(cubit.carts[index].cheeze!=null)
                                                  Column(
                                                    children: [
                                                      SizedBox(height: 5,),
                                                      Text("نوع الجبن : ${cubit.carts[index].cheeze}"),                                            ],
                                                  ),
                                                SizedBox(height: 5,),
                                                Text("الاجمالي : ${cubit.carts[index].price}"),
                                                SizedBox(height: 5,),
                                                Text(cubit.carts[index].description!=""?"الملاحظات : ${cubit.carts[index].description}":"الملاحظات : لا توجد ملاحظات"),
                                              ],
                                            ),
                                          ),
                                          SizedBox(width: 15,),
                                          IconButton(onPressed: (){
                                            setState(() {
                                              cubit.removeFromList(index: index);
                                            });
                                          }, icon: Icon(Icons.delete_forever,color: Colors.red,size: 35,))
                                        ],
                                      ),
                                    ),
                                    separatorBuilder: (context, index) => SizedBox(
                                      height: 10,
                                    ),
                                    itemCount: cubit.carts.length),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 15,vertical: 5),
                                child: Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Colors.deepOrange,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: TextButton(
                                    onPressed: (){
                                      navigateTo(context: context, widget: ShoppingCompleteScreen());
                                    },
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "اكمال الطلب",
                                          style: TextStyle(color: Colors.white, fontSize: 25),
                                        ),
                                        SizedBox(width: 10,),
                                        Icon(Icons.shopping_cart_outlined,color: Colors.white,)
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 20,)
                            ],
                          ),
                        ),
                        fallback: (context)=>Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.shopping_cart_outlined,size: 65,),
                              SizedBox(height: 20,),
                              Text("السلة فارغة",style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),)
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                )),
          );
        });
  }
}
