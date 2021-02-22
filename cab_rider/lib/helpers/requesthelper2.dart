import 'dart:convert';

import 'package:http/http.dart' ;

class RequestHelper2{


  static Future<dynamic> getRequest(String url) async {
    Response response = await get(url);

    try{
      if(response.statusCode == 200){
        Map<String, dynamic> map = jsonDecode(response.body);
        print('map'+map.toString());
        return map ;
      }
      else{
        return 'failed';
      }
    }
    catch(e){
      return 'failed';
    }


  }

}