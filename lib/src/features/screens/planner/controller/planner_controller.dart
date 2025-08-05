import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum StudyMood { energetic, calm, focused, tired }
enum FocusLevel { high, medium, low }
enum DifficultyLevel { easy, medium, hard }
enum SkillLevel { beginner, intermediate, advanced }

class StudyRecommendation {
  final String sessionTitle;
  final int durationMinutes;
  final String technique;
  final String description;
  final List<String> tips;
  final Color color;

  StudyRecommendation({
    required this.sessionTitle,
    required this.durationMinutes,
    required this.technique,
    required this.description,
    required this.tips,
    required this.color,
  });
}

class AIStudyPlannerController extends GetxController {
  // Form fields
  final subjectController = TextEditingController();
  final topicsController = TextEditingController();
  
  // Observable state
  var selectedMood = StudyMood.focused.obs;
  var selectedFocus = FocusLevel.medium.obs;
  var selectedDifficulty = DifficultyLevel.medium.obs;
  var selectedSkill = SkillLevel.intermediate.obs;
  
  var isGenerating = false.obs;
  var showRecommendations = false.obs;
  var recommendations = <StudyRecommendation>[].obs;
  var selectedRecommendation = Rxn<StudyRecommendation>();

  @override
  void onClose() {
    subjectController.dispose();
    topicsController.dispose();
    super.onClose();
  }

  void generateRecommendations() async {
    if (subjectController.text.trim().isEmpty) {
      Get.snackbar(
        'Subject Required',
        'Please enter the subject you want to study',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.orange.shade100,
        colorText: Colors.orange.shade800,
      );
      return;
    }

    isGenerating.value = true;
    showRecommendations.value = false;
    
    // Simulate AI processing
    await Future.delayed(const Duration(seconds: 2));
    
    recommendations.value = _generateAIRecommendations();
    selectedRecommendation.value = recommendations.first;
    
    isGenerating.value = false;
    showRecommendations.value = true;
  }

  List<StudyRecommendation> _generateAIRecommendations() {
    final subject = subjectController.text;
    final topics = topicsController.text;
    
    // AI logic simulation based on user inputs
    List<StudyRecommendation> recs = [];
    
    if (selectedMood.value == StudyMood.energetic && selectedFocus.value == FocusLevel.high) {
      recs.add(StudyRecommendation(
        sessionTitle: 'Intensive $subject Session',
        durationMinutes: 90,
        technique: 'Deep Work',
        description: 'Perfect for tackling challenging concepts when you\'re energetic and focused.',
        tips: [
          'Remove all distractions',
          'Take a 10-minute break every 45 minutes',
          'Focus on the most difficult topics first',
        ],
        color: Colors.red.shade400,
      ));
    }
    
    if (selectedMood.value == StudyMood.calm || selectedFocus.value == FocusLevel.low) {
      recs.add(StudyRecommendation(
        sessionTitle: 'Gentle $subject Review',
        durationMinutes: 45,
        technique: 'Spaced Repetition',
        description: 'Ideal for reviewing and reinforcing existing knowledge.',
        tips: [
          'Review previous notes and flashcards',
          'Use gentle background music',
          'Focus on memorization and recall',
        ],
        color: Colors.green.shade400,
      ));
    }
    
    if (selectedDifficulty.value == DifficultyLevel.hard) {
      recs.add(StudyRecommendation(
        sessionTitle: 'Challenging $subject Deep Dive',
        durationMinutes: 60,
        technique: 'Feynman Technique',
        description: 'Break down complex topics into simple explanations.',
        tips: [
          'Explain concepts in your own words',
          'Use analogies and examples',
          'Identify knowledge gaps',
        ],
        color: Colors.purple.shade400,
      ));
    }
    
    // Always add a Pomodoro option
    recs.add(StudyRecommendation(
      sessionTitle: '$subject Pomodoro Session',
      durationMinutes: 25,
      technique: 'Pomodoro Technique',
      description: 'Short, focused bursts with regular breaks for sustained productivity.',
      tips: [
        '25 minutes focused study',
        '5-minute break between sessions',
        'Complete 4 cycles, then take a longer break',
      ],
      color: Colors.blue.shade400,
    ));
    
    return recs;
  }

  void selectRecommendation(StudyRecommendation recommendation) {
    selectedRecommendation.value = recommendation;
  }

  void proceedToPlanning() {
    if (selectedRecommendation.value != null) {
      // Navigate to planning screen or show planning dialog
      Get.snackbar(
        'Success!',
        'Proceeding to plan your ${selectedRecommendation.value!.sessionTitle}',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green.shade100,
        colorText: Colors.green.shade800,
      );
      // TODO: Navigate to planning screen with recommendation data
    }
  }

  void skipToManualPlanning() {
    // Navigate directly to manual planning
    Get.snackbar(
      'Manual Planning',
      'Opening manual study planner...',
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.blue.shade100,
      colorText: Colors.blue.shade800,
    );
    // TODO: Navigate to original planner screen
  }

  void clearForm() {
    subjectController.clear();
    topicsController.clear();
    selectedMood.value = StudyMood.focused;
    selectedFocus.value = FocusLevel.medium;
    selectedDifficulty.value = DifficultyLevel.medium;
    selectedSkill.value = SkillLevel.intermediate;
    showRecommendations.value = false;
    recommendations.clear();
    selectedRecommendation.value = null;
  }

  String getMoodEmoji(StudyMood mood) {
    switch (mood) {
      case StudyMood.energetic:
        return '⚡';
      case StudyMood.calm:
        return '😌';
      case StudyMood.focused:
        return '🎯';
      case StudyMood.tired:
        return '😴';
    }
  }

  String getFocusEmoji(FocusLevel focus) {
    switch (focus) {
      case FocusLevel.high:
        return '🔥';
      case FocusLevel.medium:
        return '📊';
      case FocusLevel.low:
        return '💭';
    }
  }
}