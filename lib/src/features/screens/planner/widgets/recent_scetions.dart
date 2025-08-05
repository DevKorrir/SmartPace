import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SessionHistory {
  final String subject;
  final String technique;
  final int duration;
  final DateTime date;
  final bool completed;
  final Color color;

  SessionHistory({
    required this.subject,
    required this.technique,
    required this.duration,
    required this.date,
    required this.completed,
    required this.color,
  });
}

class RecentSessionsSection extends StatelessWidget {
  RecentSessionsSection({super.key});

  // Mock data - in real app, this would come from a controller
  final List<SessionHistory> recentSessions = [
    SessionHistory(
      subject: 'Calculus II',
      technique: 'Disintergration',
      duration: 25,
      date: DateTime.now().subtract(const Duration(hours: 2)),
      completed: true,
      color: Colors.blue,
    ),
    SessionHistory(
      subject: 'OOP 2',
      technique: 'Java Basics',
      duration: 90,
      date: DateTime.now().subtract(const Duration(days: 1)),
      completed: true,
      color: Colors.green,
    ),
    SessionHistory(
      subject: 'Integrated Thinking in Computing',
      technique: 'Ideation',
      duration: 45,
      date: DateTime.now().subtract(const Duration(days: 2)),
      completed: false,
      color: Colors.orange,
    ),
  ];

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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent Sessions',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade800,
                ),
              ),
              TextButton(
                onPressed: () {
                  // Navigate to full history
                },
                child: Text(
                  'View All',
                  style: TextStyle(
                    color: Colors.blue.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          if (recentSessions.isEmpty)
            _buildEmptyState()
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: recentSessions.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final session = recentSessions[index];
                return _buildSessionCard(session);
              },
            ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          Icon(
            Icons.history,
            size: 48,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            'No study sessions yet',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Create your first AI-powered study plan above!',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSessionCard(SessionHistory session) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          // Status Indicator
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: session.completed ? Colors.green : Colors.orange,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          
          // Session Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  session.subject,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade800,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    _buildInfoBadge(
                      icon: Icons.psychology,
                      text: session.technique,
                      color: session.color,
                    ),
                    const SizedBox(width: 8),
                    _buildInfoBadge(
                      icon: Icons.access_time,
                      text: '${session.duration}m',
                      color: Colors.grey,
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Date and Status
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                _formatDate(session.date),
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: session.completed 
                      ? Colors.green.shade100 
                      : Colors.orange.shade100,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  session.completed ? 'Completed' : 'Incomplete',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: session.completed 
                        ? Colors.green.shade700 
                        : Colors.orange.shade700,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoBadge({
    required IconData icon,
    required String text,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 11,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${date.day}/${date.month}';
    }
  }
}