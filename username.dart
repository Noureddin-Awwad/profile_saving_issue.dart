import 'package:flutter/material.dart';
import 'package:hooka/screens/edit_profile.dart';
import 'package:hooka/screens/user.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:io';
import 'education.dart';
import 'experience.dart';
import 'address.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';

class UsernamePage extends StatefulWidget {
  final VoidCallback? onBack;

  const UsernamePage({super.key, this.onBack});

  @override
  State<UsernamePage> createState() => _UsernamePageState();

  static _UsernamePageState? of(BuildContext context) {
    return context.findAncestorStateOfType<_UsernamePageState>();
  }
}

class _UsernamePageState extends State<UsernamePage> with WidgetsBindingObserver {
  late Box<User> _userBox;
  User? _currentUser;

  void saveUserData(User updatedUser) {
    setState(() {
      _currentUser = updatedUser;
    });

    // Save the updated user data to Hive
    _userBox.put('currentUser', _currentUser!);
  }
  @override
  void initState() {
    super.initState();
    _openHiveBox().then((_) {
      _fetchUserData(); // Call _fetchUserData after _openHiveBox completes
    });
    WidgetsBinding.instance.addObserver(this);
  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Get the updated user data passed from EditProfilePage
    final updatedUser = ModalRoute.of(context)?.settings.arguments as User?;

    if (updatedUser != null) {
      setState(() {
        _currentUser = updatedUser;
      });
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
  Future<void> _openHiveBox() async {
    await Hive.initFlutter(); // Initialize Hive
    Hive.registerAdapter(UserAdapter()); // Register your User adapter
    _userBox = await Hive.openBox<User>('users'); // Open thebox
  }

  Future<void> _fetchUserData() async {
    _currentUser = _userBox.get('currentUser');

    if (_currentUser == null) {
      // Handle case where user data is not found (e.g., create a new user)
      _currentUser = User(
        firstName: '',
        lastName: '',
        email: '',
        mobile: '',
        bio: '',educationList: [],
        experienceList: [],
        addressList: [],
        bodyType: '',
        hairType: '',
        hairColor: '',
        facebook: '',
        instagram: '',
        tiktok: '',
        gender: '',
        maritialStatus: '',
        interest: '',
      );
      await _userBox.put('currentUser', _currentUser!); // Store the new user
    }

    setState(() {}); // Update the UI
  }

  Future<void> _launchURL(String url) async {
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url);
    } else {
      print('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            if (widget.onBack != null) {
              widget.onBack!();
              Navigator.pop(context);
            }
          },
        ),
        title: const Text(
          'My Account',
          style: TextStyle(fontFamily: "Comfortaa-VariableFont_wght",
            fontWeight: FontWeight.w500,
            fontSize: 20,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditProfilePage(user: _currentUser), // Pass the User object
                ),
              );
            },
            child: const Text(
              'Edit',
              style: TextStyle(
                color: Colors.black,
                fontFamily: "Comfortaa-VariableFont_wght",
                fontWeight: FontWeight.w500,
              ),
            ),
          )
        ],
        centerTitle: true,
      ),
      body:
      SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: double.infinity,
              height: 300,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(45),
                  bottomRight: Radius.circular(45),
                ),
                image: DecorationImage(
                  image: _currentUser?.imagePath != null && _currentUser!.imagePath!.isNotEmpty
                      ? FileImage(File(_currentUser!.imagePath!))
                      : const AssetImage('assets/images/profile_image.png') as ImageProvider,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, top: 20.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'Name: ${_currentUser?.firstName ?? ''} ${_currentUser?.lastName ?? ''}',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, top: 10.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  _currentUser?.email ?? 'Email',
                  style: const TextStyle(
                    fontSize: 16.0,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, top: 10.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  _currentUser?.mobile ?? 'PhoneNumber',
                  style: const TextStyle(
                    fontSize: 16.0,
                  ),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 20.0, top: 20.0), // Adjust padding as needed
              child: Align(
                alignment: Alignment.topLeft, // Align to the left
                child: Text(
                  'About',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0, // Adjust font size as needed
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, top: 10.0, right: 20.0), // Adjust padding as needed
              // Example for the 'bio' field
              child: Text(
                _currentUser?.bio ??  'Bio', // Display default text
                style: const TextStyle(
                  fontSize: 16.0, // Adjust font size as needed
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 20.0, top: 20.0), // Adjust padding as needed
              child: Align(
                alignment: Alignment.topLeft, // Align to the left
                child: Text(
                  'Basic Information',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0, // Adjust font size as needed
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0), // Adjust padding as needed
              child: Table(
                border: TableBorder.all(color: Colors.grey[300]!), // Set border color
                children: [
                  TableRow(
                    children: [
                      // Column 1, Row 1
                      // Column 1, Row 1
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Date Of Birth'), // Label, not bold
                          Text(
                            (_currentUser?.dateOfBirthInMillis != null && _currentUser?.dateOfBirthInMillis is DateTime) // Check for null and type
                                ? '${(_currentUser?.dateOfBirthInMillis as DateTime).year}-${(_currentUser?.dateOfBirthInMillis as DateTime).month}-${(_currentUser?.dateOfBirthInMillis as DateTime).day}'
                                : 'N/A',
                            style: const TextStyle(fontWeight: FontWeight.bold), // Variable, bold
                          ),
                          ],
                        ),
                      ),
            // Column 2, Row 1
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Gender'), // Label, not bold
                            Text(
                              _currentUser?.gender ??  'Gender',
                              style: const TextStyle(fontWeight: FontWeight.bold), // Variable, bold
                            ),
                          ],
                        ),
                      ),
            // Column 3, Row 1
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Status'), // Label, not bold
                            Text(
                              _currentUser?.maritialStatus ??  'Status',
                              style: const TextStyle(fontWeight: FontWeight.bold), // Variable, bold
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      // Column 1, Row 2
                      // Column 1, Row 2
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,children: [
                          const Text('Body Type'), // Label
                          Text(
                            _currentUser?.bodyType ??  'Body Type',
                            style: const TextStyle(fontWeight: FontWeight.bold), // Variable, bold
                          ),
                        ],
                        ),
                      ),
            // Column 2, Row 2
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Hair'), // Label
                            Text(
                              _currentUser?.hairType ??  'Hair Type',
                              style: const TextStyle(fontWeight: FontWeight.bold), // Variable, bold
                            ),
                          ],
                        ),
                      ),
            // Column 3, Row 2
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Eyes'), // Label
                            Text(
                              _currentUser?.hairColor ??  'Eye Color',
                              style: const TextStyle(fontWeight: FontWeight.bold), // Variable, bold
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
                      Row(mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Facebook logo
              IconButton(
                onPressed: () {
                  final facebookUrl = _currentUser?.facebook;
                  if (facebookUrl != null && facebookUrl.isNotEmpty){
                    _launchURL(facebookUrl);
                  }
                },
                icon: const FaIcon(FontAwesomeIcons.facebook),
              ),
              IconButton(
                onPressed: () {
                  final instagramUrl = _currentUser?.instagram;
                  if (instagramUrl != null && instagramUrl.isNotEmpty) {
                    _launchURL(instagramUrl);
                  }
                },
                icon: const FaIcon(FontAwesomeIcons.instagram),
              ),
              IconButton(
                onPressed: () {
                  final tiktokUrl = _currentUser?.tiktok;
                  if (tiktokUrl != null && tiktokUrl.isNotEmpty) {
                    _launchURL(tiktokUrl);
                  }
                },
                icon: const FaIcon(FontAwesomeIcons.tiktok),
              ),
            ],
                      ),// Helper function to launch URLs
            const Padding(
              padding: EdgeInsets.only(left: 20.0, top: 20.0), // Adjust padding as needed
              child: Align(
                alignment: Alignment.topLeft, // Align to the left
                child: Text(
                  'Interest',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0, // Adjust font size as needed
                  ),
                ),
              ),
            ),
            (_currentUser?.interest)?.isNotEmpty ?? false // Check for null and empty
                ? Padding(
              padding: const EdgeInsets.only(left: 20.0, top: 8.0),
              child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(_currentUser?.interest as String)), // Cast to String
            ): Padding(
              padding: const EdgeInsets.only(left: 20.0, top: 8.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: SizedBox(
                  width: 115, // Adjust width as needed
                  height: 30, // Adjust height as needed
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.lightBlue[100], // Baby blue color
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: const Center(
                      child: Text('No interest yet..'),
                    ),
                  ),
                ),
              ),
            ),
            const ListTile(
              title: Text(
                'Education',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                ),
              ),
            ),

            if ((_currentUser?.educationList as List?)?.isNotEmpty ?? false) // Null check and type cast
              SizedBox(
                height: 200,
                child: EducationSection(
                  educationList: (_currentUser?.educationList as List?)
                      ?.map((e) => Education.fromMap(e as Map<String, dynamic>))
                      .toList() ??
                      [], // Type cast and provide default empty list
                ),
              )
            else
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'No Education added..',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),

          ],
        ),

      ),
    );
  }
}
class EducationSection extends StatelessWidget {
  final List<Education> educationList;

  const EducationSection({super.key, required this.educationList});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: educationList.map((education) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Table(
              border: TableBorder.all(color: Colors.grey[300]!),
              columnWidths: const {
                0: FlexColumnWidth(1),
                1: FlexColumnWidth(1),
              },
              children: [
                const TableRow(
                  children: [
                    Padding(padding: EdgeInsets.all(8.0),
                      child: Text('University'),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('From'),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        education.universityName ?? '', // Provide default value if null
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        education.fromDateInMillis != null
                            ? education.fromDateInMillis!.toIso8601String()
                            : 'N/A',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const TableRow(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('Degree'),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('To'),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        education.degreeName ?? '', // Provide default value if null
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        education.toDateInMillis != null
                            ? education.toDateInMillis!.toIso8601String()
                            : 'N/A',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

extension on int {
  toIso8601String() {}
}
