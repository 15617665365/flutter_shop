import 'package:flutter/material.dart';
import './pages/index_page.dart';
import 'package:provide/provide.dart';
import './provide/child_category.dart';
import './provide/counter.dart';
import './provide/category _goods_list.dart';

void main() {
  var counter = Counter();
  var childCategory = ChildCategory();
  var categoryGoodsListProvide = CategoryGoodsListProvide();

  var provides = Providers();
  provides
    ..provide(Provider<Counter>.value(counter))
    ..provide(Provider<ChildCategory>.value(childCategory))
    ..provide(
        Provider<CategoryGoodsListProvide>.value(categoryGoodsListProvide));

  runApp(ProviderNode(child: MyApp(), providers: provides));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Container(
      child: MaterialApp(
        title: '百姓生活+',
        theme: ThemeData(primaryColor: Colors.pinkAccent),
        home: IndexPage(),
      ),
    );
  }
}
