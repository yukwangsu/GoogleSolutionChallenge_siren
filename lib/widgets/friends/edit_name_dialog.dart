import 'package:flutter/material.dart';
import 'package:flutter_siren/services/user_service.dart';
import 'package:flutter_siren/variables/variables.dart';
import 'package:flutter_siren/widgets/dialog_button.dart';
import 'package:flutter_siren/widgets/input_text.dart';

class EditNameDialog extends StatefulWidget {
  const EditNameDialog({
    super.key,
  });

  @override
  State<EditNameDialog> createState() => _EditNameDialogState();
}

class _EditNameDialogState extends State<EditNameDialog> {
  final TextEditingController inputController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        setState(() {});
      }
    });
  }

  void _editName() {
    if (inputController.text.isNotEmpty) {
      // max length
      String tempName = inputController.text;
      tempName = tempName.length > maxUsernameLength
          ? tempName.substring(0, maxUsernameLength)
          : tempName;
      UserService.editUsername(tempName);
      cachedUsername = tempName;
      inputController.text = '';
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Dialog(
          child: Container(
            width: 301.0,
            height: 200.0,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 20.0, right: 33.0, bottom: 20.0, left: 33.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // dialog title
                  const Text(
                    'Edit username',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Color(green),
                    ),
                  ),
                  const SizedBox(
                    height: 18.0,
                  ),

                  // add username input
                  InputText(
                    inputController: inputController,
                    hint: 'Enter new username',
                  ),
                  const SizedBox(
                    height: 15.0,
                  ),

                  // Edit button
                  DialogButton(
                    text: 'Edit',
                    onPressed: _editName,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
