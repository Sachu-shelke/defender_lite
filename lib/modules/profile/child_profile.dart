import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../home/home_screen.dart';

class ChildProfileScreen extends StatelessWidget {
  final box = GetStorage();

  final avatars = [
    'assets/avatar/avatar_1.jpg',
    'assets/avatar/avatar_2.jpeg',
    'assets/avatar/avatar_3.jpeg',
    'assets/avatar/avatar_4.jpeg',
    'assets/avatar/avatar_5.jpeg',
    'assets/avatar/avatar_6.jpeg',
    'assets/avatar/avatar_7.jpeg',
    'assets/avatar/avatar_8.jpeg',
  ];

  final RxString selectedAvatar = ''.obs;
  final RxString name = ''.obs;
  final RxString selectedYear = '2010'.obs;
  final RxString selectedMonth = 'January'.obs;
  final TextEditingController nameController = TextEditingController();

  ChildProfileScreen() {
    _loadProfileData();
  }

  void _loadProfileData() {
    selectedAvatar.value = box.read('childAvatar') ?? '';
    name.value = box.read('childName') ?? '';
    selectedYear.value = box.read('childYear') ?? '2010';
    selectedMonth.value = box.read('childMonth') ?? 'January';
    nameController.text = name.value;
  }

  void _saveProfileData() {
    if (selectedAvatar.isNotEmpty && name.value.isNotEmpty) {
      box.write('childAvatar', selectedAvatar.value);
      box.write('childName', name.value);
      box.write('childYear', selectedYear.value);
      box.write('childMonth', selectedMonth.value);
      box.write('hasProfileCompleted', true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 30),
            const Center(
              child: Text(
                "Child's Profile",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),

            /// Avatar Selection
            const Text('Select Avatar'),
            const SizedBox(height: 10),

            Obx(() => selectedAvatar.isNotEmpty
                ? CircleAvatar(radius: 50, backgroundImage: AssetImage(selectedAvatar.value))
                : const SizedBox()),

            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: avatars.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => selectedAvatar.value = avatars[index],
                  child: Obx(
                        () => Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: selectedAvatar.value == avatars[index] ? Colors.blue : Colors.transparent,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: Image.asset(avatars[index], fit: BoxFit.cover),
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),

            /// Name Input Field
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                hintText: "Enter child's name",
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => name.value = value,
            ),
            const SizedBox(height: 20),

            /// Date of Birth
            const Text('Date of Birth'),
            Row(
              children: [
                Expanded(
                  child: Obx(
                        () => DropdownButtonFormField<String>(
                      value: selectedYear.value,
                      decoration: const InputDecoration(border: OutlineInputBorder()),
                      items: List.generate(25, (index) => (2000 + index).toString()).map((String value) {
                        return DropdownMenuItem<String>(value: value, child: Text(value));
                      }).toList(),
                      onChanged: (String? newValue) => selectedYear.value = newValue!,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Obx(
                        () => DropdownButtonFormField<String>(
                      value: selectedMonth.value,
                      decoration: const InputDecoration(border: OutlineInputBorder()),
                      items: [
                        'January', 'February', 'March', 'April', 'May', 'June',
                        'July', 'August', 'September', 'October', 'November', 'December'
                      ].map((String value) {
                        return DropdownMenuItem<String>(value: value, child: Text(value));
                      }).toList(),
                      onChanged: (String? newValue) => selectedMonth.value = newValue!,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            /// Done Button
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                  ),
                  onPressed: () {
                    _saveProfileData();
                    Get.offAll(() => HomeScreen());
                  },
                  child: const Text(
                    'Done',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
