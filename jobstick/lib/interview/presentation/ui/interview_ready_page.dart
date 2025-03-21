import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:jobstick/interview/presentation/providers/interview_create_provider.dart';
import '../../domain/entity/interview.dart';
import 'interview_start_page.dart'; // InterviewStartPage 임포트

class InterviewReadyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // InterviewCreateProvider 가져오기
    final createProvider = Provider.of<InterviewCreateProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('모의 면접 설정'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: InterviewForm(createProvider: createProvider),
      ),
    );
  }
}

class InterviewForm extends StatefulWidget {
  final InterviewCreateProvider createProvider;

  const InterviewForm({Key? key, required this.createProvider}) : super(key: key);

  @override
  _InterviewFormState createState() => _InterviewFormState();
}

class _InterviewFormState extends State<InterviewForm> {
  String? selectedCompany;
  String? selectedJob;
  String? selectedExperience;

  final List<String> companies = ['회사 A', '회사 B', '회사 C'];
  final List<String> jobs = ['개발자', '디자이너', '기획자'];
  final List<String> experiences = ['신입', '경력 3년', '경력 5년 이상'];

  void _submitSelection() {
    if (selectedCompany != null && selectedJob != null && selectedExperience != null) {
      final interview = Interview(
        companyName: selectedCompany!,
        jobTitle: selectedJob!,
        jobCategory: selectedExperience!,
        createDate: DateTime.now().toString(), // 생성 날짜를 현재 시간으로 설정
      );

      // InterviewCreateProvider를 통해 면접을 생성
      widget.createProvider.createInterview(interview).then((_) {
        if (widget.createProvider.errorMessage == null) {
          // InterviewStartPage로 이동
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => InterviewStartPage()),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(widget.createProvider.errorMessage!)),
          );
        }
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('모든 항목을 선택해주세요.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButtonFormField<String>(
          value: selectedCompany,
          hint: Text('회사를 선택하세요'),
          onChanged: (value) => setState(() => selectedCompany = value),
          items: companies.map((company) => DropdownMenuItem(
            value: company,
            child: Text(company, style: TextStyle(fontWeight: FontWeight.bold)),
          )).toList(),
        ),
        SizedBox(height: 16),
        DropdownButtonFormField<String>(
          value: selectedJob,
          hint: Text('직무를 선택하세요'),
          onChanged: (value) => setState(() => selectedJob = value),
          items: jobs.map((job) => DropdownMenuItem(
            value: job,
            child: Text(job, style: TextStyle(fontWeight: FontWeight.bold)),
          )).toList(),
        ),
        SizedBox(height: 16),
        DropdownButtonFormField<String>(
          value: selectedExperience,
          hint: Text('경력을 선택하세요'),
          onChanged: (value) => setState(() => selectedExperience = value),
          items: experiences.map((experience) => DropdownMenuItem(
            value: experience,
            child: Text(experience, style: TextStyle(fontWeight: FontWeight.bold)),
          )).toList(),
        ),
        Spacer(),
        Center(
          child: ElevatedButton(
            onPressed: _submitSelection,
            child: Text('시작', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ),
      ],
    );
  }
}
