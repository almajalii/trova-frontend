import 'package:flutter/material.dart';
import 'package:trova/features/terms/terms_consent_layout.dart';

class TermsConsentScreen extends StatefulWidget {
  /// Called once the user has scrolled to the bottom, checked the box,
  /// and tapped "Agree & Continue". Wire this to push your Company
  /// Details screen.
  final VoidCallback onAgreed;

  const TermsConsentScreen({super.key, required this.onAgreed});

  @override
  State<TermsConsentScreen> createState() => _TermsConsentScreenState();
}

class _TermsConsentScreenState extends State<TermsConsentScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _reachedBottom = false;
  bool _agreed = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_reachedBottom) return;
    if (!_scrollController.hasClients) return;

    final position = _scrollController.position;
    // Small threshold so it triggers even if the last frame doesn't
    // land exactly on maxScrollExtent.
    if (position.pixels >= position.maxScrollExtent - 24) {
      setState(() => _reachedBottom = true);
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TermsConsentLayout(
        scrollController: _scrollController,
        reachedBottom: _reachedBottom,
        agreed: _agreed,
        onAgreedChanged: (value) => setState(() => _agreed = value),
        onContinue: widget.onAgreed,
        onBack: () => Navigator.pop(context),
      ),
    );
  }
}