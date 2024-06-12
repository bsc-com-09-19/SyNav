import 'package:flutter/material.dart';
import 'package:sy_nav/common/widgets/k_form.dart';
import 'package:sy_nav/common/widgets/k_height.dart';
import 'package:sy_nav/utils/constants/colors.dart';
import 'package:sy_nav/utils/constants/k_sizes.dart';

class AddAccessPointDialog extends StatefulWidget {
  final String macAddress;
  const AddAccessPointDialog({super.key, required this.macAddress});

  @override
  State<AddAccessPointDialog> createState() => _AddAccessPointDialogState();
}

class _AddAccessPointDialogState extends State<AddAccessPointDialog> {
  final TextEditingController _macAddressTextController =
      TextEditingController();
  final TextEditingController _xCoordinateTextController =
      TextEditingController();
  final TextEditingController _yCoordinateTextController =
      TextEditingController();
  @override
  void initState() {
    _macAddressTextController.value = TextEditingValue(text: widget.macAddress);
    super.initState();
  }

  //validates the form
  bool _isFormValid() {
    String errorMessage = '';

    if (_macAddressTextController.text.isEmpty) {
      errorMessage = "Access point mac Address not provided";
    }
    if (_xCoordinateTextController.text.isEmpty) {
      errorMessage = "X coordinate not provided";
    }
    if (_yCoordinateTextController.text.isEmpty) {
      errorMessage = "Y coordinate not provided";
    }

    if (errorMessage.isNotEmpty) {
      SnackBar(
        content: Text(errorMessage),
        backgroundColor: AppColors.secondaryColor.withOpacity(0.6),
      );
    }
    return errorMessage.isEmpty;
  }

  @override
  void dispose() {
    //disposes the texts in the controller when not in use
    _macAddressTextController.dispose();
    _xCoordinateTextController.dispose();
    _yCoordinateTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        centerTitle: true,
        title: const Text('Add Access Point'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(KSizes.defaultSpace),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            const KHeight(height: KSizes.spaceBtwnInputFields),
            KTextField(
                controller: _macAddressTextController,
                labelText: "Mac Address"),
            const KHeight(height: KSizes.spaceBtwnInputFields),
            KTextField(
                controller: _xCoordinateTextController,
                labelText: "X-coordinate"),
            const KHeight(height: KSizes.spaceBtwnInputFields),
            KTextField(
                controller: _yCoordinateTextController,
                labelText: "Y-coordinate"),
            const KHeight(height: KSizes.spaceBtwSections),
            ElevatedButton(
              onPressed: () async {
                //1. validate the form

                if (_isFormValid()) {}
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                    AppColors.secondaryColor.withOpacity(0.8)),
                foregroundColor:
                    MaterialStateProperty.all(AppColors.primaryColor),
                elevation: MaterialStateProperty.all(8),
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 100),
                child: Text("Save Post"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
