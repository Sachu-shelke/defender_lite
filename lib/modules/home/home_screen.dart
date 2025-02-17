import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../basic_permission/basic_permission_screen.dart';
import '../basic_permission/mobile_permission.dart';
import '../binding/binding_screen.dart';
import '../call_log/call_log.dart';
import '../hide_icon/hide_icon_screen.dart';
import '../sms_calls/sms_calls_screen.dart';

class HomeController extends GetxController {
  final box = GetStorage();
  var hideIcon = false.obs;
  var hideNotifications = false.obs;

  @override
  void onInit() {
    super.onInit();
    hideIcon.value = box.read('hideIcon') ?? false;
    hideNotifications.value = box.read('hideNotifications') ?? false;
  }

  void toggleHideIcon(bool value) {
    hideIcon.value = value;
    box.write('hideIcon', value);
    if (value) Get.to(() => HideIconScreen());
  }

  void toggleHideNotifications(bool value) {
    hideNotifications.value = value;
    box.write('hideNotifications', value);
  }
}

class HomeScreen extends StatelessWidget {
  final HomeController controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    'HI',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 10),
                Center(
                  child: Image.asset(
                    'assets/sticker/family.png',
                    height: 150,
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(height: 15),
                Center(
                  child: Text(
                    'Supervision Mode enabled',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 5),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    'The guardian (abc1234@gmail.com) can manage how this device is used now.',
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 20),
                _buildOptionsCard(),
                SizedBox(height: 20),
                _buildNextButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOptionsCard() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        border: Border.all(color: Colors.grey),
      ),
      child: Column(
        children: [
          _buildListTile(
            icon: Icons.phone,
            title: 'Calls & SMS Monitoring',
            subtitle: 'Allow parents to monitor and manage calls and SMS',
            onTap: () => Get.to(() => SmsCalls_Screen()),
          ),
          Divider(),
          _buildListTile(
            icon: Icons.settings,
            title: 'Keep Running in Background',
            subtitle: 'To ensure Defender Kids\' features work properly',
            onTap: () => Get.to(() => BasicPermissionScreen()),
          ),
          Divider(),
          Obx(() => _buildSwitchTile(
            icon: Icons.visibility_off,
            title: 'Hide Icon',
            subtitle: 'Hide Defender Kids icon on this device',
            value: controller.hideIcon.value,
            onChanged: controller.toggleHideIcon,
          )),
          Divider(),
          Obx(() => _buildSwitchTile(
            icon: Icons.notifications_off,
            title: 'Hide System Notifications',
            subtitle: 'Turn off Defender Kids\' notifications to hide its existence',
            value: controller.hideNotifications.value,
            onChanged: controller.toggleHideNotifications,
          )),
        ],
      ),
    );
  }

  Widget _buildListTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: Icon(Icons.arrow_forward_ios_outlined),
      onTap: onTap,
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: Switch(value: value, onChanged: onChanged),
    );
  }

  Widget _buildNextButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
        ),
        onPressed: () => Get.to(() => PermissionsScreen()),
        child: Text(
          'Next',
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
      ),
    );
  }
}
