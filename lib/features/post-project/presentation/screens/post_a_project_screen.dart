import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trova/core/di/service_locator.dart';
import 'package:trova/features/post-project/logic/post_project_model.dart';
import 'package:trova/features/post-project/logic/post_project_service.dart';
import 'package:trova/features/post-project/presentation/bloc/post_project_bloc.dart';
import 'package:trova/features/post-project/presentation/bloc/post_project_event.dart';
import 'package:trova/features/post-project/presentation/bloc/post_project_state.dart';
import 'package:trova/features/post-project/presentation/widget/post_a_project_layout.dart';

class PostAProjectScreen extends StatefulWidget {
  const PostAProjectScreen({super.key});

  @override
  State<PostAProjectScreen> createState() => _PostAProjectScreenState();
}

class _PostAProjectScreenState extends State<PostAProjectScreen> {
  final _formKey = GlobalKey<FormState>();

  // Text Controllers
  final _titleController = TextEditingController();
  final _locationController = TextEditingController();
  final _valueController = TextEditingController();
  final _durationController = TextEditingController();
  final _milestonesController = TextEditingController();
  final _deadlineController = TextEditingController();
  final _minScoreController = TextEditingController();
  final _paymentTermsController = TextEditingController();
  final _descriptionController = TextEditingController();

  // Dropdown States
  String? _sector;
  String _currency = 'JOD';
  ClassificationCode _minClassification = ClassificationCode.b;
  String? _guaranteeType;

  @override
  void dispose() {
    _titleController.dispose();
    _locationController.dispose();
    _valueController.dispose();
    _durationController.dispose();
    _milestonesController.dispose();
    _deadlineController.dispose();
    _minScoreController.dispose();
    _paymentTermsController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (_) => PostProjectBloc(postProjectService: sl<PostProjectService>()),
        child: BlocConsumer<PostProjectBloc, PostProjectState>(
          listener: (context, state) {
            if (state is PostProjectError) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
            }
            if (state is PostProjectSuccess) {
              Navigator.of(context).pop(state.projectId);
            }
          },
          builder: (context, state) {
            final isLoading = state is PostProjectLoading;
            return PostAProjectLayout(
              formKey: _formKey,

              // Text Controllers
              titleController: _titleController,
              locationController: _locationController,
              valueController: _valueController,
              durationController: _durationController,
              milestonesController: _milestonesController,
              deadlineController: _deadlineController,
              minScoreController: _minScoreController,
              paymentTermsController: _paymentTermsController,
              descriptionController: _descriptionController,

              // Dropdowns & State
              sector: _sector,
              onSectorChanged: (v) => setState(() => _sector = v),
              currency: _currency,
              onCurrencyChanged: (v) => setState(() => _currency = v ?? 'JOD'),
              minClassification: _minClassification,
              onClassificationChanged: (v) => setState(() => _minClassification = v),
              guaranteeType: _guaranteeType,
              onGuaranteeTypeChanged: (v) => setState(() => _guaranteeType = v),

              isLoading: isLoading,
              onBack: () => Navigator.of(context).maybePop(),
              onSubmit: () {
                if (_formKey.currentState!.validate()) {
                  final draft = ProjectDraft(
                    title: _titleController.text,
                    sector: _sector ?? '',
                    location: _locationController.text,
                    contractValue: double.tryParse(_valueController.text) ?? 0,
                    currency: _currency,
                    duration: _durationController.text,
                    milestones: _milestonesController.text,
                    // Basic fallback if parsing fails; in reality, you might want a DatePicker
                    bidSubmissionDeadline: DateTime.tryParse(_deadlineController.text) ?? DateTime.now(),
                    minimumRequiredScore: int.tryParse(_minScoreController.text) ?? 0,
                    minimumClassification: _minClassification,
                    guaranteeType: _guaranteeType ?? '',
                    paymentTerms: _paymentTermsController.text,
                    description: _descriptionController.text,
                  );
                  context.read<PostProjectBloc>().add(PostProjectSubmitted(draft: draft));
                }
              },
            );
          },
        ),
      ),
    );
  }
}
