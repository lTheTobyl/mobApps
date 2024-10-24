import 'package:flutter/material.dart';
import 'profile_screen.dart'; // Додайте цей імпорт

class HomeScreen extends StatelessWidget {
  final List<String> items = [
    'Елемент 1',
    'Елемент 2',
    'Елемент 3',
    'Елемент 4',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Головна сторінка'),
      ),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(items[index]),
            leading: Icon(Icons.star),
            onTap: () {
              // Додайте функціональність для елементів списку, якщо потрібно
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ProfileScreen()),
          );
        },
        child: Icon(Icons.settings), // Іконка для налаштувань
        tooltip: 'Налаштування акаунта',
      ),
    );
  }
}
