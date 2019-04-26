import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'home_page.dart';
import 'category_page.dart';
import 'cart_page.dart';
import 'member_page.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
class IndexPage extends StatefulWidget {
  @override
  IndexPageState createState() => new IndexPageState();
}

class IndexPageState extends State<IndexPage> {
  final List<BottomNavigationBarItem> BottomTabs = [
    BottomNavigationBarItem(
        icon: Icon(CupertinoIcons.home),
        title: Text('首页')
    ),
    BottomNavigationBarItem(
        icon: Icon(CupertinoIcons.search),
        title: Text('分类')
    ),
    BottomNavigationBarItem(
        icon: Icon(CupertinoIcons.shopping_cart),
        title: Text('购物车')
    ),
    BottomNavigationBarItem(
        icon: Icon(CupertinoIcons.profile_circled),
        title: Text('会员中心')
    ),
  ];

  final List<Widget> tabBodies = [Homepage(), CategoryPage(), CartPage(), MemberPage()];

  int currentIndex = 0;
  var currentPage;

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);

    return Scaffold(
      backgroundColor: Color.fromRGBO(244, 245, 245, 1),
      bottomNavigationBar: BottomNavigationBar(
        items: BottomTabs,
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        onTap: (index){
          setState(() {
            currentIndex = index;
            currentPage = tabBodies[currentIndex];
          });
        },
      ),
      body: IndexedStack(
        index: currentIndex,
        children: tabBodies,
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    currentPage = tabBodies[currentIndex];
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void didUpdateWidget(IndexPage oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }
}
