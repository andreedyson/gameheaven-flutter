import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toastification/toastification.dart';
import 'package:uas_pemrograman_4_22411002_andreedyson/admin/home_admin.dart';
import 'package:uas_pemrograman_4_22411002_andreedyson/auth/register_page.dart';
import 'package:uas_pemrograman_4_22411002_andreedyson/service/api.dart';
import 'package:uas_pemrograman_4_22411002_andreedyson/users/home_users.dart';
import 'package:uas_pemrograman_4_22411002_andreedyson/utils/constants.dart';
import 'package:uas_pemrograman_4_22411002_andreedyson/utils/user_data.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  static String routeName = "/login";

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final dio = Dio();
  bool isLoading = false;
  bool isObscure = true;
  var userData;

  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    final data = await getUserData();
    setState(() {
      userData = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF232429),
      body: SingleChildScrollView(
          child: Column(
        children: [
          Image.asset("assets/images/auth-image.png"),
          Center(
              child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextField(
                  controller: usernameController,
                  decoration: InputDecoration(
                    labelText: 'Username',
                    border: const OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: const BorderSide(
                          color: AppColors.deepPurple, width: 2.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide:
                          const BorderSide(color: Colors.grey, width: 1.0),
                    ),
                    prefixIcon:
                        const Icon(Icons.person, color: Colors.white, size: 20),
                    labelStyle: TextStyle(
                      color: Colors.grey[400],
                    ),
                  ),
                  keyboardType: TextInputType.text,
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(
                  height: 16.0,
                ),
                TextField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: const OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: const BorderSide(
                          color: AppColors.deepPurple, width: 2.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide:
                          const BorderSide(color: Colors.grey, width: 1.0),
                    ),
                    prefixIcon: const Icon(Icons.password,
                        color: Colors.white, size: 20),
                    suffixIcon: IconButton(
                      icon: Icon(
                        isObscure ? Icons.visibility : Icons.visibility_off,
                        color: Colors.grey,
                        size: 24,
                      ),
                      onPressed: () {
                        setState(() {
                          isObscure = !isObscure;
                        });
                      },
                    ),
                    labelStyle: TextStyle(
                      color: Colors.grey[400],
                    ),
                  ),
                  style: const TextStyle(color: Colors.white),
                  keyboardType: TextInputType.text,
                  obscureText: isObscure,
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
                                title:
                                    const Text('Username Tidak Boleh Kosong!'),
                                type: ToastificationType.error,
                                autoCloseDuration: const Duration(seconds: 3),
                                style: ToastificationStyle.fillColored);
                          } else if (passwordController.text.isEmpty) {
                            toastification.show(
                                context: context,
                                title:
                                    const Text('Password Tidak Boleh Kosong!'),
                                type: ToastificationType.error,
                                autoCloseDuration: const Duration(seconds: 3),
                                style: ToastificationStyle.fillColored);
                          } else {
                            loginResponse();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFbf17f1),
                          minimumSize: const Size.fromHeight(50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Login',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),
                      ),
                const SizedBox(
                  height: 24.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Belum memiliki akun?',
                      style: TextStyle(color: Colors.white),
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, RegisterPage.routeName);
                        },
                        child: const Text(
                          'Daftar Disini',
                          style: TextStyle(color: Color(0xFFbf17f1)),
                        ))
                  ],
                )
              ],
            ),
          ))
        ],
      )),
    );
  }

  void loginResponse() async {
    try {
      setState(() {
        isLoading = true;
      });

      await Future.delayed(const Duration(seconds: 2));
      Response response;

      response = await dio.post(login, data: {
        "username": usernameController.text,
        "password": passwordController.text
      });

      if (response.data['status']) {
        toastification.show(
            title: Text(response.data['message']),
            autoCloseDuration: const Duration(seconds: 3),
            type: ToastificationType.success,
            style: ToastificationStyle.fillColored);

        var users = response.data["results"];

        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('username', users["username"]);
        await prefs.setString('full_name', users["full_name"]);
        await prefs.setString('email', users["email"]);
        await prefs.setString('role', users["role"].toString());

        if (users["role"] == 1) {
          Navigator.pushNamed(context, HomeAdminPage.routeName,
              arguments: users);
        } else if (users["role"] == 2) {
          Navigator.pushNamed(context, HomeUsersPage.routeName,
              arguments: users);
        } else {
          toastification.show(
              title: const Text('Akses Dilarang!'),
              autoCloseDuration: const Duration(seconds: 3),
              type: ToastificationType.error,
              style: ToastificationStyle.fillColored);
        }
      } else {
        toastification.show(
            title: Text(response.data['message']),
            autoCloseDuration: const Duration(seconds: 3),
            type: ToastificationType.error,
            style: ToastificationStyle.fillColored);
      }
    } catch (e) {
      toastification.show(
          title: const Text("Terjadi kesalahan pada server"),
          autoCloseDuration: const Duration(seconds: 3),
          type: ToastificationType.error,
          style: ToastificationStyle.fillColored);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
}
