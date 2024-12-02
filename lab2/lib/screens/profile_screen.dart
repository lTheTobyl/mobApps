import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/custom_button.dart';
import 'login_screen.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? name;
  String? email;
  String? password;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString('name');
      email = prefs.getString('email');
      password = prefs.getString('password');
      _nameController.text = name ?? '';
      _emailController.text = email ?? '';
    });
  }

  Future<void> _logout(BuildContext context) async {
  // Відображення діалогового вікна для підтвердження
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Підтвердження'),
        content: Text('Ви впевнені, що хочете вийти з акаунта?'),
        actions: <Widget>[
          TextButton(
            child: Text('Ні'),
            onPressed: () {
              Navigator.of(context).pop(); // Закриваємо діалогове вікно без виходу
            },
          ),
          TextButton(
            child: Text('Так'),
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.setBool('isLoggedIn', false);
              Navigator.of(context).pop(); // Закриваємо діалогове вікно
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
            },
          ),
        ],
      );
    },
  );
}


  Future<void> _changeName(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Змінити ім\'я'),
          content: TextField(
            controller: _nameController,
            decoration: InputDecoration(labelText: 'Нове ім\'я'),
            onChanged: (value) {
              setState(() {
                name = value; // Оновлюємо ім'я в UI під час введення
              });
            },
          ),
          actions: [
            TextButton(
              onPressed: () async {
                final prefs = await SharedPreferences.getInstance();
                await prefs.setString('name', _nameController.text);
                Navigator.of(context).pop();
              },
              child: Text('Зберегти'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Скасувати'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _changeEmail(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Змінити пошту'),
          content: TextField(
            controller: _emailController,
            decoration: InputDecoration(labelText: 'Нова пошта'),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                final prefs = await SharedPreferences.getInstance();
                await prefs.setString('email', _emailController.text);
                setState(() {
                  email = _emailController.text; // Оновлюємо email в UI
                });
                Navigator.of(context).pop();
              },
              child: Text('Зберегти'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Скасувати'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _changePassword(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Змінити пароль'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Новий пароль'),
                obscureText: true,
              ),
              TextField(
                controller: _confirmPasswordController,
                decoration: InputDecoration(labelText: 'Підтвердіть пароль'),
                obscureText: true,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                if (_passwordController.text == _confirmPasswordController.text) {
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.setString('password', _passwordController.text);
                  setState(() {
                    password = _passwordController.text; // Оновлюємо пароль в UI
                  });
                  Navigator.of(context).pop();
                } else {
                  // Виводимо повідомлення про помилку
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Паролі не співпадають!')),
                  );
                }
              },
              child: Text('Зберегти'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Скасувати'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Профіль користувача'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            Text(
              'Ім\'я: ${name ?? 'Не задано'}',
              style: TextStyle(fontSize: 24),
            ),
            Text(
              'Пошта: ${email ?? 'Не задано'}',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            CustomButton(
              text: 'Змінити ім\'я',
              onPressed: () => _changeName(context),
            ),
            SizedBox(height: 10),
            CustomButton(
              text: 'Змінити пошту',
              onPressed: () => _changeEmail(context),
            ),
            SizedBox(height: 10),
            CustomButton(
              text: 'Змінити пароль',
              onPressed: () => _changePassword(context),
            ),
            SizedBox(height: 20),
            CustomButton(
              text: 'Вихід',
              onPressed: () => _logout(context),
            ),
          ],
        ),
      ),
    );
  }
}
