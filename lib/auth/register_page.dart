import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';
import 'package:uas_pemrograman_4_22411002_andreedyson/auth/login_page.dart';
import 'package:uas_pemrograman_4_22411002_andreedyson/service/api.dart';
import 'package:uas_pemrograman_4_22411002_andreedyson/utils/constants.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  static String routeName = "/register";

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final dio = Dio();
  bool isLoading = false;
  bool isObscure = true;

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
                const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Daftarkan Akun',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Text(
                  'Buat akun baru untuk masuk ke dalam aplikasi GameHeaven.',
                  style: TextStyle(
                      color: Colors.grey[400], fontWeight: FontWeight.w100),
                ),
                const SizedBox(
                  height: 16,
                ),
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
                        const Icon(Icons.email, color: Colors.white, size: 20),
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
                        const Icon(Icons.badge, color: Colors.white, size: 20),
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
                        const Icon(Icons.phone, color: Colors.white, size: 20),
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
                                title:
                                    const Text('Password Tidak Boleh Kosong!'),
                                type: ToastificationType.error,
                                autoCloseDuration: const Duration(seconds: 3),
                                style: ToastificationStyle.fillColored);
                          } else {
                            registerResponse();
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
                          'Register',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                const SizedBox(
                  height: 16.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
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
