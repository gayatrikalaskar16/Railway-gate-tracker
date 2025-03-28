import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:manage_realway/ProfileScreen.dart';
import 'package:manage_realway/SpachScreen.dart';
import 'package:manage_realway/gate_data_uploader.dart';
import 'package:manage_realway/home_screen.dart';

import 'login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Add this block to upload gate data
  // final gateDataUploader = GateDataUploader();
  // final gateData = [
  //   {
  //     "gate_name": "Malavali Gate",
  //     "gate_id": 1,
  //     "location": {"latitude": 18.7542, "longitude": 73.4782},
  //     "timing": [
  //       {"open_time": "10:00", "close_time": "10:15"},
  //       {"open_time": "10:30", "close_time": "10:45"},
  //       {"open_time": "11:00", "close_time": "11:15"},
  //       {"open_time": "11:30", "close_time": "11:45"}
  //     ]
  //   },
  //   {
  //     "gate_name": "Lonavala Gate",
  //     "gate_id": 2,
  //     "location": {"latitude": 18.7481, "longitude": 73.4072},
  //     "timing": [
  //       {"open_time": "10:05", "close_time": "10:20"},
  //       {"open_time": "10:35", "close_time": "10:50"},
  //       {"open_time": "11:05", "close_time": "11:20"},
  //       {"open_time": "11:35", "close_time": "11:50"}
  //     ]
  //   },
  //   {
  //     "gate_name": "Kamshet Gate",
  //     "gate_id": 3,
  //     "location": {"latitude": 18.7430, "longitude": 73.5205},
  //     "timing": [
  //       {"open_time": "10:10", "close_time": "10:25"},
  //       {"open_time": "10:40", "close_time": "10:55"},
  //       {"open_time": "11:10", "close_time": "11:25"},
  //       {"open_time": "11:40", "close_time": "11:55"}
  //     ]
  //   },
  //   {
  //     "gate_name": "Vadgaon Gate",
  //     "gate_id": 4,
  //     "location": {"latitude": 18.7572, "longitude": 73.6142},
  //     "timing": [
  //       {"open_time": "10:15", "close_time": "10:30"},
  //       {"open_time": "10:45", "close_time": "11:00"},
  //       {"open_time": "11:15", "close_time": "11:30"},
  //       {"open_time": "11:45", "close_time": "12:00"}
  //     ]
  //   },
  //   {
  //     "gate_name": "Talegaon Gate",
  //     "gate_id": 5,
  //     "location": {"latitude": 18.7359, "longitude": 73.6798},
  //     "timing": [
  //       {"open_time": "10:20", "close_time": "10:35"},
  //       {"open_time": "10:50", "close_time": "11:05"},
  //       {"open_time": "11:20", "close_time": "11:35"},
  //       {"open_time": "11:50", "close_time": "12:05"}
  //     ]
  //   },
  //   {
  //     "gate_name": "Wadgaon Gate",
  //     "gate_id": 6,
  //     "location": {"latitude": 18.7321, "longitude": 73.7191},
  //     "timing": [
  //       {"open_time": "10:25", "close_time": "10:40"},
  //       {"open_time": "10:55", "close_time": "11:10"},
  //       {"open_time": "11:25", "close_time": "11:40"},
  //       {"open_time": "11:55", "close_time": "12:10"}
  //     ]
  //   },
  //   {
  //     "gate_name": "Dehu Road Gate",
  //     "gate_id": 7,
  //     "location": {"latitude": 18.7074, "longitude": 73.7603},
  //     "timing": [
  //       {"open_time": "10:30", "close_time": "10:45"},
  //       {"open_time": "11:00", "close_time": "11:15"},
  //       {"open_time": "11:30", "close_time": "11:45"},
  //       {"open_time": "12:00", "close_time": "12:15"}
  //     ]
  //   },
  //   {
  //     "gate_name": "Akurdi Gate",
  //     "gate_id": 8,
  //     "location": {"latitude": 18.6725, "longitude": 73.7532},
  //     "timing": [
  //       {"open_time": "10:35", "close_time": "10:50"},
  //       {"open_time": "11:05", "close_time": "11:20"},
  //       {"open_time": "11:35", "close_time": "11:50"},
  //       {"open_time": "12:05", "close_time": "12:20"}
  //     ]
  //   },
  //   {
  //     "gate_name": "Chinchwad Gate",
  //     "gate_id": 9,
  //     "location": {"latitude": 18.6261, "longitude": 73.7844},
  //     "timing": [
  //       {"open_time": "10:40", "close_time": "10:55"},
  //       {"open_time": "11:10", "close_time": "11:25"},
  //       {"open_time": "11:40", "close_time": "11:55"},
  //       {"open_time": "12:10", "close_time": "12:25"}
  //     ]
  //   },
  //   {
  //     "gate_name": "Kasarwadi Gate",
  //     "gate_id": 10,
  //     "location": {"latitude": 18.6122, "longitude": 73.8031},
  //     "timing": [
  //       {"open_time": "10:45", "close_time": "11:00"},
  //       {"open_time": "11:15", "close_time": "11:30"},
  //       {"open_time": "11:45", "close_time": "12:00"},
  //       {"open_time": "12:15", "close_time": "12:30"}
  //     ]
  //   },
  //   {
  //     "gate_name": "Dapodi Gate",
  //     "gate_id": 11,
  //     "location": {"latitude": 18.5863, "longitude": 73.8167},
  //     "timing": [
  //       {"open_time": "10:50", "close_time": "11:05"},
  //       {"open_time": "11:20", "close_time": "11:35"},
  //       {"open_time": "11:50", "close_time": "12:05"},
  //       {"open_time": "12:20", "close_time": "12:35"}
  //     ]
  //   },
  //   {
  //     "gate_name": "Khadki Gate",
  //     "gate_id": 12,
  //     "location": {"latitude": 18.5588, "longitude": 73.8376},
  //     "timing": [
  //       {"open_time": "10:55", "close_time": "11:10"},
  //       {"open_time": "11:25", "close_time": "11:40"},
  //       {"open_time": "11:55", "close_time": "12:10"},
  //       {"open_time": "12:25", "close_time": "12:40"}
  //     ]
  //   },
  //   {
  //     "gate_name": "Shivajinagar Gate",
  //     "gate_id": 13,
  //     "location": {"latitude": 18.5286, "longitude": 73.8553},
  //     "timing": [
  //       {"open_time": "11:00", "close_time": "11:15"},
  //       {"open_time": "11:30", "close_time": "11:45"},
  //       {"open_time": "12:00", "close_time": "12:15"},
  //       {"open_time": "12:30", "close_time": "12:45"}
  //     ]
  //   },
  //   {
  //     "gate_name": "Pune Station Gate",
  //     "gate_id": 14,
  //     "location": {"latitude": 18.5294, "longitude": 73.8743},
  //     "timing": [
  //       {"open_time": "11:05", "close_time": "11:20"},
  //       {"open_time": "11:35", "close_time": "11:50"},
  //       {"open_time": "12:05", "close_time": "12:20"},
  //       {"open_time": "12:35", "close_time": "12:50"}
  //     ]
  //   }
  // ];
  // await gateDataUploader.uploadGateData(gateData);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Railway Gate Traffic',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/splash', // Set initial route to SplashScreen
      routes: {
        '/splash': (context) => SplashScreen(), // Add the SplashScreen route
        '/': (context) => AuthWrapper(), // Updated AuthWrapper
        '/login': (context) => LoginScreen(),
        '/home': (context) => MainPage(),
        '/profile': (context) => ProfileScreen(),
      },
    );
  }
}

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Check if the snapshot has data (user is logged in)
        if (snapshot.connectionState == ConnectionState.active) {
          User? user = snapshot.data;
          if (user == null) {
            // If no user is logged in, show the LoginScreen
            return LoginScreen();
          } else {
            // If user is logged in, show the MainPage
            return MainPage();
          }
        } else {
          // While the connection is loading, show a loading indicator
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}
