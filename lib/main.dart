import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/todo_list_screen.dart';

void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    
    // Load environment variables
    await dotenv.load(fileName: '.env');
    final key = dotenv.env['RAZORPAY_KEY'];
    print('Razorpay Key: $key'); // Debug print
    
    if (key == null || key.isEmpty) {
      throw Exception('Razorpay key not found in .env file');
    }
    
    runApp(const MyApp());
  } catch (e) {
    print('Error during initialization: $e'); // Debug print
    runApp(MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text(
            'Error initializing app: $e',
            style: TextStyle(color: Colors.red),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    ));
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo List App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6750A4),
          primary: const Color(0xFF6750A4),
          secondary: const Color(0xFF9C27B0),
          tertiary: const Color(0xFF7C4DFF),
        ),
        useMaterial3: true,
        textTheme: GoogleFonts.poppinsTextTheme(),
        cardTheme: const CardTheme(
          elevation: 2,
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
      ),
      home: const TodoListScreen(),
    );
  }
}
