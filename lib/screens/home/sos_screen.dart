import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async';
import '../../components/buttons/sos_button.dart';
import '../../constants/colors.dart';
import '../../constants/strings.dart';
import '../../providers/contact_provider.dart';
import '../../providers/location_provider.dart';

class SOSScreeen extends StatefulWidget {
  const SOSScreeen({super.key});

  @override
  _SOSScreeenState createState() => _SOSScreeenState();
}

class _SOSScreeenState extends State<SOSScreeen> {
  @override
  Widget build(BuildContext context) {
    final locationProvider = Get.find<LocationProvider>();
    final contactProvider = Get.find<ContactProvider>();

    void showCountdownDialog() {
      int seconds = 3;
      Get.dialog(
        _CountdownDialog(
          seconds: seconds,
          onCancel: () {
            if (Get.isDialogOpen == true) {
              Get.back();
            }
          },
          onComplete: () async {
            await locationProvider.getCurrentLocation();
            if (locationProvider.currentLocation.value != null) {
              if (contactProvider.contacts.isEmpty) {
                Get.back(); // Close dialog immediately if no contacts
                await contactProvider.sendDistressMessage(
                  locationProvider.currentLocation.value!,
                  isCritical: true,
                );
              } else {
                await contactProvider.sendDistressMessage(
                  locationProvider.currentLocation.value!,
                  isCritical: true,
                );
                final contactNames =
                    contactProvider.contacts.map((c) => c.name).join(', ');
                Get.snackbar(
                  'Success',
                  'Sent to: $contactNames',
                  snackPosition: SnackPosition.TOP,
                  duration: const Duration(seconds: 3),
                  backgroundColor: Colors.green,
                  colorText: Colors.white,
                );
              }
            }
          },
        ),
        barrierDismissible: false,
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppStrings.sosTitle,
          style: Theme.of(context)
              .textTheme
              .headlineMedium!
              .copyWith(fontSize: 24),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SOSButton(
                onPressed: (isLongPress) {
                  showCountdownDialog(); // Ignore long press
                },
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Text(
                  AppStrings.sosMessage,
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        fontSize: 16,
                        fontStyle: FontStyle.italic,
                      ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CountdownDialog extends StatefulWidget {
  final int seconds;
  final VoidCallback onCancel;
  final VoidCallback onComplete;

  const _CountdownDialog({
    required this.seconds,
    required this.onCancel,
    required this.onComplete,
  });

  @override
  _CountdownDialogState createState() => _CountdownDialogState();
}

class _CountdownDialogState extends State<_CountdownDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late int _seconds;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _seconds = widget.seconds;
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: widget.seconds),
    );
    _animation = Tween<double>(begin: 1.0, end: 0.0).animate(_controller);
    _controller.forward();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() {
        _seconds--;
      });
      if (_seconds <= 0) {
        timer.cancel();
        Get.back(); // Close dialog immediately
        if (mounted) {
          widget.onComplete();
        }
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      title: const Text('Confirm SOS', style: TextStyle(fontSize: 20)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return SizedBox(
                height: 50,
                width: 50,
                child: CircularProgressIndicator(
                  value: _animation.value,
                  strokeWidth: 6,
                  backgroundColor: AppColors.textGray,
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          Text('$_seconds seconds remaining',
              style: const TextStyle(fontSize: 16)),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            _timer?.cancel();
            widget.onCancel();
          },
          child: const Text('Cancel', style: TextStyle(fontSize: 16)),
        ),
      ],
    );
  }
}
