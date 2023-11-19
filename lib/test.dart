// import 'package:flutter/material.dart';
// import 'package:flutter_inappwebview/flutter_inappwebview.dart';

// void main() => runApp(MyApp());

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: Text('GCash Payment App'),
//         ),
//         body: PaymentWebView(),
//       ),
//     );
//   }
// }

// class PaymentWebView extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return WebView(
//       initialFile: 'https://www.gcash.com/payment', // Replace with the actual GCash payment URL
//       javascriptMode: JavascriptMode.unrestricted,
//     );
//   }
// }




// // import 'package:flutter/material.dart';
// // import 'dart:convert';
// // import 'package:http/http.dart' as http;
// // import 'package:url_launcher/url_launcher.dart';

// // class Test extends StatefulWidget {
// //   const Test({Key? key}) : super(key: key);

// //   @override
// //   State<Test> createState() => _TestState();
// // }

// // class _TestState extends State<Test> {
// //   String? paymentStatus; // To store payment status

// //   @override
// //   Widget build(BuildContext context) {
// //     return Center(
// //       child: ElevatedButton(
// //         onPressed: () async {
// //           // Initiate payment and get payment status
// //           final status = await initiatePayment();
// //           setState(() {
// //             paymentStatus = status;
// //           });

// //           // Display a SnackBar with the payment status
// //           ScaffoldMessenger.of(context).showSnackBar(
// //             SnackBar(
// //               content: Text('Payment Status: $status'),
// //             ),
// //           );
// //         },
// //         child: Text('Initiate Payment'),
// //       ),
// //     );
// //   }

// //   Future initiatePayment() async {
// //     final url = Uri.parse("https://api4wrd-v1.kpa.ph/paymongo/v1/create");

// //     // Define the redirect URLs
// //     final redirectUrls = {
// //       "success": "https://example.com/success", // Replace with your success URL
// //       "failed": "https://example.com/failed",   // Replace with your failed URL
// //     };

// //     // Define billing information
// //     final billing = {
// //       "email": "tejeytejey13@gmail.com",
// //       "name": "Thomas Jon Barrientos",
// //       "phone": "09505787169",
// //       "address": {
// //         "line1": "Matina Crossing",
// //         "line2": "Talomo",
// //         "city": "Davao City",
// //         "state": "Davao Del Sur",
// //         "postal_code": "8000",
// //         "country": "Philippines"
// //       }
// //     };

// //     // Define payment attributes
// //     final attributes = {
// //       "livemode": false,
// //       "type": "gcash",
// //       "amount": 1,
// //       "currency": "PHP",
// //       "redirect": redirectUrls,
// //       "billing": billing
// //     };

// //     // Define the source data
// //     final source = {
// //       "app_key": "5f529cf475ead8b4e4b473eb0299d922ec6e433a",
// //       "secret_key": "sk_test_GMxMwsrSWj69NEY1YQZ89vgU",
// //       "password": "Capstoneprojectpasado2@",
// //       "data": {"attributes": attributes}
// //     };

// //     final jsonData = jsonEncode(source);

// //     // Make a POST request to initiate payment
// //     final response = await http.post(
// //       url,
// //       headers: {'Content-Type': 'application/json'},
// //       body: jsonData,
// //     );

// //     if (response.statusCode == 200) {
// //       final Map<String, dynamic> resData = jsonDecode(response.body);
// //       final String redirectUrl = resData['url_redirect'];

// //       // Launch the GCash payment URL in the default browser
// //       if (await canLaunch(redirectUrl)) {
// //         await launch(redirectUrl);
// //       } else {
// //         print('Could not launch $redirectUrl');
// //       }
// //     } else {
// //       // Handle the error by displaying an error message and the response body
// //       print('Payment initiation failed. Status Code: ${response.statusCode}');
// //       print('Response Body: ${response.body}');
// //     }
// //   }
// // }
