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
  final _titleController = TextEditingController();
  final _valueController = TextEditingController();
  final _minScoreController = TextEditingController();
  final _descriptionController = TextEditingController();
  ClassificationCode _minClassification = ClassificationCode.b;

  @override
  void dispose() {
    _titleController.dispose();
    _valueController.dispose();
    _minScoreController.dispose();
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
              titleController: _titleController,
              valueController: _valueController,
              minScoreController: _minScoreController,
              descriptionController: _descriptionController,
              minClassification: _minClassification,
              onClassificationChanged: (v) => setState(() => _minClassification = v),
              isLoading: isLoading,
              onBack: () => Navigator.of(context).maybePop(),
              onSubmit: () {
                if (_formKey.currentState!.validate()) {
                  final draft = ProjectDraft(
                    title: _titleController.text,
                    contractValueJod: double.tryParse(_valueController.text) ?? 0,
                    minimumRequiredScore: int.tryParse(_minScoreController.text) ?? 0,
                    minimumClassification: _minClassification,
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
