import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'profile_screen.dart';  // Переконайтесь, що файл імпортовано правильно

class HomeScreen extends StatelessWidget {
  Future<List<dynamic>> fetchData() async {
    var response = await http.get(Uri.parse('https://run.mocky.io/v3/b363fe1f-358a-405f-be21-b574ad2be39a')); // Ваш API URL
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Головна сторінка'),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: fetchData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                var item = snapshot.data![index];
                return ListTile(
                  title: Text(item['name']),
                  leading: Image.network(item['image'], width: 100, height: 100, fit: BoxFit.cover),
                );
              },
            );
          }
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
