// import 'package:candles/categories_page.dart';
import 'package:candles/categories_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    home: Home(),
  ));
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          // Background image that covers the whole page
          Image.asset(
            'assets/image.jpg', // Your background image here
            fit: BoxFit.cover, // Cover the entire screen
            height: screenHeight, // Ensure the image takes full screen height
            width: screenWidth, // Ensure the image takes full screen width
          ),
          // Positioned login button in the top-right corner
          Positioned(
            top: screenHeight * 0.67,
            right: screenWidth * 0.15, // 5% from the top
            // 5% from the right
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple[200],
                  padding:
                      EdgeInsets.symmetric(horizontal: 100.0, vertical: 5)),
              onPressed: () {
                // Navigate to the LoginPage
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CategoriesPage()),
                );
              },
              child: const Text(
                'Shop Now !',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
