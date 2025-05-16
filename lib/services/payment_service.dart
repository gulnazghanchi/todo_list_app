import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class PaymentService {
  static final _razorpay = Razorpay();
  static bool _isInitialized = false;

  static void _initializeRazorpay(Function onSuccess, Function onError) {
    if (!_isInitialized) {
      _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, onSuccess);
      _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, onError);
      _isInitialized = true;
    }
  }

  static Future<void> makePayment(BuildContext context, {required double amount}) async {
    try {
      final key = dotenv.env['RAZORPAY_KEY'];
      if (key == null || key.isEmpty) {
        throw Exception('Razorpay key not found in .env file');
      }

      _initializeRazorpay(
        (PaymentSuccessResponse response) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    Icon(
                      Icons.check_circle,
                      color: Colors.white,
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Payment successful!',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
                backgroundColor: Colors.green,
                behavior: SnackBarBehavior.floating,
                margin: EdgeInsets.all(16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            );
          }
        },
        (PaymentFailureResponse response) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    Icon(
                      Icons.error_outline,
                      color: Colors.white,
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Payment failed: ${response.message ?? 'Unknown error'}',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
                backgroundColor: Colors.red,
                behavior: SnackBarBehavior.floating,
                margin: EdgeInsets.all(16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            );
          }
        },
      );

      var options = {
        'key': key,
        'amount': (amount * 100).toInt(), // Convert to paise
        'name': 'Todo List App',
        'description': 'Payment for Todo List App',
        'prefill': {
          'contact': '9876543210', // Replace with user's phone
          'email': 'user@example.com' // Replace with user's email
        }
      };

      _razorpay.open(options);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(
                  Icons.error_outline,
                  color: Colors.white,
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Payment failed: ${e.toString()}',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.all(16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      }
    }
  }
}
