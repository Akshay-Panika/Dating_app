import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../../dashboard/screen/dashboard_screen.dart';

class CoupleInfoScreen extends StatefulWidget {
  const CoupleInfoScreen({super.key});

  @override
  State<CoupleInfoScreen> createState() => _CoupleInfoScreenState();
}

class _CoupleInfoScreenState extends State<CoupleInfoScreen> {
  final _formKey = GlobalKey<FormState>();
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // Partner 1 Controllers
  final TextEditingController _partner1NameController = TextEditingController();
  final TextEditingController _partner1AgeController = TextEditingController();
  String _partner1Gender = 'Male';
  DateTime? _partner1DOB;
  File? _partner1ProfilePic;

  bool _isLoading = false;

  @override
  void dispose() {
    _partner1NameController.dispose();
    _partner1AgeController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _selectProfilePicture() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Choose Profile Picture',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.camera_alt, color: Colors.pink),
              title: const Text('Take Photo'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library, color: Colors.pink),
              title: const Text('Choose from Gallery'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
            if (_partner1ProfilePic != null)
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text('Remove Photo'),
                onTap: () {
                  Navigator.pop(context);
                  setState(() {
                    _partner1ProfilePic = null;
                  });
                },
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await ImagePicker().pickImage(source: source);
      if (image != null) {
        setState(() {
          _partner1ProfilePic = File(image.path);
        });
      }
    } catch (e) {
      print("Image pick error: $e");
    }
  }


  void _nextPage() {
    if (_currentPage == 0) {
      // Validate Partner 1 info
      if (_partner1NameController.text.isEmpty ||
          _partner1AgeController.text.isEmpty ||
          _partner1DOB == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please fill all Partner 1 details')),
        );
        return;
      }
    }

    if (_currentPage < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> _selectDate(BuildContext context, bool isPartner1) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 6570)), // 18 years ago
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.pink,
              onPrimary: Colors.white,
              surface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        if (isPartner1) {
          _partner1DOB = picked;
          _partner1AgeController.text = _calculateAge(picked).toString();
        } else {

        }
      });
    }
  }


  int _calculateAge(DateTime birthDate) {
    DateTime today = DateTime.now();
    int age = today.year - birthDate.year;
    if (today.month < birthDate.month ||
        (today.month == birthDate.month && today.day < birthDate.day)) {
      age--;
    }
    return age;
  }

  void _submitForm() {
    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        // Navigate to DashboardScreen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const DashboardScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: _currentPage > 0
            ? IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: _previousPage,
        )
            : null,
        title: const Text(
          'Create Your Profile',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Progress Indicator
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              children: List.generate(3, (index) {
                return Expanded(
                  child: Container(
                    height: 4,
                    margin: EdgeInsets.only(right: index < 2 ? 8 : 0),
                    decoration: BoxDecoration(
                      color: index <= _currentPage ? Colors.pink : Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                );
              }),
            ),
          ),

          // PageView
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              children: [
                _buildBasicInfoForm(),
                _buildIntranetInSeeing(),
                Center(child: Text('Welcome')),
              ],
            ),
          ),

          // Bottom Button
          Padding(
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: _isLoading
                    ? null
                    : (_currentPage == 2 ? _submitForm : _nextPage),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pink,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: _isLoading
                    ? const SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
                    : Text(
                  _currentPage == 2 ? 'Submit Profile' : 'Continue',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBasicInfoForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Tell us about yourself',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),

          const SizedBox(height: 30),

          // Profile Picture
          Center(
            child: Stack(
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey[200],
                    border: Border.all(
                      color: Colors.pink.withOpacity(0.3),
                      width: 3,
                    ),
                  ),
                  child: _partner1ProfilePic == null
                      ? Icon(Icons.person, size: 60, color: Colors.grey)
                      : ClipOval(
                    child: Image.file(
                      _partner1ProfilePic!,
                      fit: BoxFit.cover,
                      width: 120,
                      height: 120,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: InkWell(
                    onTap: _selectProfilePicture,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.pink,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white,
                          width: 3,
                        ),
                      ),
                      child: const Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),

          // Name Field
          _buildTextField(
            controller: _partner1NameController,
            label: 'Full Name',
            hint: 'Enter your name',
            icon: Icons.person_outline,
          ),

          const SizedBox(height: 20),

          // Gender Selection
          _buildLabel('Gender'),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _buildGenderChip('Male', _partner1Gender == 'Male', () {
                  setState(() => _partner1Gender = 'Male');
                }),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildGenderChip('Female', _partner1Gender == 'Female', () {
                  setState(() => _partner1Gender = 'Female');
                }),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildGenderChip('Other', _partner1Gender == 'Other', () {
                  setState(() => _partner1Gender = 'Other');
                }),
              ),
            ],
          ),

          const SizedBox(height: 20),

          Row(
            children: [
              // LEFT SECTION (Date of Birth Picker)
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabel('Date of Birth'),
                    const SizedBox(height: 10),

                    InkWell(
                      onTap: () => _selectDate(context, true),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          border: Border.all(color: Colors.grey[300]!),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.cake_outlined, color: Colors.grey[600]),
                            const SizedBox(width: 12),
                            Text(
                              _partner1DOB == null
                                  ? 'Select your date of birth'
                                  : '${_partner1DOB!.day}/${_partner1DOB!.month}/${_partner1DOB!.year}',
                              style: TextStyle(
                                fontSize: 15,
                                color: _partner1DOB == null ? Colors.grey[400] : Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 16),

              // RIGHT SECTION (Auto Age)
              Expanded(
                flex: 1,
                child: _buildTextField(
                  controller: _partner1AgeController,
                  label: 'Age',
                  hint: 'Age',
                  icon: Icons.calendar_today_outlined,
                  readOnly: true,
                ),
              ),
            ],
          )

        ],
      ),
    );
  }

  Widget _buildIntranetInSeeing() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Who are you interested in seeing?',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          const Text(
            'Select all that apply to help us recommend the right people for you.',
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),

          const SizedBox(height: 30),

          _buildInterestOption('Men'),
          const SizedBox(height: 12),

          _buildInterestOption('Women'),
          const SizedBox(height: 12),

          _buildInterestOption('Beyond Binary'),
          const SizedBox(height: 12),

          _buildInterestOption('Everyone'),

          const SizedBox(height: 30),

        ],
      ),
    );
  }
  Widget _buildInterestOption(String label) {
    bool isSelected = false;

    return StatefulBuilder(
      builder: (context, setStateSB) {
        return InkWell(
          onTap: () {
            setStateSB(() => isSelected = !isSelected);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            decoration: BoxDecoration(
              color: isSelected ? Colors.pink.withOpacity(0.15) : Colors.grey[50],
              border: Border.all(
                color: isSelected ? Colors.pink : Colors.grey[300]!,
                width: isSelected ? 2 : 1,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(
                  isSelected ? Icons.check_circle : Icons.circle_outlined,
                  color: isSelected ? Colors.pink : Colors.grey,
                  size: 22,
                ),
                const SizedBox(width: 12),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? Colors.pink : Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    bool readOnly = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(label),
        const SizedBox(height: 10),
        TextFormField(
          controller: controller,
          readOnly: readOnly,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey[400]),
            prefixIcon: Icon(icon, color: Colors.grey[600]),
            filled: true,
            fillColor: Colors.grey[50],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.pink, width: 2),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Colors.grey[700],
      ),
    );
  }

  Widget _buildGenderChip(String label, bool isSelected, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.pink : Colors.grey[50],
          border: Border.all(
            color: isSelected ? Colors.pink : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isSelected ? Colors.white : Colors.grey[700],
            ),
          ),
        ),
      ),
    );
  }
}