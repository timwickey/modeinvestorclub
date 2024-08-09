import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:modeinvestorclub/src/backend.dart';
import 'package:modeinvestorclub/src/auth.dart';

import '../widgets/deal_list.dart';
import '../widgets/event_list.dart';
import '../data/globals.dart';
import '../widgets/referral.dart';
import '../widgets/profile.dart';
import '../widgets/mode_investor_club.dart';
import '../widgets/stock_history.dart';

class HomeScreen extends StatefulWidget {
  final ApiResponse? user;

  const HomeScreen({required this.user, super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _isSubmitting = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    final auth = Provider.of<ModeAuth>(context, listen: false);
    if (auth.isTokenLogin) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showPasswordResetDialog(context, auth);
        auth.setTokenLogin(false);
      });
    }
  }

  void _showPasswordResetDialog(BuildContext context, ModeAuth auth) {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
                side: BorderSide(
                  color: borderColor,
                  width: borderThickness,
                ),
              ),
              title: Text('Set Your Password'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Please set a new password to continue.'),
                  TextField(
                    controller: _newPasswordController,
                    decoration: InputDecoration(labelText: 'New Password'),
                    obscureText: true,
                  ),
                  TextField(
                    controller: _confirmPasswordController,
                    decoration: InputDecoration(labelText: 'Confirm Password'),
                    obscureText: true,
                  ),
                  if (_errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        _errorMessage!,
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () async {
                    final newPassword = _newPasswordController.text;
                    final confirmPassword = _confirmPasswordController.text;

                    if (newPassword.isEmpty || confirmPassword.isEmpty) {
                      setState(() {
                        _errorMessage = 'Both fields are required';
                      });
                      return;
                    }

                    if (newPassword != confirmPassword) {
                      setState(() {
                        _errorMessage = 'Passwords do not match';
                      });
                      return;
                    }
                    if (newPassword.length < 6) {
                      setState(() {
                        _errorMessage =
                            'Password is not long enough. Please try again.';
                      });
                      return;
                    }

                    setState(() {
                      _isSubmitting = true;
                      _errorMessage = null;
                    });

                    final backend = BackEnd();
                    final result = await backend.changePassword(
                      auth.user!.email,
                      auth.user!.token,
                      newPassword,
                    );

                    setState(() {
                      _isSubmitting = false;
                    });

                    if (result.data.isNotEmpty) {
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Password changed successfully')),
                      );
                    } else {
                      setState(() {
                        _errorMessage =
                            result.error ?? 'Failed to change password';
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text(
                                result.error ?? 'Failed to change password')),
                      );
                    }
                  },
                  child: _isSubmitting
                      ? CircularProgressIndicator()
                      : Text('Submit'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.only(top: 38.0),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: pageWidth),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      // calculate how much space is needed for the deals so we know how big to make the widget (for scrolling)
                      // we can fit 1 deal card within dealWidth
                      int numberOfDealsperRow =
                          (constraints.maxWidth / (dealWidth + dealSpacing))
                              .floor();
                      int numberOfRows = ((widget.user?.deals.length ?? 0) /
                              numberOfDealsperRow)
                          .ceil();
                      double dealTotalHeight =
                          numberOfRows * (dealHeight + dealSpacing);
                      // add the space needed for the header of the deals widget and the footerbar
                      dealTotalHeight += 100.0;

                      double eventheight = 120;

                      // profile height
                      double profileHeight = widgetHeight;
                      double referralHeight = widgetHeight;

                      if (constraints.maxWidth < 1200 &&
                          constraints.maxWidth > 800) {
                        eventheight = 120 + (1200 - constraints.maxWidth) / 6;
                      } else if (constraints.maxWidth <= 800 &&
                          constraints.maxWidth > 600) {
                        eventheight = 150;
                        profileHeight = widgetHeight - 50;
                        referralHeight = widgetHeight - 180;
                      } else if (constraints.maxWidth <= 600) {
                        eventheight = 180;
                        profileHeight = widgetHeight - 50;
                        referralHeight = widgetHeight - 180;
                      }

                      // calculate space needed for events
                      double eventTotalHeight =
                          ((widget.user?.events.length ?? 0) * eventheight) +
                              140.0;

                      if (constraints.maxWidth > 800) {
                        // Wide screen: one card 1/4 width, the other 3/4 width
                        return Column(
                          children: [
                            Row(
                              children: [
                                SizedBox(
                                  width: constraints.maxWidth * 0.25,
                                  height: referralHeight,
                                  child: const ReferralCard(),
                                ),
                                SizedBox(width: 8),
                                SizedBox(
                                  width: constraints.maxWidth * 0.75 - 8,
                                  height: profileHeight,
                                  child: ProfileCard(user: widget.user),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  width: constraints.maxWidth * 0.75 - 8,
                                  height: widgetHeight,
                                  child: StockHistory(user: widget.user),
                                ),
                                SizedBox(width: 8),
                                SizedBox(
                                  width: constraints.maxWidth * 0.25,
                                  height: widgetHeight,
                                  child: const ModeInvestorClub(),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  width: constraints.maxWidth,
                                  height: eventTotalHeight,
                                  child: EventList(
                                    events: widget.user?.events ?? [],
                                    scroller: true,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  width: constraints.maxWidth,
                                  height: dealTotalHeight,
                                  child:
                                      DealList(deals: widget.user?.deals ?? []),
                                ),
                              ],
                            ),
                          ],
                        );
                      } else {
                        // Mobile screen: ModeInvestorClub and ReferralCardMobile side by side
                        return Column(
                          children: [
                            SizedBox(
                              height: profileHeight,
                              child: ProfileCardMobile(user: widget.user),
                            ),
                            SizedBox(height: 8),
                            SizedBox(
                              height: profileHeight,
                              child: StockHistory(user: widget.user),
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: SizedBox(
                                    height: profileHeight,
                                    child: const ModeInvestorClubMobile(),
                                  ),
                                ),
                                SizedBox(width: 8),
                                Expanded(
                                  child: SizedBox(
                                    height: profileHeight,
                                    child: const ReferralCardMobile(),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            Row(
                              children: [
                                SizedBox(
                                  width: constraints.maxWidth,
                                  height: eventTotalHeight,
                                  child: EventListMobile(
                                    events: widget.user?.events ?? [],
                                    scroller: true,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            SizedBox(
                              height: dealTotalHeight,
                              child: DealList(deals: widget.user?.deals ?? []),
                            ),
                          ],
                        );
                      }
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      );
}
