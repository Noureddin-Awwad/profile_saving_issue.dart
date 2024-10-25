import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooka/screens/add_new_address.dart';
import 'package:hooka/screens/add_new_education_page.dart';
import 'package:hooka/screens/add_new_experience.dart';
import 'package:hooka/screens/username.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
import '../screens/user.dart';
import '../screens/education.dart';
import '../screens/experience.dart';
import '../screens/address.dart';



class EditProfilePage extends StatefulWidget {
  final User? user; // Add user parameter

  const EditProfilePage({super.key, this.user});
  @override
  _EditProfilePageState createState()=> _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  String? _imagePath;
  User? _currentUser;
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _mobileController = TextEditingController();
  final _hairTypeController = TextEditingController();
  final _hairColorController = TextEditingController();
  final _bodyTypeController = TextEditingController();
  final _maritalStatusController = TextEditingController();
  final _genderController = TextEditingController();
  final _bioController = TextEditingController();
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();final _interestController = TextEditingController();
  final _professionController = TextEditingController();
  final _hobbiesController = TextEditingController();
  final _facebookUrlController = TextEditingController();
  final _instagramUrlController = TextEditingController();
  final _tiktokUrlController = TextEditingController();
  DateTime? _dateOfBirth;
  late Box<User> _userBox;

  @override
  void initState() {
    super.initState();
    _openHiveBox().then((_) => _fetchUserData()); // Call _fetchUserData after _openHiveBox completes
  }

  Future<void> _openHiveBox() async {
    _userBox = await Hive.openBox<User>('users');
  }

  Future<void> _fetchUserData() async {
    // Assuming you store the user with a key 'currentUser'
    _currentUser = _userBox.get('currentUser');

    _currentUser ??= User(
        firstName: '',
        lastName: '',
        email: '',
        mobile: '',
        bio: '',
        educationList: [],
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

    _firstNameController.text = _currentUser!.firstName;
    _lastNameController.text = _currentUser!.lastName;
    _emailController.text = _currentUser!.email;
    _mobileController.text = _currentUser!.mobile;
    _hairTypeController.text = _currentUser!.hairType;
    _hairColorController.text = _currentUser!.hairColor;
    _bodyTypeController.text = _currentUser!.bodyType;
    _maritalStatusController.text = _currentUser!.maritialStatus;
    _genderController.text = _currentUser!.gender;
    _bioController.text = _currentUser!.bio;
    _interestController.text = _currentUser!.interest;
    _facebookUrlController.text = _currentUser!.facebook;
    _instagramUrlController.text = _currentUser!.instagram;
    _tiktokUrlController.text = _currentUser!.tiktok;
    _dateOfBirth = _currentUser!.dateOfBirthInMillis != null
        ? DateTime.fromMillisecondsSinceEpoch(_currentUser!.dateOfBirthInMillis!)
        : null;

    setState(() {});
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _mobileController.dispose();
    _hairTypeController.dispose();
    _hairColorController.dispose();
    _bodyTypeController.dispose();
    _maritalStatusController.dispose();
    _genderController.dispose();
    _bioController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    _interestController.dispose();
    _professionController.dispose();
    _hobbiesController.dispose();
    _facebookUrlController.dispose();
    _instagramUrlController.dispose();
    _tiktokUrlController.dispose();
    _userBox.close(); // Close the Hive box when the widget is disposed
    super.dispose();
  }

  Future<void> _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      // Update the User object with data from controllers
      _currentUser !.firstName = _firstNameController.text;
      _currentUser !.lastName = _lastNameController.text;
      _currentUser !.email = _emailController.text;
      _currentUser !.mobile = _mobileController.text;
      _currentUser !.hairType = _hairTypeController.text;
      _currentUser !.hairColor = _hairColorController.text;
      _currentUser !.bodyType = _bodyTypeController.text;
      _currentUser !.maritialStatus = _maritalStatusController.text;
      _currentUser !.gender = _genderController.text;
      _currentUser !.bio = _bioController.text;
      _currentUser !.interest = _interestController.text;
      _currentUser !.facebook = _facebookUrlController.text;
      _currentUser !.instagram = _instagramUrlController.text;
      _currentUser !.tiktok = _tiktokUrlController.text;
      _currentUser !.dateOfBirthInMillis = _dateOfBirth?.millisecondsSinceEpoch;

      // Save user data using the UsernamePage's saveUser Data method
      UsernamePage.of(context)?.saveUserData(_currentUser !);

      // Update the Hive box with the current user
      await _userBox.put('currentUser', _currentUser!.toMap() as User);
      Navigator.pop(context, _currentUser);
    } else {
      // Handle case where _currentUser  is null (e.g., show an error message)
      print('Error: _currentUser  is null');
    }
  }


  void showHairTypeBottomSheet(BuildContext context) {
    showModalBottomSheet(backgroundColor: Colors.white,
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: 200, // Adjust height as neededcolor: Colors.white,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Expanded(
                child: CupertinoPicker(backgroundColor: Colors.white,
                  itemExtent: 27, // Adjust item height as needed
                  onSelectedItemChanged: (int index){
                    // Update the selected hair type
                    _hairTypeController.text = hairTypes[index];
                  },
                  children: hairTypes.map((hairType) => Text(hairType)).toList(),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: 100,
                height: 30,
                child: DecoratedBox( // Use DecoratedBox for background and border
                  decoration: BoxDecoration(
                    color: Colors.amber,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: InkWell( // Use InkWell for tap functionality
                    onTap: () => Navigator.pop(context),
                    child: const Center( // Center the text
                      child: Text(
                        'Save',
                        style: TextStyle(
                          color: Colors.black, // Set text color to black
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

            ],
          ),
        );
      },
    );
  }
  final List<String> hairTypes = ['Curly', 'Straight'];
  void _showHairColorBottomSheet(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: 200,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Expanded(
                child: CupertinoPicker(
                  backgroundColor: Colors.white,
                  itemExtent: 27,
                  onSelectedItemChanged: (int index) {
                    _hairColorController.text = hairColors[index];
                  },
                  children: hairColors.map((hairColor) => Text(hairColor)).toList(),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: 100,
                height: 30,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.amber,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: InkWell(
                    onTap: () => Navigator.pop(context),
                    child: const Center(
                      child: Text(
                        'Save',
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }
  final List<String> hairColors = ['Brown', 'Black', 'Blue', 'Green'];
  void _showBodyTypeBottomSheet(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: 200,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Expanded(
                child: CupertinoPicker(
                  backgroundColor: Colors.white,
                  itemExtent: 27,
                  onSelectedItemChanged: (int index) {
                    _bodyTypeController.text = bodyTypes[index];
                  },
                  children: bodyTypes.map((bodyType) => Text(bodyType)).toList(),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: 100,
                height: 30,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.amber,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: InkWell(
                    onTap: () => Navigator.pop(context),
                    child: const Center(
                      child: Text(
                        'Save',
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }
  final List<String> bodyTypes = ['Skinny', 'Fat'];
  void _showMaritalStatusBottomSheet(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: 200,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Expanded(
                child: CupertinoPicker(
                  backgroundColor: Colors.white,
                  itemExtent: 27,
                  onSelectedItemChanged: (int index) {
                    _maritalStatusController.text = maritalStatuses[index];
                  },
                  children: maritalStatuses.map((status) => Text(status)).toList(),),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: 100,
                height: 30,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.amber,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: InkWell(
                    onTap: () => Navigator.pop(context),
                    child: const Center(
                      child: Text(
                        'Save',
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }
  final List<String> maritalStatuses = ['Single', 'Married', 'Divorced'];
  void _showGenderBottomSheet(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: 200,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Expanded(
                child: CupertinoPicker(
                  backgroundColor: Colors.white,
                  itemExtent: 27,
                  onSelectedItemChanged: (int index) {
                    _genderController.text = genders[index];
                  },
                  children: genders.map((gender) => Text(gender)).toList(),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: 100,
                height: 30,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.amber,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: InkWell(
                    onTap: () => Navigator.pop(context),
                    child: const Center(
                      child: Text(
                        'Save',
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

// Define genders
  final List<String> genders = ['Male', 'Female', 'Rather not to say'];
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            centerTitle:true ,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new),
              onPressed: () {Navigator.pop(context);
              },
            ),
            title: const Text('Edit Profile',
              style: TextStyle(
              color: Colors.black,
              fontFamily: "Comfortaa-VariableFont_wght",
              fontWeight: FontWeight.w500,
            ),),
          ),
          body: CustomScrollView(
            slivers: <Widget>[
              SliverPersistentHeader(
                delegate: _MyCombinedHeaderDelegate(
                  imagePath: _imagePath,
                  onTap: (){
                    _showChooseOptionDialog(context);
                  },
                ),
                pinned: true, // Keep the header visible even when scrolling
              ),
              SliverFillRemaining(
                child: TabBarView(
                  children: [
                    _buildPersonalTabContent(),
                    _buildEducationTabContent(),
                    _buildExperienceTabContent(),
                    _buildAddressTabContent()
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _addEducation(Education education) {
    setState(() {
      _currentUser!.educationList.add(education);
    });
    _saveProfile();
  }
    void _removeEducation(int index) {
      setState(() {
        _currentUser!.educationList.removeAt(index);
      });
      _saveProfile();
    }

  void _addExperience(Experience experience) {
    setState(() {
      _currentUser!.experienceList.add(experience);
    });
    _saveProfile();
  }
  void _removeExperience(int index) {
    setState(() {
      _currentUser!.experienceList.removeAt(index);
    });
    _saveProfile();
  }

  void _addAddress(Address address) {
    setState(() {
      _currentUser!.addressList.add(address);
    });
    _saveProfile();
  }
  void _removeAddress(int index) {
    setState(() {
      _currentUser!.addressList.removeAt(index);
    });
    _saveProfile();
  }

  Widget _buildPersonalTabContent() {
    return Theme(
      data: ThemeData(
        inputDecorationTheme: InputDecorationTheme(
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey[500]!, width: 1.5),
            borderRadius: BorderRadius.circular(10.0),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey[500]!, width: 1.5),
            borderRadius: BorderRadius.circular(10.0),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey[500]!, width: 1.5),
            borderRadius: BorderRadius.circular(10.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey[500]!, width: 1.5),
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
      ),
      child: ListView(
          children: [
         Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 15),
                TextFormField(
                  controller: _firstNameController,
                  decoration: const InputDecoration(
                    labelText: 'First Name',
                    labelStyle: TextStyle(color: Colors.black, fontSize: 12),
                    hintText: 'First Name',
                    hintStyle: TextStyle(fontSize: 12),
                    filled: true,
                    fillColor: Colors.white,contentPadding:
                  EdgeInsets.symmetric(vertical: 0, horizontal: 16.0),
                  ),
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: _lastNameController,
                  decoration: const InputDecoration(
                    labelText: 'Last Name',
                    labelStyle: TextStyle(color: Colors.black, fontSize: 12),
                    hintText: 'Last Name',
                    hintStyle: TextStyle(fontSize: 12),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding:
                    EdgeInsets.symmetric(vertical: 0, horizontal: 16.0),
                  ),
                ),
                const SizedBox(height: 15),
                TextFormField( // New TextFormField for email
                  controller: _emailController, // Add a controller for email
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    labelStyle: TextStyle(color: Colors.black, fontSize: 12),
                    hintText: 'Email',
                    hintStyle: TextStyle(fontSize: 12),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: EdgeInsets.symmetric(
                        vertical: 0, horizontal: 16.0),
                  ),
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: _mobileController, // Add a controller for mobile number
                  decoration: const InputDecoration(
                    labelText: 'Mobile Number',
                    labelStyle: TextStyle(color: Colors.black, fontSize: 12),
                    hintText: 'Mobile Number',
                    hintStyle: TextStyle(fontSize: 12),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 16.0),
                  ),
                  keyboardType: TextInputType.phone, // Show numeric keyboard
                ),
                const SizedBox(height: 15),
                GestureDetector(
                  onTap: () async {
                    final DateTime? pickedDate = await showCupertinoModalPopup<DateTime>(
                      context: context,builder: (BuildContext context) {
                      return ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20.0),
                          topRight: Radius.circular(20.0),
                        ),
                        child: Container(
                          height: 200,
                          color: Colors.white,
                          child: CupertinoDatePicker(
                            mode: CupertinoDatePickerMode.date,
                            initialDateTime: _dateOfBirth ?? DateTime.now(),
                            onDateTimeChanged: (DateTime newDate) {
                              // Update _dateOfBirthController here
                              setState(() {
                                _dateOfBirth = newDate;
                              });
                            },
                          ),
                        ),
                      );
                    },
                    );

                    // Update _dateOfBirthController after the dialog is closed
                    if (pickedDate != null) {
                      setState(() {
                        _dateOfBirth = pickedDate;
                      });
                    }
                  },
                  child: AbsorbPointer(
                    child: TextFormField(
                      initialValue: _dateOfBirth != null
                          ? '${_dateOfBirth!.year}-${_dateOfBirth!.month}-${_dateOfBirth!.day}'
                          : null,
                      decoration: const InputDecoration(
                        labelText: 'Date of Birth',
                        labelStyle: TextStyle(color: Colors.black, fontSize: 12),
                        hintText: 'Date of Birth',
                        hintStyle: TextStyle(fontSize: 12),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 16.0),
                        suffixIcon: Icon(Icons.calendar_today),
                      ),
                      readOnly: true,
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                GestureDetector(
                  onTap: () => showHairTypeBottomSheet(context),
                  child: AbsorbPointer(
                    child: TextFormField(
                      controller: _hairTypeController,
                      decoration: const InputDecoration(
                        labelText: 'Hair Type',
                        labelStyle: TextStyle(color: Colors.black, fontSize: 12),
                        hintText: 'Hair Type',
                        hintStyle: TextStyle(fontSize:12),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 16.0),
                        suffixIcon: Icon(Icons.keyboard_arrow_down_sharp), // Add dropdown arrow
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                GestureDetector(
                  onTap: () => _showHairColorBottomSheet(context),
                  child: AbsorbPointer(child: TextFormField(
                    controller: _hairColorController,
                    decoration: const InputDecoration(
                      labelText: 'Hair Color',
                      labelStyle: TextStyle(color: Colors.black, fontSize: 12),
                      hintText: 'Hair Color',
                      hintStyle: TextStyle(fontSize: 12),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 16.0),
                      suffixIcon: Icon(Icons.keyboard_arrow_down_sharp),
                    ),
                  ),
                  ),
                ),
                const SizedBox(height: 15),
                GestureDetector(
                  onTap: () => _showBodyTypeBottomSheet(context),
                  child: AbsorbPointer(
                    child: TextFormField(
                      controller: _bodyTypeController,
                      decoration: const InputDecoration(
                        labelText: 'Body Type',
                        labelStyle: TextStyle(color: Colors.black, fontSize: 12),
                        hintText: 'Body Type',
                        hintStyle: TextStyle(fontSize: 12),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 16.0),
                        suffixIcon: Icon(Icons.keyboard_arrow_down_sharp),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                GestureDetector(
                  onTap: () => _showMaritalStatusBottomSheet(context),
                  child: AbsorbPointer(
                    child: TextFormField(
                      controller: _maritalStatusController,
                      decoration: const InputDecoration(
                        labelText: 'Marital Status',
                        labelStyle: TextStyle(color: Colors.black, fontSize: 12),
                        hintText: 'Marital Status',
                        hintStyle: TextStyle(fontSize: 12),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 16.0),
                        suffixIcon: Icon(Icons.keyboard_arrow_down_sharp),
                      ),
                    ),
                  ),
                    // ... add 15 more TextFormField widgets ...
                ),
                const SizedBox(height: 15),
                GestureDetector(
                  onTap: () => _showGenderBottomSheet(context),
                  child: AbsorbPointer(
                    child: TextFormField(
                      controller: _genderController,decoration: const InputDecoration(
                      labelText: 'Gender',
                      labelStyle: TextStyle(color: Colors.black, fontSize: 12),
                      hintText: 'Gender',
                      hintStyle: TextStyle(fontSize: 12),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 16.0),
                      suffixIcon: Icon(Icons.keyboard_arrow_down_sharp),
                    ),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: _bioController, // Use a different controller for bio
                  decoration: const InputDecoration(
                    labelText: 'Bio', // Change label to "Bio"
                    labelStyle: TextStyle(color: Colors.black, fontSize:12),
                    hintText: 'Bio', // Change hint to "Bio"
                    hintStyle: TextStyle(fontSize: 12),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 16.0),
                  ),
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: _weightController, // Use a different controller for weight
                  decoration: const InputDecoration(
                    labelText: 'Weight(kg)', // Change label to "Weight(kg)"
                    labelStyle:TextStyle(color: Colors.black, fontSize: 12),
                    hintText: 'Weight(kg)', // Change hint to "Weight(kg)"
                    hintStyle: TextStyle(fontSize: 12),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 16.0),
                  ),
                  keyboardType: TextInputType.number, // Set keyboard type to number
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: _heightController, // Use a different controller for height
                  decoration: const InputDecoration(
                    labelText: 'Height(cm)', // Change label to "Height(cm)"
                    labelStyle:TextStyle(color: Colors.black, fontSize: 12),
                    hintText: 'Height(cm)', // Change hint to "Height(cm)"
                    hintStyle: TextStyle(fontSize: 12),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 16.0),
                  ),
                  keyboardType: TextInputType.number, // Set keyboard type to number
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: _interestController, // Use a different controller for interest
                  decoration: const InputDecoration(
                    labelText: 'Interest', // Change label to "Interest"
                    labelStyle: TextStyle(color: Colors.black, fontSize: 12),
                    hintText: 'Interest', // Change hint to "Interest"
                    hintStyle: TextStyle(fontSize: 12),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 16.0),
                  ),
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: _professionController, // Use a different controller for profession
                  decoration: const InputDecoration(
                    labelText: 'Profession', // Change label to "Profession"
                    labelStyle: TextStyle(color: Colors.black, fontSize: 12),
                    hintText: 'Profession', // Change hint to "Profession"
                    hintStyle: TextStyle(fontSize: 12),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 16.0),
                  ),
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: _hobbiesController, // Use a different controller for hobbies
                  decoration: const InputDecoration(
                    labelText: 'Hobbies', // Change label to "Hobbies"
                    labelStyle: TextStyle(color: Colors.black, fontSize: 12),
                    hintText: 'Hobbies', // Change hint to "Hobbies"
                    hintStyle: TextStyle(fontSize: 12),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 16.0),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 20.0, bottom: 20.0), // Addpadding
                  child: Center(
                    child: Text(
                      'Social Media',
                      style: TextStyle(
                        fontSize: 24.0, // Adjust font size as needed
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                TextFormField(
                  controller: _facebookUrlController,
                  decoration: const InputDecoration(
                    labelText: 'Facebook URL',
                    labelStyle: TextStyle(color: Colors.black, fontSize: 12),
                    hintText: 'Facebook URL',
                    hintStyle: TextStyle(fontSize: 12),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 16.0),
                  ),
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: _instagramUrlController,
                  decoration: const InputDecoration(
                    labelText: 'Instagram URL',
                    labelStyle: TextStyle(color: Colors.black, fontSize: 12),
                    hintText:'Instagram URL',
                    hintStyle: TextStyle(fontSize: 12),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 16.0),
                  ),
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: _tiktokUrlController,
                  decoration: const InputDecoration(
                    labelText: 'TikTok URL',
                    labelStyle: TextStyle(color: Colors.black, fontSize: 12),
                    hintText: 'TikTok URL',
                    hintStyle: TextStyle(fontSize: 12),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 16.0),
                  ),
                ),
                const SizedBox(height: 15),
                SizedBox(
                  width: double.infinity, // Make it as wide as the parent
                   height: 48.0, // Adjust height as needed
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.amber,
                      borderRadius: BorderRadius.circular(8.0), // Match text field border radius
                    ),
                    child: InkWell(
                      onTap: () {
                            if (_formKey.currentState!.validate()) {
                            _saveProfile();
                            Navigator.pop(context);
                            }
                      },
                      child: const Center(
                        child: Text(
                          'Save',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16.0, // Adjust font size as needed
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ]),
    );
  }
  Widget _buildEducationTabContent() {
    if (_currentUser == null || _currentUser!.educationList.isEmpty) {
      return Center(
        heightFactor: 1.5,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,children: [
          Image.asset('assets/education.png'),
          const SizedBox(height: 16.0),
          const Text(
            'No education added',
            style: TextStyle(fontSize: 18.0),
          ),
        ],
        ),
      );
    } else {
      return Stack(
        children: [
          ListView.builder(
            itemCount: _currentUser!.educationList.length,
            itemBuilder: (context, index) {
              final education = _currentUser!.educationList[index];
              return Padding(padding: const EdgeInsets.all(21.0),
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0),
                  ),
                  child: Container(
                    height: 350,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.black, width: 1),
                      borderRadius: BorderRadius.circular(0),
                    ),
                    child: Column(
                      children: [
                        Container(
                          decoration: const BoxDecoration(color: Colors.amberAccent),
                          width: double.infinity,
                          height: 80,
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.school, size: 60, color: Colors.black),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        Container(
                          height: 65,
                          color: Colors.grey[200],
                          padding: const EdgeInsets.symmetric(vertical: 8.0),child: Center(
                          child: Text(
                            'University: ${education.universityName ?? 'N/A'}',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                        ),
                        const SizedBox(height: 10.0),
                        Container(
                          height: 45,
                          color: Colors.grey[200],
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Center(
                            child: Text('Degree: ${education.degreeName ?? 'N/A'}'),
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: 150,
                                color: Colors.grey[200],
                                padding: const EdgeInsets.all(8.0),
                                child: Center(
                                  child: Text(
                                    'From: ${education.fromDateInMillis?.toString().split(' ')[0] ?? 'N/A'}',
                                    style: const TextStyle(fontSize: 15.0),
                                  ),
                                ),
                              ),
                              Container(
                                width: 150,
                                color: Colors.grey[200],
                                padding: const EdgeInsets.all(8.0),
                                child: Center(
                                  child: Text(
                                    'To: ${education.toDateInMillis?.toString().split(' ')[0] ?? 'N/A'}',
                                    style: const TextStyle(fontSize: 15.0),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 15.0),
                        ElevatedButton.icon(
                          onPressed: () {
                            _removeEducation(index);
                          },
                          icon: const Icon(Icons.delete),
                          label: const Text('Remove item'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                      ],),
                  ),
                ),
              );
            },
          ),
          Positioned(
            bottom: 16.0,
            right: 16.0,
            child: FloatingActionButton(
              onPressed: () async {
                final education = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AddNewEducationPage()),
                );
                if (education != null && education is Education) {
                  _addEducation(education);
                }
              },
              backgroundColor: Colors.black,
              shape: const CircleBorder(),
              child: const Icon(Icons.add, color: Colors.yellow),
            ),
          ),
        ],
      );
    }
  }
  Widget _buildExperienceTabContent() {
    if (_currentUser == null || _currentUser!.experienceList.isEmpty) {
      return Center(
        heightFactor: 1.5,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/education.png'), // Replace with your image path
            const SizedBox(height: 16.0),
            const Text(
              'No experience added',
              style: TextStyle(fontSize: 18.0),
            ),
          ],
        ),
      );
    } else {
      return Stack(
        children: [
          ListView.builder(
            itemCount: _currentUser!.experienceList.length,
            itemBuilder: (context, index) {
              final experience = _currentUser!.experienceList[index];
              return Padding(
                padding: const EdgeInsets.all(21.0),
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0),
                  ),
                  child: Container(
                    height: 350,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.black, width: 1),
                      borderRadius: BorderRadius.circular(0),
                    ),
                    child: Column(
                      children: [
                        Container(
                          decoration: const BoxDecoration(color: Colors.amberAccent),
                          width: double.infinity,
                          height: 80,
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.work, size: 60, color: Colors.black),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        // Custom layout using rows and containers
                        Container(
                          height: 65,
                          color: Colors.grey[200],
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Center(
                            child: Text(
                              'Position :: ${experience.position ?? 'N/A'}',
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        Container(
                          height: 45,
                          color: Colors.grey[200],
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Center(
                            child: Text('Degree: ${experience.city ?? 'N/A'}'),
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: 150,
                                color: Colors.grey[200],
                                padding: const EdgeInsets.all(8.0),
                                child: Center(
                                  child: Text(
                                    'From: ${experience.fromDateInMillis?.toString().split(' ')[0] ?? 'N/A'}',
                                    style: const TextStyle(fontSize: 15.0),
                                  ),
                                ),
                              ),
                              Container(
                                width: 150,
                                color: Colors.grey[200],
                                padding: const EdgeInsets.all(8.0),
                                child: Center(
                                  child: Text(
                                    'To: ${experience.toDateInMillis?.toString().split(' ')[0] ?? 'N/A'}',
                                    style: const TextStyle(fontSize: 15.0),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 15.0),
                        ElevatedButton.icon(
                          onPressed: () {
                            _removeExperience(index);
                          },
                          icon: const Icon(Icons.delete),
                          label: const Text('Remove item'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          Positioned(
            bottom: 16.0,
            right: 16.0,
            child: FloatingActionButton(
              onPressed: () async {
                final experience = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AddNewExperience()),
                );
                if (experience != null && experience is Experience) {
                  _addExperience(experience);
                }
              },
              backgroundColor: Colors.black,
              shape: const CircleBorder(),
              child: const Icon(Icons.add, color: Colors.yellow),
            ),
          ),
        ],
      );
    }
  }
  Widget _buildAddressTabContent() {
    if (_currentUser == null || _currentUser!.addressList.isEmpty) {
      return Center(
        heightFactor: 1.5,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/education.png'), // Replace with your image path
            const SizedBox(height: 16.0),
            const Text(
              'No address added',
              style: TextStyle(fontSize: 18.0),
            ),
          ],
        ),
      );
    } else {
      return Stack(
        children: [
          ListView.builder(
            itemCount: _currentUser!.addressList.length,
            itemBuilder: (context, index) {
              final address = _currentUser!.addressList[index];
              return Padding(
                padding: const EdgeInsets.all(21.0),
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0),
                  ),
                  child: Container(
                    height: 350,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.black, width: 1),
                      borderRadius: BorderRadius.circular(0),
                    ),
                    child: Column(
                      children: [
                        Container(
                          decoration: const BoxDecoration(color: Colors.amberAccent),
                          width: double.infinity,
                          height: 80,
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.location_city, size: 60, color: Colors.black),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        // Custom layout using rows and containers
                        Container(
                          height:65,
                          color: Colors.grey[200],
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Center(
                            child: Text(
                              'Address : ${address.address ?? 'N/A'}',
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        Container(
                          height: 45,
                          color: Colors.grey[200],
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Center(
                            child: Text('City: ${address.city ?? 'N/A'}'),
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: 150,
                                color: Colors.grey[200],
                                padding: const EdgeInsets.all(8.0),
                                child: Center(
                                  child: Text(
                                    ' ${address.street ?? 'N/A'}',
                                    style: const TextStyle(fontSize: 15.0),
                                  ),
                                ),
                              ),
                              Container(
                                width: 150,
                                color: Colors.grey[200],
                                padding: const EdgeInsets.all(8.0),
                                child: Center(
                                  child: Text(
                                    ' ${address.building ?? 'N/A'}',
                                    style: const TextStyle(fontSize: 15.0),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 15.0),
                        ElevatedButton.icon(
                          onPressed: () {
                            _removeAddress(index);
                          },
                          icon: const Icon(Icons.delete),
                          label: const Text('Remove item'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          Positioned(
            bottom: 16.0,
            right: 16.0,
            child: FloatingActionButton(
              onPressed: () async {
                final address = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AddNewAddress()),
                );
                if (address != null && address is Address) {
                  _addAddress(address);
                }
              },
              backgroundColor: Colors.black,
              shape: const CircleBorder(),
              child: const Icon(Icons.add, color: Colors.yellow),
            ),
          ),
        ],
      );
    }
  }




  Future<void> _pickImage(ImageSource source) async {
    if (source == ImageSource.camera) {
      await _requestCameraPermission();
    } else {
      await _requestStoragePermission();
    }

    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: source);
    if (pickedImage != null) {
      final directory = await getApplicationDocumentsDirectory();
      final imagePath = '${directory.path}/profile_image.jpg';

      final oldImageFile = File(imagePath);
      if (await oldImageFile.exists()) {
        await oldImageFile.delete();
      }

      final imageFile = File(pickedImage.path);
      await imageFile.copy(imagePath);

      setState(() {
        _imagePath = imagePath;
      });
    }
  }

  Future<void> _requestCameraPermission() async {
    final status = await Permission.camera.request();
    if (status.isPermanentlyDenied) {
      openAppSettings();
    }
  }

  Future<void> _requestStoragePermission() async {
    Permission permission = Permission.storage;
    if (Platform.isAndroid) {
      if (Platform.isAndroid &&
          int.parse(Platform.version.split('.')[0]) >= 13) {
        permission = Permission.photos;
      }
      if ((await permission.status).isPermanentlyDenied) {
        openAppSettings();
      } else {
        await permission.request();
      }
    } else if (Platform.isIOS) {
      if ((await permission.status).isPermanentlyDenied) {
        openAppSettings();
      } else {
        await permission.request();
      }
    }
  }

  void _showChooseOptionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Choose Option'),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                GestureDetector(child: const Text('Camera'),
                  onTap: () {
                    _pickImage(ImageSource.camera);
                    Navigator.of(context).pop();
                  },
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  child: const Text('Gallery'),
                  onTap: () {
                    _pickImage(ImageSource.gallery);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}


class _MyCombinedHeaderDelegate extends SliverPersistentHeaderDelegate {
  final String? imagePath;
  final VoidCallback onTap;

  const _MyCombinedHeaderDelegate({required this.imagePath, required this.onTap});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.white, // Set page background to white
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(11.0),
            child: Center(
              child: SizedBox(
                height: 150,
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 75,
                      backgroundColor: Colors.grey[300], // Set circle background to grey
                      backgroundImage: imagePath != null
                          ? FileImage(File(imagePath!))
                          : const AssetImage('assets/images/profile_image.png'),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: onTap,
                        child: Container(
                          padding: const EdgeInsets.all(15),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.black,
                          ),
                          child: const Icon(Icons.camera_alt_outlined, color: Colors.yellow),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0,right: 8),
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                color: Colors.grey[300], // Set TabBar background to grey
                borderRadius: BorderRadius.circular(8), // Set border radius
              ),
              child: TabBar(dividerColor: Colors.white,
                indicator: BoxDecoration(
                  color: Colors.amberAccent, // Background color for the selected tab
                  borderRadius: BorderRadius.circular(8),
                ),
                indicatorPadding: const EdgeInsets.symmetric(horizontal: 0), // Control width of selected tab background
                indicatorSize: TabBarIndicatorSize.tab, // Ensure indicator fits the tab size
                labelPadding: const EdgeInsets.symmetric(horizontal: 8.0), // Additional padding to make indicator smaller
                labelStyle: const TextStyle(fontWeight: FontWeight.w600),
                labelColor: Colors.black, // Text color of selected tab
                unselectedLabelColor: Colors.black, // Text color of unselected tabs
                tabs: const [
                  Tab(text: 'Personal',),
                  Tab(text: 'Education'),
                  Tab(text: 'Experience'),
                  Tab(text: 'Address'),
                ],
              ),
            ),
          )

        ],
      ),
    );

  }


  @override
  double get maxExtent => 212;

  @override
  double get minExtent =>212;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return oldDelegate is _MyCombinedHeaderDelegate &&
        oldDelegate.imagePath != imagePath;
  }
}


