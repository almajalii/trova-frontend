import 'package:flutter/material.dart';
import 'package:trova/core/app_text.dart';
import 'package:trova/core/button.dart';
import 'package:trova/core/di/service_locator.dart';
import 'package:trova/core/network/api_exception.dart';
import 'package:trova/features/owner-profile/logic/owner_profile_model.dart';
import 'package:trova/features/owner-profile/logic/owner_profile_service.dart';
import 'package:trova/features/owner-profile/presentation/widget/owner_profile_layout.dart';

class OwnerProfileScreen extends StatefulWidget {
  final String? bidId;
  final String? projectId;
  final String companyName;

  /// Exactly one of [bidId] / [projectId] must be provided — see
  /// OwnerProfileService.fetchProfile for why.
  const OwnerProfileScreen({super.key, this.bidId, this.projectId, required this.companyName})
      : assert((bidId == null) != (projectId == null), 'Provide exactly one of bidId or projectId');

  @override
  State<OwnerProfileScreen> createState() => _OwnerProfileScreenState();
}

class _OwnerProfileScreenState extends State<OwnerProfileScreen> {
  OwnerFullProfile? _profile;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _profile = null;
      _errorMessage = null;
    });
    try {
      final profile = await sl<OwnerProfileService>().fetchProfile(
        bidId: widget.bidId,
        projectId: widget.projectId,
        companyName: widget.companyName,
      );
      if (mounted) setState(() => _profile = profile);
    } on ApiException catch (e) {
      if (mounted) setState(() => _errorMessage = e.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (context) {
          final errorMessage = _errorMessage;
          if (errorMessage != null) {
            return SafeArea(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AppText(text: errorMessage, textSize: 14, textAlign: TextAlign.center),
                      const SizedBox(height: 16),
                      Button(
                        text: 'Retry',
                        textColor: Colors.white,
                        borderRadius: 10,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        elevation: 0,
                        buttonWidth: 160,
                        buttonHeight: 44,
                        onPressed: _load,
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
          final profile = _profile;
          if (profile == null) {
            return const Center(child: CircularProgressIndicator());
          }
          return OwnerProfileLayout(profile: profile, onBack: () => Navigator.of(context).maybePop());
        },
      ),
    );
  }
}
