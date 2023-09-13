import 'package:http/http.dart' as http;
import 'dart:convert';

class FetchAccountbal{
 Future<int?> getBalance() async {
  final url = Uri.parse('https://api.sandbox.getanchor.co/api/v1/accounts/balance/168780904403423-anc_acc');

  final header = {
    'accept': 'application/json',
    'content-type': 'application/json',
    // My request API key
    'x-anchor-key': 'f9Ehq.ef607b1d168cff00c7794f7d96fdaa1f62961e25c1f23fb92711fc054e608494f28b5498c5dbdba1b0c01b563c815994a467',
  };

  final response = await http.get(url, headers: header);

  if (response.statusCode == 200) {
    final responseData = json.decode(response.body);
    final availableBal = responseData['data']['availableBalance'];
    print(response.body);
    return availableBal;
  } else {
    print(response.body);
    return null;
  }
}

}

