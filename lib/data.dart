import 'package:http/http.dart' as http;

Future<void> fetchData() async {

  var url = Uri.parse('https://nutrifit-server-h52zonluwa-du.a.run.app/users');
  var response = await http.get(url);

  if (response.statusCode == 200) {
    // 성공적으로 데이터를 받음
    print('Response data${response.body}');
  } else {
    // 에러 처리
    print('Request failed${response.statusCode}');
  }
}