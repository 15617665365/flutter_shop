import 'package:flutter/material.dart';
import '../service/service_method.dart';
import 'dart:convert';
import '../model/category.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provide/provide.dart';
import '../provide/child_category.dart';
import '../provide/category _goods_list.dart';
import '../model/categoryGoodsList.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CategoryPage extends StatefulWidget {
  @override
  CategoryPageState createState() => new CategoryPageState();
}

class CategoryPageState extends State<CategoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('商品分类')),
      body: Container(
        child: Row(
          children: <Widget>[
            _LeftCategoryNav(),
            Column(
              children: <Widget>[RightCategoryNav(), CatgoryGoodsList()],
            )
          ],
        ),
      ),
    );
  }
}

class _LeftCategoryNav extends StatefulWidget {
  @override
  _LeftCategoryNavState createState() => new _LeftCategoryNavState();
}

class _LeftCategoryNavState extends State<_LeftCategoryNav> {
  List<Data> list = [];

  var lisetInadex = 0;

  var scrollController = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getHotGoods();
    _getGoodsList();
  }

  @override
  Widget build(BuildContext context) {
    try {
      if (Provide.value<ChildCategory>(context).subId == '') {
        //
        scrollController.animateTo(0);
        print('=====${scrollController.position}');
      }
    } catch (e) {
      print('第一次初始化${e}');
    }
    return Container(
      width: ScreenUtil().setWidth(180),
      decoration: BoxDecoration(
          border: Border(right: BorderSide(width: 1, color: Colors.black12))),
      child: ListView.builder(
        controller: scrollController,
        itemCount: list.length,
        itemBuilder: (context, index) {
          return _leftInkWell(index);
        },
      ),
    );
  }

  Widget _leftInkWell(int index) {
    bool isClick = false;
    isClick = (index == lisetInadex) ? true : false;
    return InkWell(
      onTap: () {
        setState(() {
          lisetInadex = index;
        });
        var childList = list[index].bxMallSubDto;
        var categoryID = list[index].mallCategoryId;

        Provide.value<ChildCategory>(context)
            .getChildCategroy(childList, categoryID);

        _getGoodsList(categoryId: categoryID);
      },
      child: Container(
        height: ScreenUtil().setHeight(100),
        padding: EdgeInsets.only(left: 10, top: 20),
        decoration: BoxDecoration(
            color: isClick ? Colors.black12 : Colors.white,
            border:
                Border(bottom: BorderSide(width: 1, color: Colors.black12))),
        child: Text(
          list[index].mallCategoryName,
          style: TextStyle(fontSize: ScreenUtil().setSp(28)),
        ),
      ),
    );
  }

  void _getHotGoods() async {
    await request('getCategory').then((val) {
      var data = json.decode(val.toString());
      CategoryModel categorylist = CategoryModel.fromJson(data);

      setState(() {
        list = categorylist.data;
      });

      Provide.value<ChildCategory>(context)
          .getChildCategroy(list[0].bxMallSubDto, list[0].mallCategoryId);
    });
  }

  void _getGoodsList({String categoryId}) async {
    var data = {
      'categoryId': categoryId == null ? '4' : categoryId,
      'categorySubId': '',
      'page': '1'
    };
    await request('getMallGoods', fromData: data).then((val) {
      var data = json.decode(val);
      CategoryGoodsListModel goodsList = CategoryGoodsListModel.fromJson(data);
      Provide.value<CategoryGoodsListProvide>(context)
          .getGoodsList(goodsList.data);
    });
  }
}

class RightCategoryNav extends StatefulWidget {
  @override
  RightCategoryNavState createState() => new RightCategoryNavState();
}

class RightCategoryNavState extends State<RightCategoryNav> {
  @override
  Widget build(BuildContext context) {
    return Provide<ChildCategory>(builder: (context, child, childCategory) {
      return Container(
        height: ScreenUtil().setHeight(80),
        width: ScreenUtil().setWidth(570),
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
                bottom: BorderSide(
              width: 1,
              color: Colors.black12,
            ))),
        child: ListView.builder(
          itemBuilder: (context, index) {
            return _rightInkWell(index, childCategory.childCategroyList[index]);
          },
          scrollDirection: Axis.horizontal,
          itemCount: childCategory.childCategroyList.length,
        ),
      );
    });
  }

  Widget _rightInkWell(int index, BxMallSubDto item) {
    bool isClick = false;
    isClick = (index == Provide.value<ChildCategory>(context).childIndex)
        ? true
        : false;
    return InkWell(
      onTap: () {
        Provide.value<ChildCategory>(context)
            .changeChildIndex(index, item.mallSubId);
        _getGoodsList(item.mallSubId);
      },
      child: Container(
        padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
        child: Text(
          item.mallSubName,
          style: TextStyle(
              fontSize: ScreenUtil().setSp(28),
              color: isClick ? Colors.pink : Colors.black),
        ),
      ),
    );
  }

  void _getGoodsList(String categorySubId) async {
    var fromData = {
      'categoryId': Provide.value<ChildCategory>(context).categoryId,
      'categorySubId': categorySubId,
      'page': '1'
    };
    print(fromData);
    await request('getMallGoods', fromData: fromData).then((val) {
      var data = json.decode(val);
      CategoryGoodsListModel goodsList = CategoryGoodsListModel.fromJson(data);
      Provide.value<CategoryGoodsListProvide>(context)
          .getGoodsList(goodsList.data);
    });
  }
}

class CatgoryGoodsList extends StatefulWidget {
  @override
  CatgoryGoodsListState createState() => new CatgoryGoodsListState();
}

class CatgoryGoodsListState extends State<CatgoryGoodsList> {
  GlobalKey<RefreshFooterState> _footerkey = GlobalKey<RefreshFooterState>();

  var scrollController = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Provide<CategoryGoodsListProvide>(builder: (context, child, data) {
      try {
        if (Provide.value<ChildCategory>(context).page == 1) {
          //
          scrollController.jumpTo(0);
        }
      } catch (e) {
        print('第一次初始化${e}');
      }
      return Expanded(
          child: Container(
        width: ScreenUtil().setWidth(570),
        child: EasyRefresh(
          refreshFooter: ClassicsFooter(
            key: _footerkey,
            bgColor: Colors.white,
            textColor: Colors.pink,
            moreInfoColor: Colors.pink,
            showMore: true,
            noMoreText: Provide.value<ChildCategory>(context).noMoretext,
            moreInfo: '加载中',
            loadReadyText: '上拉加载',
          ),
          child: ListView.builder(
            controller: scrollController,
            itemBuilder: (context, index) {
              return _ListWidget(data.goodsList, index);
            },
            itemCount: (data.goodsList != null) ? data.goodsList.length : 0,
          ),
          loadMore: () {
            print('加载更多....');
            _getMoreGoodsList();
          },
        ),
      ));
    });
  }

  void _getMoreGoodsList() async {
    Provide.value<ChildCategory>(context).changePage();
    var fromData = {
      'categoryId': Provide.value<ChildCategory>(context).categoryId,
      'categorySubId': Provide.value<ChildCategory>(context).subId,
      'page': Provide.value<ChildCategory>(context).page
    };
    print(fromData);
    await request('getMallGoods', fromData: fromData).then((val) {
      var data = json.decode(val);
      CategoryGoodsListModel goodsList = CategoryGoodsListModel.fromJson(data);
      if (goodsList.data == null) {
        print('www');
        Fluttertoast.showToast(
            msg: '已经到底了',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.pink,
            textColor: Colors.white,
            fontSize: 16.0);
        Provide.value<ChildCategory>(context).changeNoMore('没有更多了');

      } else {
        Provide.value<CategoryGoodsListProvide>(context)
            .getMoreGoodsList(goodsList.data);
      }
    });
  }

  Widget _goodsImage(list, index) {
    return Container(
      width: ScreenUtil().setWidth(200),
      child: Image.network(list[index].image),
    );
  }

  Widget _goodsName(list, index) {
    return Container(
      padding: EdgeInsets.all(5),
      width: ScreenUtil().setWidth(370),
      child: Text(
        list[index].goodsName,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(fontSize: ScreenUtil().setSp(28)),
      ),
    );
  }

  Widget _goodsPrice(list, index) {
    return Container(
        padding: EdgeInsets.only(top: 20),
        width: ScreenUtil().setWidth(370),
        child: Row(
          children: <Widget>[
            Text(
              '价格：¥${list[index].presentPrice}',
              style: TextStyle(
                  fontSize: ScreenUtil().setSp(30), color: Colors.pink),
            ),
            Text(
              '¥${list[index].oriPrice}',
              style: TextStyle(
                  fontSize: ScreenUtil().setSp(28),
                  color: Colors.black26,
                  decoration: TextDecoration.lineThrough),
            ),
          ],
        ));
  }

  Widget _ListWidget(list, index) {
    return InkWell(
      onTap: () {},
      child: Container(
        padding: EdgeInsets.only(top: 5, bottom: 5),
        decoration: BoxDecoration(
            color: Colors.white,
            border:
                Border(bottom: BorderSide(width: 1, color: Colors.black12))),
        child: Row(
          children: <Widget>[
            _goodsImage(list, index),
            Column(
              children: <Widget>[
                _goodsName(list, index),
                _goodsPrice(list, index)
              ],
            )
          ],
        ),
      ),
    );
  }
}
