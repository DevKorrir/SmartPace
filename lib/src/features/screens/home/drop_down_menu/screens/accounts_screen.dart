import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/account_controller.dart';

class AccountScreen extends StatelessWidget {
  final AccountController accountController = Get.put(AccountController());

  AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => Get.toNamed('/edit-profile'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  Obx(() => CircleAvatar(
                    radius: 50,
                    backgroundImage: accountController.profileImageUrl.value.isNotEmpty
                        ? NetworkImage(accountController.profileImageUrl.value)
                        : null,
                    child: accountController.profileImageUrl.value.isEmpty
                        ? const Icon(Icons.person, size: 50, color: Colors.white)
                        : null,
                  )),
                  const SizedBox(height: 16),
                  Obx(() => Text(
                    accountController.userName.value,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  )),
                  const SizedBox(height: 8),
                  Obx(() => Text(
                    accountController.userEmail.value,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  )),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => _showEditProfileDialog(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Theme.of(context).primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text('Edit Profile'),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Account Information
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Account Information',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  _buildInfoCard(
                    icon: Icons.person,
                    title: 'Full Name',
                    value: accountController.userName.value,
                    onTap: () => _editField('name'),
                  ),
                  
                  _buildInfoCard(
                    icon: Icons.email,
                    title: 'Email',
                    value: accountController.userEmail.value,
                    onTap: () => _editField('email'),
                  ),
                  
                  _buildInfoCard(
                    icon: Icons.phone,
                    title: 'Phone',
                    value: accountController.userPhone.value.isEmpty 
                        ? 'Not provided' 
                        : accountController.userPhone.value,
                    onTap: () => _editField('phone'),
                  ),
                  
                  _buildInfoCard(
                    icon: Icons.school,
                    title: 'Institution',
                    value: accountController.userInstitution.value.isEmpty 
                        ? 'Not provided' 
                        : accountController.userInstitution.value,
                    onTap: () => _editField('institution'),
                  ),
                  
                  _buildInfoCard(
                    icon: Icons.class_,
                    title: 'Study Level',
                    value: accountController.studyLevel.value.isEmpty 
                        ? 'Not specified' 
                        : accountController.studyLevel.value,
                    onTap: () => _editField('studyLevel'),
                  ),

                  const SizedBox(height: 24),

                  // Account Actions
                  const Text(
                    'Account Actions',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(height: 16),

                  _buildActionCard(
                    icon: Icons.lock,
                    title: 'Change Password',
                    subtitle: 'Update your account password',
                    onTap: () => _showChangePasswordDialog(),
                  ),

                  _buildActionCard(
                    icon: Icons.security,
                    title: 'Privacy Settings',
                    subtitle: 'Manage your privacy preferences',
                    onTap: () => Get.toNamed('/privacy-settings'),
                  ),

                  _buildActionCard(
                    icon: Icons.notifications,
                    title: 'Notification Preferences',
                    subtitle: 'Customize your notifications',
                    onTap: () => Get.toNamed('/notification-settings'),
                  ),

                  _buildActionCard(
                    icon: Icons.download,
                    title: 'Download My Data',
                    subtitle: 'Export your account data',
                    onTap: () => accountController.exportUserData(),
                  ),

                  const SizedBox(height: 24),

                  // Danger Zone
                  const Text(
                    'Danger Zone',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                  const SizedBox(height: 16),

                  _buildActionCard(
                    icon: Icons.delete_forever,
                    title: 'Delete Account',
                    subtitle: 'Permanently delete your account and data',
                    textColor: Colors.red,
                    onTap: () => _showDeleteAccountDialog(),
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String value,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon, color: Colors.blue),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
        subtitle: Text(value),
        trailing: const Icon(Icons.edit, size: 18),
        onTap: onTap,
      ),
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    Color? textColor,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon, color: textColor ?? Colors.blue),
        title: Text(
          title, 
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: textColor,
          ),
        ),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }

  void _showEditProfileDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text('Edit Profile'),
        content: const Text('Navigate to full profile editing screen?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.toNamed('/edit-profile');
            },
            child: const Text('Continue'),
          ),
        ],
      ),
    );
  }

  void _editField(String field) {
    final TextEditingController controller = TextEditingController();
    String currentValue = '';
    String fieldTitle = '';

    switch (field) {
      case 'name':
        currentValue = accountController.userName.value;
        fieldTitle = 'Full Name';
        break;
      case 'email':
        currentValue = accountController.userEmail.value;
        fieldTitle = 'Email';
        break;
      case 'phone':
        currentValue = accountController.userPhone.value;
        fieldTitle = 'Phone';
        break;
      case 'institution':
        currentValue = accountController.userInstitution.value;
        fieldTitle = 'Institution';
        break;
      case 'studyLevel':
        currentValue = accountController.studyLevel.value;
        fieldTitle = 'Study Level';
        break;
    }

    controller.text = currentValue;

    Get.dialog(
      AlertDialog(
        title: Text('Edit $fieldTitle'),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: fieldTitle,
            border: const OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              accountController.updateField(field, controller.text);
              Get.back();
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showChangePasswordDialog() {
    final TextEditingController currentPasswordController = TextEditingController();
    final TextEditingController newPasswordController = TextEditingController();
    final TextEditingController confirmPasswordController = TextEditingController();

    Get.dialog(
      AlertDialog(
        title: const Text('Change Password'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: currentPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Current Password',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: newPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'New Password',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: confirmPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Confirm New Password',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (newPasswordController.text == confirmPasswordController.text) {
                accountController.changePassword(
                  currentPasswordController.text,
                  newPasswordController.text,
                );
                Get.back();
              } else {
                Get.snackbar(
                  'Error',
                  'New passwords do not match',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                );
              }
            },
            child: const Text('Change'),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text('Delete Account'),
        content: const Text(
          'Are you sure you want to delete your account? This action cannot be undone and all your data will be permanently lost.',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              _confirmDeleteAccount();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _confirmDeleteAccount() {
    final TextEditingController passwordController = TextEditingController();

    Get.dialog(
      AlertDialog(
        title: const Text('Confirm Account Deletion'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Please enter your password to confirm account deletion:'),
            const SizedBox(height: 16),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              accountController.deleteAccount(passwordController.text);
              Get.back();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete Account', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}