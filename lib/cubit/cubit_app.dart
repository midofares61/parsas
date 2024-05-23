import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parsas2/cubit/state_app.dart';
import '../models/cart_model.dart';
import '../modules/home_screen/home_screen.dart';
import '../modules/shopping/shopping_screen.dart';
import '../shared/network/local/chach_helper.dart';
import '../shared/network/remote/dio_helper.dart';

class CubitApp extends Cubit<StateApp> {
  CubitApp() : super(AppInitialState());

  static CubitApp get(context) => BlocProvider.of(context);

  var currentIndex = 0;

  var isDark = CacheHelper.getData(key: "isDark") != null
      ? CacheHelper.getData(key: "isDark")
      : false;

  void changeMode({required bool value}) {
    isDark = value;
    CacheHelper.SaveData(key: "isDark", value: value);
    emit(ChangeThemeModeState());
  }
  void changeindex(int index) {
    currentIndex = index;
    emit(ChangeIndexBottomState());
  }

  List<Widget> screen = [
    HomeScreen(),
    ShoppingScreen(),
    ShoppingScreen(),
  ];

  List<BottomNavigationBarItem> bottomItem = [
    BottomNavigationBarItem(
        icon: Icon(
          Icons.home,
        ),
        label: "الرئيسية"),
    BottomNavigationBarItem(
        icon: Icon(
          Icons.chat,
        ),
        label: "المحادثات"),
    BottomNavigationBarItem(
        icon: Icon(
          Icons.person,
        ),
        label: "ملفي"),
    BottomNavigationBarItem(
        icon: Icon(
          Icons.notifications,
        ),
        label: "الاشعارات"),
    BottomNavigationBarItem(
        icon: Icon(
          Icons.settings,
        ),
        label: "الضيط"),
  ];

  List<CartModel> carts=[];
  
  void addToList({
    required String name,
    required String description,
    required String image,
    String? size,
    String? cheeze,
    required int price,
    required int count,
}){
    carts.add(CartModel(name: name, description: description, price: price, count: count,image: image, size: size, cheeze: cheeze));
    emit(AddToList());
  }
  void removeFromList({
    required int index
}){
    carts.removeAt(index);
    emit(RemoveFromList());
  }
  // ProfileModel? profilModel;
  //
  // void getProfile({required dynamic id}) async {
  //   emit(OnLoadingGetProfile());
  //   DioHelper.getData(url: "/user/id", data: {"id": id}).then((value) {
  //     profilModel = ProfileModel.fromJson(value?.data);
  //     print(value?.data);
  //     emit(GetProfileSuccessful());
  //   }).catchError((error) {
  //     print(error);
  //     emit(GetProfileError());
  //   });
  // }
  List<dynamic>? section;
  void getSection() async {
    emit(OnLoadingGetSection());
    await DioHelper.getData(url: "/parsas-sub-section").then((value) {
      section = value?.data;
      print(section![0].toString());
      emit(GetSectionSuccessful());
    }).catchError((error) {
      print(error);
      emit(GetSectionError());
    });
  }
  List<dynamic>? items;
  void getItems() async {
    emit(OnLoadingGetItems());
    await DioHelper.getData(url: "/parsas-items").then((value) {
      items = value?.data;
      print(section![0].toString());
      emit(GetItemsSuccessful());
    }).catchError((error) {
      print(error);
      emit(GetItemsError());
    });
  }
  bool? offer;
  void getOffer() async {
    emit(OnLoadingGetOffer());
    await DioHelper.getData(url: "/parsas-offer").then((value) {
      offer = value?.data;
      emit(GetOfferSuccessful());
    }).catchError((error) {
      print(error);
      emit(GetOfferError());
    });
  }
}

