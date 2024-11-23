import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';
import 'package:uas_pemrograman_4_22411002_andreedyson/auth/login_page.dart';
import 'package:uas_pemrograman_4_22411002_andreedyson/service/api.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  static String routeName = "/register";

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final dio = Dio();
  bool isLoading = false;

  TextEditingController usernameController = TextEditingController();
  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF232429),
      body: SingleChildScrollView(
          child: Center(
              child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 48,
            ),
            Image.asset(
              'assets/images/game-console.png',
              width: 100.0,
              height: 100.0,
            ),
            const SizedBox(
              height: 24,
            ),
            Text(
              'Game',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                  fontSize: 24,
                  color: Colors.blue[300]),
            ),
            Text(
              'Heaven',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                  fontSize: 24,
                  color: Colors.blue[300]),
            ),
            const SizedBox(
              height: 32.0,
            ),
            TextField(
              controller: usernameController,
              decoration: InputDecoration(
                labelText: 'Username',
                border: const OutlineInputBorder(),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.cyan, width: 2.0),
                ),
                labelStyle: TextStyle(
                  color: Colors.grey[400],
                ),
              ),
              style: const TextStyle(color: Colors.white),
              keyboardType: TextInputType.text,
            ),
            const SizedBox(
              height: 16.0,
            ),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                border: const OutlineInputBorder(),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.cyan, width: 2.0),
                ),
                labelStyle: TextStyle(
                  color: Colors.grey[400],
                ),
              ),
              style: const TextStyle(color: Colors.white),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(
              height: 16.0,
            ),
            TextField(
              controller: fullNameController,
              decoration: InputDecoration(
                labelText: 'Full Name',
                border: const OutlineInputBorder(),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.cyan, width: 2.0),
                ),
                labelStyle: TextStyle(
                  color: Colors.grey[400],
                ),
              ),
              style: const TextStyle(color: Colors.white),
              keyboardType: TextInputType.text,
            ),
            const SizedBox(
              height: 16.0,
            ),
            TextField(
              controller: phoneController,
              decoration: InputDecoration(
                labelText: 'Phone Number',
                border: const OutlineInputBorder(),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.cyan, width: 2.0),
                ),
                labelStyle: TextStyle(
                  color: Colors.grey[400],
                ),
              ),
              style: const TextStyle(color: Colors.white),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(
              height: 16.0,
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                border: const OutlineInputBorder(),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.cyan, width: 2.0),
                ),
                labelStyle: TextStyle(
                  color: Colors.grey[400],
                ),
              ),
              style: const TextStyle(color: Colors.white),
              keyboardType: TextInputType.text,
              obscureText: true,
            ),
            const SizedBox(
              height: 24.0,
            ),
            isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: () {
                      if (usernameController.text.isEmpty) {
                        toastification.show(
                            context: context,
                            title: const Text('Username Tidak Boleh Kosong!'),
                            type: ToastificationType.error,
                            autoCloseDuration: const Duration(seconds: 3),
                            style: ToastificationStyle.fillColored);
                      } else if (fullNameController.text.isEmpty) {
                        toastification.show(
                            context: context,
                            title: const Text('Nama Tidak Boleh Kosong!'),
                            type: ToastificationType.error,
                            autoCloseDuration: const Duration(seconds: 3),
                            style: ToastificationStyle.fillColored);
                      } else if (phoneController.text.isEmpty) {
                        toastification.show(
                            context: context,
                            title: const Text(
                                'Nomor Handphone Tidak Boleh Kosong!'),
                            type: ToastificationType.error,
                            autoCloseDuration: const Duration(seconds: 3),
                            style: ToastificationStyle.fillColored);
                      } else if (emailController.text.isEmpty) {
                        toastification.show(
                            context: context,
                            title: const Text('Email Tidak Boleh Kosong!'),
                            type: ToastificationType.error,
                            autoCloseDuration: const Duration(seconds: 3),
                            style: ToastificationStyle.fillColored);
                      } else if (passwordController.text.isEmpty) {
                        toastification.show(
                            context: context,
                            title: const Text('Password Tidak Boleh Kosong!'),
                            type: ToastificationType.error,
                            autoCloseDuration: const Duration(seconds: 3),
                            style: ToastificationStyle.fillColored);
                      } else {
                        registerResponse();
                      }
                      ;
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.cyan,
                        minimumSize: const Size.fromHeight(50)),
                    child: const Text(
                      'Register',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
            const SizedBox(
              height: 16.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Text(
                  'Sudah memiliki akun?',
                  style: TextStyle(color: Colors.white),
                ),
                TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, LoginPage.routeName);
                    },
                    child: const Text(
                      'Login',
                      style: TextStyle(color: Colors.cyan),
                    ))
              ],
            )
          ],
        ),
      ))),
    );
  }

  void registerResponse() async {
    try {
      setState(() {
        isLoading = true;
      });

      await Future.delayed(const Duration(seconds: 2));
      Response response;

      response = await dio.post(register, data: {
        "username": usernameController.text,
        "full_name": fullNameController.text,
        "email": emailController.text,
        "phone": phoneController.text,
        "password": passwordController.text
      });

      if (response.data['status']) {
        toastification.show(
            title: Text(response.data['message']),
            type: ToastificationType.success,
            autoCloseDuration: const Duration(seconds: 3),
            style: ToastificationStyle.fillColored);
        Navigator.pushNamed(context, LoginPage.routeName);
      } else {
        toastification.show(
            title: Text(response.data['message']),
            type: ToastificationType.error,
            autoCloseDuration: const Duration(seconds: 3),
            style: ToastificationStyle.fillColored);
      }
    } catch (e) {
      toastification.show(
          title: const Text("Terjadi kesalahan pada server"),
          type: ToastificationType.error,
          autoCloseDuration: const Duration(seconds: 3),
          style: ToastificationStyle.fillColored);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
}
