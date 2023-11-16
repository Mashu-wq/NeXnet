
import 'package:flutter/material.dart';
import 'package:nexnet/constants/routes.dart';

class OrderSuccessPage extends StatefulWidget {
  const OrderSuccessPage({super.key});

  @override
  State<OrderSuccessPage> createState() => _OrderSuccessPageState();
}

class _OrderSuccessPageState extends State<OrderSuccessPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor:const Color.fromARGB(255, 59, 78, 87),
        title: const Text('Thank You'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Image.asset(
            'assets/icons/verify.png',
            height: 200,
            width: 200,
          ),
          const Padding(
            padding: EdgeInsets.only(top: 16, bottom: 8),
            child: Text(
              'Order Confirmed',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
                color: Colors.black54,
              ),
            ),
          ),
          const Text(
            'Continue your conversation with gigs through our \nMessaging services.',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontWeight: FontWeight.w500, fontSize: 13, color: Colors.black54),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 70, 16, 0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 59, 78, 87),
                minimumSize: const Size(140, 48),
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(22),
                ),
              ),
              onPressed: () {
                Navigator.of(context).popAndPushNamed(
                  rootRoute,
                  // (Route<dynamic> route) => false,
                );
              },
              child: const Text(
                'Back to Feed',
                style: TextStyle(fontSize: 18, color: Colors.black54),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
