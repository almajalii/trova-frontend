import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trova/core/app_text.dart';
import 'package:trova/core/button.dart';
import 'package:trova/core/inputfeild.dart';
import 'package:trova/core/owner_tap_target.dart';
import 'package:trova/core/responsive_utils.dart';
import 'package:trova/features/capability-score/logic/capability_score_model.dart';
import 'package:trova/features/project-bid-detail/logic/projectdetailbid_model.dart';
import 'package:trova/features/project-bid-detail/presentation/bloc/projectdetailbid_bloc.dart';
import 'package:trova/features/project-bid-detail/presentation/bloc/projectdetailbid_event.dart';
import 'package:trova/features/project-bid-detail/presentation/bloc/projectdetailbid_state.dart';

class ProjectDetailLayout extends StatefulWidget {
  const ProjectDetailLayout({super.key});

  @override
  State<ProjectDetailLayout> createState() => _ProjectDetailLayoutState();
}

class _ProjectDetailLayoutState extends State<ProjectDetailLayout> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _bidController;

  @override
  void initState() {
    super.initState();
    _bidController = TextEditingController();
  }

  @override
  void dispose() {
    _bidController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colors.surface,
      appBar: AppBar(
        backgroundColor: colors.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colors.onSurface),
          onPressed: () => Navigator.maybePop(context),
        ),
      ),
      body: BlocConsumer<ProjectBidDetailBloc, ProjectDetailState>(
        listener: (context, state) {
          if (state is ProjectDetailSubmitted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Bid submitted successfully')),
            );
            Navigator.pop(context);
          }
          if (state is ProjectDetailError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
          if (state is ProjectDetailSubmitError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          if (state is ProjectDetailInitial || state is ProjectDetailLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is ProjectDetailError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: AppText(text: state.message, textAlign: TextAlign.center),
              ),
            );
          }

          Project? project;
          bool isSubmitting = false;
          CapabilityScore? myScore;

          if (state is ProjectDetailSuccess) {
            project = state.project;
            myScore = state.myScore;
          }
          if (state is ProjectDetailSubmitting) {
            project = state.project;
            isSubmitting = true;
          }
          if (state is ProjectDetailSubmitError) {
            project = state.project;
          }

          if (project == null) return const SizedBox.shrink();
          final bloc = context.read<ProjectBidDetailBloc>();
          final alreadyBid = project.alreadyBid;
          // Unknown score (fetch failed / no bank connected) fails open —
          // the backend's own check on submit is still the source of truth.
          final ineligible = myScore != null && !_meetsRequirement(myScore, project);
          final cannotBid = alreadyBid || ineligible;

          return Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: context.horizontal,
                vertical: 16,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ProjectPosterHeader(
                    title: project.title,
                    postedBy: project.postedByCompanyName,
                    projectId: project.projectId,
                  ),
                  const SizedBox(height: 16),
                  ProjectInfoCard(project: project),
                  const SizedBox(height: 20),
                  AppText(
                    text: 'Description',
                    textSize: 15,
                    fontWeight: FontWeight.w700,
                    textColor: colors.secondary,
                    textAlign: TextAlign.start,
                  ),
                  const SizedBox(height: 6),
                  AppText(
                    text: project.description,
                    textSize: 13,
                    textColor: const Color(0xFF6B7280),
                    textAlign: TextAlign.start,
                  ),
                  const SizedBox(height: 20),
                  if (alreadyBid) ...[
                    _AlreadyBidNotice(),
                    const SizedBox(height: 20),
                  ] else if (ineligible) ...[
                    _IneligibleNotice(project: project, myScore: myScore),
                    const SizedBox(height: 20),
                  ] else ...[
                    AppText(
                      text: 'Your Bid Amount (JOD)',
                      textSize: 14,
                      fontWeight: FontWeight.w600,
                      textColor: colors.secondary,
                      textAlign: TextAlign.start,
                    ),
                    const SizedBox(height: 8),
                    InputField(
                      controller: _bidController,
                      hintText: 'e.g. 238,000',
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Enter your bid amount';
                        }
                        final cleanVal = value.replaceAll(',', '');
                        if (double.tryParse(cleanVal) == null) {
                          return 'Enter a valid number';
                        }
                        return null;
                      },
                      onChanged: (value) => bloc.add(BidAmountChanged(value)),
                    ),
                    const SizedBox(height: 16),
                    BidWarningBox(postedBy: project.postedByCompanyName),
                    const SizedBox(height: 20),
                  ],
                  Button(
                    text: alreadyBid
                        ? 'Bid Already Submitted'
                        : (ineligible
                            ? 'Requirements Not Met'
                            : (isSubmitting ? 'Submitting...' : 'Submit Bid')),
                    textColor: cannotBid ? colors.onSurfaceVariant : Colors.white,
                    buttonColor: cannotBid ? colors.surfaceBright : const Color(0xFFC82333),
                    borderRadius: 12,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    buttonWidth: double.infinity,
                    buttonHeight: context.buttonSizeH,
                    elevation: 0,
                    onPressed: (cannotBid || isSubmitting)
                        ? null
                        : () {
                            if (_formKey.currentState?.validate() ?? false) {
                              bloc.add(const SubmitBidPressed());
                            }
                          },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Mirrors the backend's exact ranking (A=3, B=2, C=1, anything else —
/// empty/unset/unrecognized — = 0) so this can never silently drift from
/// what the API enforces on submit. Applied identically to both the
/// contractor's own classification and the project's minimum: an unset
/// project minimum ranks 0 too (no requirement), not "A" — do not swap
/// this for a "lower rank = better" scheme, that inverts the fallback
/// for an unset minimum and wrongly requires "A" from everyone.
const Map<String, int> _classificationRank = {'A': 3, 'B': 2, 'C': 1};

/// True when the contractor's own score/classification meets this
/// project's minimums. Mirrors the check the backend now enforces on
/// submit — kept in sync so the proactive grey-out and the reactive 400
/// never disagree. A contractor with no classification set at all (empty
/// code — never submitted Company Details) ranks 0, same as backend, and
/// correctly fails the check for any project that requires A/B/C; that's
/// a *known, insufficient* rank, distinct from `myScore == null` (score
/// fetch failed entirely), which fails open in the caller instead.
bool _meetsRequirement(CapabilityScore myScore, Project project) {
  final scoreOk = myScore.overallScore >= project.minimumRequiredScore;
  final myRank = _classificationRank[myScore.classification.code] ?? 0;
  final requiredRank = _classificationRank[project.minimumClassification] ?? 0;
  final classificationOk = myRank >= requiredRank;
  return scoreOk && classificationOk;
}

class _IneligibleNotice extends StatelessWidget {
  final Project project;
  final CapabilityScore myScore;
  const _IneligibleNotice({required this.project, required this.myScore});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFDE8E8),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline, size: 18, color: Color(0xFFC82333)),
          const SizedBox(width: 8),
          Expanded(
            child: AppText(
              text:
                  'Your Capability Score (${myScore.overallScore}, Class ${myScore.classification.code}) doesn\'t meet this project\'s minimum requirement (${project.minimumRequiredScore}+, ${project.minimumClassificationText}).',
              textSize: 12,
              textColor: const Color(0xFFC82333),
              textAlign: TextAlign.start,
            ),
          ),
        ],
      ),
    );
  }
}

class _AlreadyBidNotice extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.surfaceBright, width: 1),
      ),
      child: AppText(
        text: 'You have already submitted a bid for this project.',
        textSize: 13,
        textColor: colors.onSurfaceVariant,
        textAlign: TextAlign.start,
      ),
    );
  }
}

class ProjectPosterHeader extends StatelessWidget {
  final String title;
  final String postedBy;
  final String projectId;

  const ProjectPosterHeader({
    super.key,
    required this.title,
    required this.postedBy,
    required this.projectId,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          text: title,
          textSize: 20,
          fontWeight: FontWeight.w700,
          textColor: colors.secondary,
          textAlign: TextAlign.start,
        ),
        const SizedBox(height: 4),
        OwnerTapTarget(
          projectId: projectId,
          companyName: postedBy,
          child: AppText(
            text: 'Posted by $postedBy',
            textSize: 13,
            fontWeight: FontWeight.w600,
            textColor: colors.primary,
            textAlign: TextAlign.start,
          ),
        ),
      ],
    );
  }
}

class ProjectInfoCard extends StatelessWidget {
  final Project project;

  const ProjectInfoCard({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.surfaceBright),
      ),
      child: Column(
        children: [
          _buildRow(context, 'Sector', project.sector),
          _buildRow(context, 'Location', project.location),
          _buildRow(
            context,
            'Contract Value',
            'JOD ${project.contractValueJod.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
          ),
          _buildRow(context, 'Timeline', project.timelineText),
          _buildRow(context, 'Milestones', project.milestones),
          _buildRow(context, 'Guarantee Type Required', project.guaranteeTypeRequired),
          _buildRow(context, 'Payment Terms', project.paymentTerms),
          _buildRow(context, 'Minimum Score', '${project.minimumRequiredScore}+'),
          _buildRow(context, 'Minimum Classification', project.minimumClassificationText),
          _buildRow(
            context,
            'Bid Deadline',
            project.bidDeadlineText,
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _buildRow(BuildContext context, String label, String value, {bool isLast = false}) {
    final colors = Theme.of(context).colorScheme;
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 5,
            child: AppText(
              text: label,
              textSize: 12,
              textColor: const Color(0xFF6B7280),
              textAlign: TextAlign.start,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 6,
            child: AppText(
              text: value,
              textSize: 12,
              fontWeight: FontWeight.w600,
              textColor: colors.secondary,
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}

class BidWarningBox extends StatelessWidget {
  final String postedBy;

  const BidWarningBox({super.key, required this.postedBy});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFDE8E8),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline,
            size: 18,
            color: Color(0xFFC82333),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: AppText(
              text:
                  'By submitting this bid, your Capability Score and its underlying data will be visible to $postedBy for evaluation.',
              textSize: 12,
              textColor: const Color(0xFFC82333),
              textAlign: TextAlign.start,
            ),
          ),
        ],
      ),
    );
  }
}
