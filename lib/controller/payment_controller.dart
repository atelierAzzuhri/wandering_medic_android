import 'package:http/http.dart' as http;

class PaymentController {
  final http.Client client;
  final String baseUrl = 'http://10.0.2.2:3000';

  PaymentController({http.Client? client}) : client = client ?? http.Client();

  Future<void> createPayment() async {
    // TODO: implement createPayment logic
  }

  Future<void> updatePayment() async {
    // TODO: implement updatePayment logic
  }

  Future<void> deletePayment() async {
    // TODO: implement deletePayment logic
  }
}