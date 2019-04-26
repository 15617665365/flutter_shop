import 'package:flutter/material.dart';
import '../service/service_method.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'dart:convert';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';

class Homepage extends StatefulWidget {
  @override
  HomepageState createState() => HomepageState();
}

class HomepageState extends State<Homepage> with AutomaticKeepAliveClientMixin {
  int page = 1;
  List<Map> hotGoodsList = [];

  GlobalKey<RefreshFooterState> _footerkey = GlobalKey<RefreshFooterState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var fromData = {'lon': '115.02932', 'lat': '35.76189'};
    return Container(
        child: Scaffold(
            appBar: AppBar(
              title: Text('百姓生活+'),
            ),
            body: FutureBuilder(
              future: request('homePageContent', fromData: fromData),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  var data = json.decode(snapshot.data.toString());
                  List<Map> swiper = (data['data']['slides'] as List).cast();
                  List<Map> navgatorList =
                      (data['data']['category'] as List).cast();
                  String adPicture =
                      data['data']['advertesPicture']['PICTURE_ADDRESS'];
                  String laaderImage = data['data']['shopInfo']['leaderImage'];
                  String laaderPhone = data['data']['shopInfo']['leaderPhone'];
                  List<Map> recommendList =
                      (data['data']['recommend'] as List).cast();

                  String floor1Title =
                      data['data']['floor1Pic']['PICTURE_ADDRESS'];
                  String floor2Title =
                      data['data']['floor2Pic']['PICTURE_ADDRESS'];
                  String floor3Title =
                      data['data']['floor3Pic']['PICTURE_ADDRESS'];

                  List<Map> floor1 = (data['data']['floor1'] as List).cast();
                  List<Map> floor2 = (data['data']['floor2'] as List).cast();
                  List<Map> floor3 = (data['data']['floor3'] as List).cast();

                  return EasyRefresh(
                    refreshFooter: ClassicsFooter(
                      key: _footerkey,
                      bgColor: Colors.white,
                      textColor: Colors.pink,
                      moreInfoColor: Colors.pink,
                      showMore: true,
                      noMoreText: '',
                      moreInfo: '加载中',
                      loadReadyText: '上拉加载',
                    ),
                    child: ListView(
                      children: <Widget>[
                        SwiperDiy(swiperDateList: swiper),
                        TopNavigetor(navigatorList: navgatorList),
                        Adbanner(adpicture: adPicture),
                        LeaderPhone(
                            leaderImage: laaderImage, leaderPhone: laaderPhone),
                        Recommend(recommentList: recommendList),
                        FloorTitle(picture_address: floor1Title),
                        FloorContent(floorGoodsList: floor1),
                        FloorTitle(picture_address: floor2Title),
                        FloorContent(floorGoodsList: floor2),
                        FloorTitle(picture_address: floor3Title),
                        FloorContent(floorGoodsList: floor3),
                        _hotGoods()
                      ],
                    ),
                    loadMore: () async {
                      print('加载更多....');
                      var fromPage = {'page': page};
                      await request('homePageBelowConten', fromData: fromPage)
                          .then((val) {
                        var data = json.decode(val.toString());
                        List<Map> newGoodsList = (data['data'] as List).cast();

                        setState(() {
                          hotGoodsList.addAll(newGoodsList);
                          page++;
                        });
                      });
                    },
                  );
                } else {
                  return Center(
                    child: Text('加载中'),
                  );
                }
              },
            )));
  }

  Widget hotTitle = Container(
    margin: EdgeInsets.only(top: 10, bottom: 10),
    alignment: Alignment.center,
    color: Colors.transparent,
    child: Text('火爆专区'),
  );

  Widget _wrapList() {
    if (hotGoodsList.length != 0) {
      List<Widget> listWidget = hotGoodsList.map((val) {
        return InkWell(
          onTap: () {},
          child: Container(
            width: ScreenUtil().setWidth(372),
            color: Colors.white,
            padding: EdgeInsets.all(5),
            margin: EdgeInsets.only(bottom: 3),
            child: Column(
              children: <Widget>[
                Image.network(
                  val['image'],
                  width: ScreenUtil().setWidth(370),
                ),
                Text(
                  val['name'],
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: Colors.pink, fontSize: ScreenUtil().setSp(26)),
                ),
                Row(
                  children: <Widget>[
                    Text('¥${val['mallPrice']}'),
                    Text('¥${val['price']}',
                        style: TextStyle(
                            color: Colors.black26,
                            decoration: TextDecoration.lineThrough)),
                  ],
                )
              ],
            ),
          ),
        );
      }).toList();

      return Wrap(
        spacing: 2,
        children: listWidget,
      );
    } else {
      return Text('');
    }
  }

  Widget _hotGoods() {
    return Container(
      child: Column(
        children: <Widget>[hotTitle, _wrapList()],
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

//首页轮播图
class SwiperDiy extends StatelessWidget {
  final List swiperDateList;

  const SwiperDiy({Key key, this.swiperDateList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenUtil().setHeight(333),
      width: ScreenUtil().setWidth(750),
      //MediaQuery.of(context).size.width/1125*500,
      child: Swiper(
        itemCount: swiperDateList.length,
        itemBuilder: (BuildContext context, int index) {
          return Image.network(swiperDateList[index]['image'],
              fit: BoxFit.fill);
        },
        pagination: SwiperPagination(),
        autoplay: true,
      ),
    );
  }
}

//顶部导航
class TopNavigetor extends StatelessWidget {
  final List navigatorList;

  const TopNavigetor({Key key, this.navigatorList}) : super(key: key);

  Widget _gridViewItemUI(BuildContext context, item) {
    return InkWell(
        onTap: () {
          print('点击');
        },
        child: Column(
          children: <Widget>[
            Image.network(item['image'], width: ScreenUtil().setWidth(95)),
            Text(item['mallCategoryName'])
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    if (navigatorList.length > 10) {
      navigatorList.removeRange(9, navigatorList.length - 1);
    }
    return Container(
      height: ScreenUtil().setHeight(320),
      padding: EdgeInsets.all(3),
      child: GridView.count(
        physics: NeverScrollableScrollPhysics(),
        crossAxisCount: 5,
        padding: EdgeInsets.all(5),
        children: navigatorList.map((item) {
          return _gridViewItemUI(context, item);
        }).toList(),
      ),
    );
  }
}

//广告位
class Adbanner extends StatelessWidget {
  final String adpicture;

  const Adbanner({Key key, this.adpicture}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Image.network(adpicture),
    );
  }
}

//打电话
class LeaderPhone extends StatelessWidget {
  final String leaderImage;
  final String leaderPhone;

  const LeaderPhone({Key key, this.leaderImage, this.leaderPhone})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: InkWell(
        onTap: _launchURL,
        child: Image.network(leaderImage),
      ),
    );
  }

  void _launchURL() async {
    print('111');
    String url = 'tel:' + leaderPhone;
    if (await canLaunch(url)) {
      await launch(url);
    }
  }
}

//商品推荐
class Recommend extends StatelessWidget {
  final List recommentList;

  const Recommend({Key key, this.recommentList}) : super(key: key);

  //商品标题
  Widget _titltWeget() {
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.fromLTRB(10, 2, 0, 5),
      decoration: BoxDecoration(
          color: Colors.white,
          border:
              Border(bottom: BorderSide(width: 0.5, color: Colors.black12))),
      child: Text(
        '商品推荐',
        style: TextStyle(color: Colors.pink),
      ),
    );
  }

  //商品单独项
  Widget _item(index) {
    return InkWell(
      onTap: () {},
      child: Container(
        height: ScreenUtil().setHeight(330),
        width: ScreenUtil().setWidth(250),
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
            color: Colors.white,
            border:
                Border(left: BorderSide(width: 0.5, color: Colors.black12))),
        child: Column(
          children: <Widget>[
            Image.network(recommentList[index]['image']),
            Text('￥${recommentList[index]['mallPrice']}'),
            Text(
              '￥${recommentList[index]['price']}',
              style: TextStyle(
                  decoration: TextDecoration.lineThrough, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  //横向列表
  Widget _recommentList() {
    return Container(
      height: ScreenUtil().setHeight(350),
      child: ListView.builder(
        itemBuilder: (context, index) {
          return _item(index);
        },
        scrollDirection: Axis.horizontal,
        itemCount: recommentList.length,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenUtil().setHeight(420),
      margin: EdgeInsets.only(top: 10),
      child: Column(
        children: <Widget>[_titltWeget(), _recommentList()],
      ),
    );
  }
}

//楼层标题
class FloorTitle extends StatelessWidget {
  final String picture_address;

  const FloorTitle({Key key, this.picture_address}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      child: Image.network(picture_address),
    );
  }
}

//楼层商品
class FloorContent extends StatelessWidget {
  final List floorGoodsList;

  const FloorContent({Key key, this.floorGoodsList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[_firstRow(), _otherGoods()],
      ),
    );
  }

  Widget _firstRow() {
    return Row(
      children: <Widget>[
        _goodsItem(floorGoodsList[0]),
        Column(
          children: <Widget>[
            _goodsItem(floorGoodsList[1]),
            _goodsItem(floorGoodsList[2]),
          ],
        )
      ],
    );
  }

  Widget _otherGoods() {
    return Row(
      children: <Widget>[
        _goodsItem(floorGoodsList[3]),
        _goodsItem(floorGoodsList[4]),
      ],
    );
  }

  Widget _goodsItem(Map goods) {
    return Container(
      width: ScreenUtil().setWidth(375),
      child: InkWell(
        onTap: () {},
        child: Image.network(goods['image']),
      ),
    );
  }
}
