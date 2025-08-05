import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/planner_controller.dart';

class StudyInputSection extends StatelessWidget {
  StudyInputSection({super.key});

  final AIStudyPlannerController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'What would you like to study?',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade800,
            ),
          ),
          const SizedBox(height: 16),
          
          // Subject Input
          _buildTextField(
            controller: controller.subjectController,
            label: 'Subject',
            hint: 'e.g., Java Programming, Discrete Mathematics, ',
            icon: Icons.book,
          ),
          const SizedBox(height: 16),
          
          // Topics Input
          _buildTextField(
            controller: controller.topicsController,
            label: 'Specific Topics (Optional)',
            hint: 'e.g., Classes, Inheritance, Polymorphism',
            icon: Icons.topic,
            maxLines: 2,
          ),
          const SizedBox(height: 24),
          
          // Current State Selectors
          Text(
            'How are you feeling right now?',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade800,
            ),
          ),
          const SizedBox(height: 16),
          
          // Mood Selector
          _buildMoodSelector(),
          const SizedBox(height: 16),
          
          // Focus Level Selector
          _buildFocusSelector(),
          const SizedBox(height: 16),
          
          // Difficulty and Skill Row
          Row(
            children: [
              Expanded(child: _buildDifficultySelector()),
              const SizedBox(width: 16),
              Expanded(child: _buildSkillSelector()),
            ],
          ),
          const SizedBox(height: 24),
          
          // Generate Button
          Obx(() => SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: controller.isGenerating.value 
                  ? null 
                  : controller.generateRecommendations,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade600,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: controller.isGenerating.value
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Text('Generating AI Recommendations...'),
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.psychology, size: 20),
                        const SizedBox(width: 8),
                        const Text(
                          'Get AI Study Plan',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade700,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, color: Colors.grey.shade500),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.blue.shade400, width: 2),
            ),
            filled: true,
            fillColor: Colors.grey.shade50,
          ),
        ),
      ],
    );
  }

  Widget _buildMoodSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Current Mood',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade700,
          ),
        ),
        const SizedBox(height: 8),
        Obx(() => Wrap(
          spacing: 8,
          children: StudyMood.values.map((mood) {
            final isSelected = controller.selectedMood.value == mood;
            return ChoiceChip(
              label: Text(
                '${controller.getMoodEmoji(mood)} ${mood.name.capitalize}',
              ),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) controller.selectedMood.value = mood;
              },
              selectedColor: Colors.blue.shade100,
              checkmarkColor: Colors.blue.shade700,
            );
          }).toList(),
        )),
      ],
    );
  }

  Widget _buildFocusSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Focus Level',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade700,
          ),
        ),
        const SizedBox(height: 8),
        Obx(() => Wrap(
          spacing: 8,
          children: FocusLevel.values.map((focus) {
            final isSelected = controller.selectedFocus.value == focus;
            return ChoiceChip(
              label: Text(
                '${controller.getFocusEmoji(focus)} ${focus.name.capitalize}',
              ),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) controller.selectedFocus.value = focus;
              },
              selectedColor: Colors.green.shade100,
              checkmarkColor: Colors.green.shade700,
            );
          }).toList(),
        )),
      ],
    );
  }

  Widget _buildDifficultySelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Difficulty',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade700,
          ),
        ),
        const SizedBox(height: 8),
        Obx(() => DropdownButtonFormField<DifficultyLevel>(
          value: controller.selectedDifficulty.value,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
          items: DifficultyLevel.values.map((difficulty) {
            return DropdownMenuItem(
              value: difficulty,
              child: Text(difficulty.name.capitalize!),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) controller.selectedDifficulty.value = value;
          },
        )),
      ],
    );
  }

  Widget _buildSkillSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Skill Level',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade700,
          ),
        ),
        const SizedBox(height: 8),
        Obx(() => DropdownButtonFormField<SkillLevel>(
          value: controller.selectedSkill.value,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
          items: SkillLevel.values.map((skill) {
            return DropdownMenuItem(
              value: skill,
              child: Text(skill.name.capitalize!),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) controller.selectedSkill.value = value;
          },
        )),
      ],
    );
  }
}