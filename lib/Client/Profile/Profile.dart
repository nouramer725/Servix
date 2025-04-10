import 'package:flutter/material.dart';
import '../../Components/Buttons.dart';

void main() {
  runApp(ProfileClient());
}

class ProfileClient extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Profile',
      theme: ThemeData(primarySwatch: Colors.brown),
      debugShowCheckedModeBanner: false,
      home: ProfileScreen(),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {},
        ),
        title: Text(
          'My Profile',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage(
                      'assets/profile/profileClient.png',
                    ),
                  ),
                  Positioned(
                    bottom: 5,
                    right: 5,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: Icon(
                        Icons.camera_alt,
                        size: 20,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              _buildLabeledTextField('First Name', 'Nayera'),
              _buildLabeledTextField('Second Name', 'Nagy'),
              _buildLabeledTextField('Email', 'nayeranagy33@gmail.com'),
              _buildLabeledTextField('Phone Number', '+20 1281231790'),
              SizedBox(height: 20),
              _buildLocationSection(),
              SizedBox(height: 30),
              GradientButton(onPressed: () {}, text: 'Update'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabeledTextField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: TextField(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
        controller: TextEditingController(text: value),
      ),
    );
  }

  Widget _buildLocationSection() {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            'assets/profile/Map.png',
            height: 100,
            fit: BoxFit.cover,
          ), // Map image placeholder
          SizedBox(height: 10),
          Row(
            children: [
              Icon(Icons.location_on, color: Color(0xff821717)),
              SizedBox(width: 5),
              Expanded(
                child: Text(
                  'Kafr Abdo, Street Mahmoud Abou El Ela, Client building, Apartment no. 145',
                  style: TextStyle(fontSize: 14),
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {},
              child: Text(
                'Change your Location',
                style: TextStyle(
                  color: Colors.black,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
