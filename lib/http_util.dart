import 'dart:convert';
import 'dart:io';
import 'commodity.dart';

class IOHttpUtils {
  //创建HttpClient
  List<Map> _dataList = [];
  var _searchList = [];

  getDataList() {
    return _dataList;
  }

  getSearchList() {
    return _searchList;
  }

  // 发送data的http请求，请求结果json会放到_dataList中，调用getDataList()方法获取
  Future<List<Map>> sendDataGet() async {
    HttpClient _httpClient = HttpClient();
    var url = "https://ymao-sps-summer20.appspot.com/data/";
    var request = await _httpClient.getUrl(Uri.parse(url));
    var response = await request.close();
    if (response.statusCode == 200) {
      var string = await response.transform(utf8.decoder).join();
      var rspData = json.decode(string);
      assert(rspData is List);
      _dataList.clear();
      for (var item in rspData) {
        assert(item is Map);
        _dataList.add(item);
      }
      print("get data success!");
    }
    return _dataList;
  }

//  Future<List<Map>> sendDataGet() async {
//    HttpClient _httpClient = HttpClient();
//    var url = "https://ymao-sps-summer20.appspot.com/data/";
//    await _httpClient
//        .getUrl(Uri.parse(url))
//        .then((HttpClientRequest request) {
//      return request.close();
//    }).then((HttpClientResponse response) {
//      if (response.statusCode == 200) {
//        response.transform(utf8.decoder).join().then((String string) {
//          print("get data success!");
//          return json.decode(string);
//        }).then((rspData) {
//          assert(rspData is List);
//          _dataList.clear();
//          for (var item in rspData) {
//            assert(item is Map);
//            _dataList.add(item);
//          }
//        });
//      } else {
//        print("error");
//      }
//      return _dataList;
//    });
//  }

  //search请求用这个
  sendSearchGet() async {
    HttpClient _httpClient = HttpClient();
    _httpClient
        .get('ymao-sps-summer20.appspot.com', 80, '/search')
        .then((HttpClientRequest request) {
      //在这里可以对request请求添加headers操作，写入请求对象数据等等
      // Then call close.
      return request.close();
    }).then((HttpClientResponse response) {
      // 处理response响应
      if (response.statusCode == 200) {
        response.transform(utf8.decoder).join().then((String string) {
          _dataList.clear();
          // print("success");
        });
      } else {
        print("error");
      }
    });
  }

  //添加库存用这个
  // sendAddPost() async {
  //   HttpClient _httpClient = HttpClient();
  //   var url = "https://ymao-sps-summer20.appspot.com/add";
  //   _httpClient.postUrl(Uri.parse(url)).then((HttpClientRequest request) {
  //     //这里添加POST请求Body的ContentType和内容
  //     //这个是application/x-www-form-urlencoded数据类型的传输方式
  //     request.headers.contentType =
  //         ContentType("application", "x-www-form-urlencoded");
  //     request.write("item_id=5631671361601536&number=100");
  //     return request.close();
  //   }).then((HttpClientResponse response) {
  //     // Process the response.
  //     if (response.statusCode == 302) {
  //       response.transform(utf8.decoder).join().then((String string) {
  //         print("add success!");
  //       });
  //     } else {
  //       print("error");
  //     }
  //   });
  // }

  //删除库存用这个
  sendDeletePost(int itemId) async {
    HttpClient _httpClient = HttpClient();
    var url = "https://ymao-sps-summer20.appspot.com/delete";
    _httpClient.postUrl(Uri.parse(url)).then((HttpClientRequest request) {
      //这里添加POST请求Body的ContentType和内容
      //这个是application/x-www-form-urlencoded数据类型的传输方式
      request.headers.contentType =
          ContentType("application", "x-www-form-urlencoded");
      request.write("item_id=$itemId");
      return request.close();
    }).then((HttpClientResponse response) {
      // Process the response.
      if (response.statusCode == 302) {
        response.transform(utf8.decoder).join().then((String string) {
          print("add success!");
        });
      } else {
        print("error");
      }
    });
  }

  sendDataPost(String name, int number, double price) async {
    HttpClient _httpClient = HttpClient();
    var url = "https://ymao-sps-summer20.appspot.com/data/";
    await _httpClient.postUrl(Uri.parse(url)).then((HttpClientRequest request) {
      //这里添加POST请求Body的ContentType和内容
      //这个是application/x-www-form-urlencoded数据类型的传输方式
      request.headers.contentType =
          ContentType("application", "x-www-form-urlencoded");
      request.write("name=$name&number=$number&price=$price");
      return request.close();
    }).then((HttpClientResponse response) {
      // Process the response.
      if (response.statusCode == 302) {
        response.transform(utf8.decoder).join().then((String string) {
          print("add success!");
          return true;
        });
      } else {
        print(response.statusCode);
        print("error");
        return false;
      }
      return true;
    });
  }

//进行POST请求
// postHttpClient() async {
//   _httpClient
//       .post('ymao-sps-summer20.appspot.com', 80, '/add')
//       .then((HttpClientRequest request) {
//     //这里添加POST请求Body的ContentType和内容
//     //这个是application/json数据类型的传输方式
//     request.headers.contentType = ContentType("application", "json");
//     request.write("{\"item_id\":5631671361601536,\"number\":12}");
//     return request.close();
//   }).then((HttpClientResponse response) {
//     // Process the response.
//     print("!!");
//     if (response.statusCode == 200) {
//       response.transform(utf8.decoder).join().then((String string) {
//         print(string);
//       });
//     } else {
//       print("error");
//     }
//   });
// }

}
