import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parsas2/shared/network/local/chach_helper.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../cubit/cubit_app.dart';
import '../../cubit/state_app.dart';

class ShoppingCompleteScreen extends StatefulWidget {
  const ShoppingCompleteScreen({super.key});

  @override
  State<ShoppingCompleteScreen> createState() => _ShoppingCompleteScreenState();
}

class _ShoppingCompleteScreenState extends State<ShoppingCompleteScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  var formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    Future<void> launcherUrl(url) async {
      if (!await launchUrl(url)) {
        throw Exception('Could not launch $url');
      }
    }
    return BlocConsumer<CubitApp, StateApp>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = CubitApp.get(context);
          final isDesktop = MediaQuery.of(context).size.width >= 500;
          return Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              appBar: AppBar(
                title: Text("اكمال الطلب"),
              ),
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Container(
                    width: double.infinity,
                    child: Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "يرجي ادخال البيانات الخاصة بك بشكل صحيح حتي نكمل الطلب",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            controller: nameController,
                            keyboardType: TextInputType.text,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "يجب ادخال الاسم حتي تتمكن من اكمال الطلب";
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                isDense: true,
                                hintText: "الاسم"),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            controller: phoneController,
                            keyboardType: TextInputType.phone,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "يجب ادخال رقم الهاتف حتي تتمكن من اكمال الطلب";
                              }
                              if(!value.startsWith("01")){
                                return "يجب ادخال رقم صحيح";
                              }
                              if(value.length<11){
                                return " هذا الرقم اقل من 11 رقم يجب ادخال رقم صحيح";
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                isDense: true,
                                hintText: "رقم الهاتف"),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            controller: locationController,
                            keyboardType: TextInputType.text,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "يجب ادخال العنوان حتي تتمكن من اكمال الطلب";
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                isDense: true,
                                hintText: "العنوان"),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.deepOrange,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: TextButton(
                              onPressed: () {
                                if (formKey.currentState!.validate()) {
                                  double total = 0;
                                  cubit.carts.forEach((product) {
                                    // قم بتحديث السعر الإجمالي بسعر كل منتج مضروباً بالكمية
                                    total += (product.price! * product.count!);
                                  });
                                  String one="""
                                  مرحبًا ،أود تقديم طلب
                                    =================================
                                  """;
                                  String result = cubit.carts.map((product) {
                                    if(product.size!=null){
                                      return """
                                          اسم الصنف: ${product.name}
                                          الحجم: ${product.size}
                                          العدد: ${product.count}
                                          ملاحظات: ${product.description}
                                          السعر: ${product.price}
                                          =================================
                                        """;
                                    }else if(product.cheeze!=null){
                                      return """
                                          اسم الصنف: ${product.name}
                                          نوع الجبن: ${product.cheeze}
                                          العدد: ${product.count}
                                          ملاحظات: ${product.description}
                                          السعر: ${product.price}
                                          =================================
                                        """;
                                    }else{
                                      return """
                                          اسم الصنف: ${product.name}
                                          العدد: ${product.count}
                                          ملاحظات: ${product.description}
                                          السعر: ${product.price}
                                          =================================
                                        """;
                                    }
                                  }).join('\n');
                                  String userInfo =CacheHelper.getData(key: "offer")!=null? """
                                  اسم المستلم: ${nameController.text}
                                  العنوان: ${locationController.text}
                                  رقم الموبايل: ${phoneController.text}
                                  خصم: ${CacheHelper.getData(key: "offer")}%
                                  الاجمالي: ${total} جنيه بعد الخصم الاجمالي ${total-((total/100)*CacheHelper.getData(key: "offer"))}
                                  =================================
                                  parsas : سوف نؤكد طلبك عند استلام الرسالة
                                  """: """
                                  اسم المستلم: ${nameController.text}
                                  العنوان: ${locationController.text}
                                  رقم الموبايل: ${phoneController.text}
                                  الاجمالي: ${total} جنيه
                                  =================================
                                  parsas : سوف نؤكد طلبك عند استلام الرسالة
                                  """;
                                  result += '\n$userInfo';
                                  one+='\n$result';
                                  launcherUrl(Uri.parse('https://wa.me/201025600970?text=$one'));
                                  cubit.carts.clear();
                                  CacheHelper.removeData(key: "offer");
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                }
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "اكمال الطلب",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 25),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Icon(
                                    Icons.shopping_cart_outlined,
                                    color: Colors.white,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }
}
