import 'package:flutter/material.dart';
import '../model/category.dart';

class ChildCategory with ChangeNotifier{

  List<BxMallSubDto> childCategroyList = [];
  int childIndex = 0;//小类高亮索引
  String categoryId = '4';//大类ID
  String subId = '';//小类ID
  int page = 1;
  String noMoretext = '';

  getChildCategroy(List<BxMallSubDto> list, String id){
    childIndex = 0;
    categoryId = id;
    page = 1;
    noMoretext = '';
    subId = '';

    BxMallSubDto all = BxMallSubDto();
    all.mallCategoryId = '';
    all.mallSubId = '';
    all.comments = 'null';
    all.mallSubName = '全部';

    childCategroyList = [all];
    childCategroyList.addAll(list);

    notifyListeners();
  }

  changeChildIndex(index, String id){
    childIndex = index;
    subId = id;
    page = 1;
    noMoretext = '';

    notifyListeners();
  }

  changePage(){
    page++;
  }

  changeNoMore(String text){
    noMoretext = text;
    notifyListeners();
  }
}