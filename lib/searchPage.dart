import 'package:flutter/material.dart';
import 'package:flutterapp2/commodity.dart';
import 'http_util.dart';
import 'detailPage.dart';

void main() => runApp(MyApp());
List recentList = [];
List searchList = [];
var resultList = [];
Map resultMap = {};
IOHttpUtils _ioHttpUtils = new IOHttpUtils();

getAllData() async {
  await _ioHttpUtils.sendDataGet();
  resultList = _ioHttpUtils.getDataList();
}

updateData() {
  searchList.clear();
  for (var result in resultList) {
    searchList.add(result["name"]);
    resultMap[result["name"]] = Commodity(result["name"], result["number"]);
  }
  print("search: $searchList");
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'search',
      home: SearchBar(),
    );
  }
}

class SearchBar extends StatefulWidget {
  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SearchBar'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              getAllData();
              showSearch(context: context, delegate: SearchBarDelegate());
            },
          ),
        ],
      ),
    );
  }
}

class SearchBarDelegate extends SearchDelegate<String> {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () => query = "",
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow, progress: transitionAnimation),
      onPressed: () {
        if (query.isEmpty) {
          close(context, null);
        } else {
          query = "";
          showSuggestions(context);
        }
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container(
        child: GestureDetector(
      child: Center(
        child: Text("$query"),
      ),
      onTap: () {
        print("$query");
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DetailPage(
                      detailData: Commodity('abc', 1),
                    )));
      },
    ));
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    updateData();
    final suggestionList = query.isEmpty
        ? recentList
        : searchList.where((input) => input.contains(query)).toList();
    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: (context, index) {
        // 创建一个富文本，匹配的内容特别显示
        return ListTile(
          title: RichText(
              text: TextSpan(
            text: suggestionList[index].substring(0, query.length),
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            children: [
              TextSpan(
                  text: suggestionList[index].substring(query.length),
                  style: TextStyle(color: Colors.grey))
            ],
          )),
          onTap: () {
            query = suggestionList[index];
            if (!recentList.contains(query)) recentList.add(query);
            print("query: $query");
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DetailPage(
                          detailData: resultMap[query],
                        )));
            // Scaffold.of(context).showSnackBar(SnackBar(content: Text(query)));
          },
        );
      },
    );
  }

  @override
  ThemeData appBarTheme(BuildContext context) {
    assert(context != null);
    final ThemeData theme = Theme.of(context);
    assert(theme != null);
    return theme.copyWith(
      primaryColor: Colors.white,
      primaryIconTheme: theme.primaryIconTheme.copyWith(color: Colors.grey),
      primaryColorBrightness: Brightness.light,
      primaryTextTheme: theme.textTheme,
    );
  }
}
