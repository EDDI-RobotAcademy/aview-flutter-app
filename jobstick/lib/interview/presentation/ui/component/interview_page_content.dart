import 'package:flutter/material.dart';
import '../../../../common_ui/pagination.dart';
import '../../providers/interview_list_provider.dart';
import 'interview_item.dart';  // Custom widget for each interview item

class InterviewPageContent extends StatelessWidget {
  final InterviewListProvider interviewListProvider;
  final Function(int) onPageChanged;

  const InterviewPageContent({
    Key? key,
    required this.interviewListProvider,
    required this.onPageChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Handle the list of interviews
    final interviewList = interviewListProvider.interviewList;
    final currentPage = interviewListProvider.currentPage;
    final totalPages = interviewListProvider.totalPages;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Interview List
        Expanded(
          child: ListView.builder(
            itemCount: interviewList.length,
            itemBuilder: (context, index) {
              final interview = interviewList[index];
              return InterviewItem(interview: interview); // Custom widget for each interview
            },
          ),
        ),

        // Pagination using the shared Pagination widget
        Pagination(
          currentPage: currentPage,
          totalPages: totalPages,
          onPageChanged: onPageChanged,
        ),
      ],
    );
  }
}
