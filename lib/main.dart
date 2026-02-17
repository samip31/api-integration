import 'package:democlass/example.dart';
import 'package:democlass/modules/auth/register/register_view.dart';
import 'package:democlass/modules/counter.dart';
import 'package:democlass/modules/hotels/hotel_view.dart';
import 'package:democlass/modules/splash_screen.dart';
import 'package:democlass/services/api_helper.dart';
import 'package:democlass/user_data_response.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: AppBarTheme(iconTheme: IconThemeData(color: Colors.white)),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: ExampleView(),
    );
  }
}

class HomePage extends StatelessWidget {
  HomePage({super.key});
  ApiHelper apiHelper = ApiHelper();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 100,
                  width: 100,
                  child: Image.network(
                    "https://img.freepik.com/free-vector/colorful-letter-gradient-logo-design_474888-2309.jpg?semt=ais_hybrid&w=740&q=80",
                  ),
                ),
                SizedBox(height: 60),
                Text(
                  "Welcome Back",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text("Sign in to your Account"),
                SizedBox(height: 60),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Email Address"),
                    TextField(
                      decoration: InputDecoration(border: OutlineInputBorder()),
                    ),
                    SizedBox(height: 30),
                    Text("Password"),
                    TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(Icons.visibility_off_sharp),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          "Already have an account?",
                          textAlign: TextAlign.right,
                        ),
                      ],
                    ),

                    SizedBox(height: 20),

                    GestureDetector(
                      onTap: () async {
                        final userResponse = await apiHelper
                            .getRandomUserData();
                        // final user = userResponse.results?.first;
                        final user = await apiHelper.getUser();
                        if (user != null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => NextPage(user: user),
                            ),
                          );
                        }
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(builder: (context) => NextPage()),
                        // );
                      },
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.green,
                        ),

                        child: Center(
                          child: Text(
                            "Log In",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class NextPage extends StatefulWidget {
  NextPage({super.key, required this.user});

  final User user;

  @override
  State<NextPage> createState() => _NextPageState();
}

class _NextPageState extends State<NextPage> {
  List<String> names = ["smith", "john", "eden"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("User details", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.teal,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(
                        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRz24Uni0ZwfyHw-MXfr0QhUDNRmaAPKRnhBk-kj_Pra0Rg9Q4zUuArJt1bXLYz2JILe7Mr944EaeuZiv5Kr_o4eEpOehU-pYDvjKtJuww&s=10',
                      ),
                      backgroundColor: Colors.grey.shade200,
                    ),
                    SizedBox(width: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.user.name ?? "",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                          ),
                        ),
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(5),
                              color: Colors.teal,
                              child: Text(
                                "Mrs",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            SizedBox(width: 20),
                            Text("Age: 63"),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Icon(Icons.email, color: Colors.teal),
                    SizedBox(width: 20),
                    Text(
                      "Email",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: 20),
                    Text(
                      "email@example.com",
                      style: TextStyle(color: Colors.teal),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                InfoRowWidget(
                  icon: Icons.email,
                  title: "Email",
                  value: "email@example.com",
                ),
                SizedBox(height: 20),
                InfoRowWidget(
                  icon: Icons.phone,
                  title: "Phone",
                  value: "phone",
                ),
                SizedBox(height: 20),
                InfoRowWidget(
                  icon: Icons.home,
                  title: "Address",
                  value: "address",
                ),
                Expanded(
                  child: ListView.builder(
                    itemBuilder: (context, position) {
                      return Container(
                        padding: EdgeInsets.all(10),
                        margin: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          names[position],
                          style: TextStyle(color: Colors.white),
                        ),
                      );
                    },
                    itemCount: names.length,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {});
                    names.add("New user");
                  },
                  child: Text("Add User"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class InfoRowWidget extends StatelessWidget {
  const InfoRowWidget({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
  });

  final String title;
  final IconData icon;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Colors.teal),
        SizedBox(width: 20),
        Text("Username", style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(width: 20),
        Text("username", style: TextStyle(color: Colors.teal)),
      ],
    );
  }
}
