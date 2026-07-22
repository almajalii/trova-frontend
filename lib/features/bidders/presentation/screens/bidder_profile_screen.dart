import 'package:flutter/material.dart';
import 'package:trova/core/app_text.dart';
import 'package:trova/core/button.dart';
import 'package:trova/core/di/service_locator.dart';
import 'package:trova/core/network/api_exception.dart';
import 'package:trova/features/bidders/logic/bidder_model.dart';
import 'package:trova/features/bidders/logic/bidder_profile_model.dart';
import 'package:trova/features/bidders/logic/bidder_profile_service.dart';
import 'package:trova/features/bidders/presentation/widget/bidder_profile_layout.dart';

class BidderProfileScreen extends StatefulWidget {
  final Bidder bidder;
  const BidderProfileScreen({super.key, required this.bidder});

  @override
  State<BidderProfileScreen> createState() => _BidderProfileScreenState();
}

class _BidderProfileScreenState extends State<BidderProfileScreen> {
  BidderFullProfile? _profile;
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
      final profile = await sl<BidderProfileService>().fetchProfile(widget.bidder);
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
          return BidderProfileLayout(profile: profile, onBack: () => Navigator.of(context).maybePop());
        },
      ),
    );
  }
}
