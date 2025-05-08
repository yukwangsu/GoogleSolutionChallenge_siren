import 'package:flutter/material.dart';
import 'package:flutter_siren/variables/variables.dart';
import 'package:flutter_siren/widgets/dialog_button.dart';
import 'package:flutter_siren/widgets/input_text.dart';

class AddFriendDialog extends StatefulWidget {
  const AddFriendDialog({
    super.key,
  });

  @override
  State<AddFriendDialog> createState() => _AddFriendDialogState();
}

class _AddFriendDialogState extends State<AddFriendDialog> {
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

  void _appendFriend() {
    if (inputController.text.isNotEmpty) {
      // todo: Call add firend api
      //
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
                    'Add your friend',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Color(green),
                    ),
                  ),
                  const SizedBox(
                    height: 18.0,
                  ),

                  // add user code input
                  InputText(
                    inputController: inputController,
                    hint: 'Enter the code',
                  ),
                  const SizedBox(
                    height: 15.0,
                  ),

                  // confirm button
                  DialogButton(
                    text: 'Confirm',
                    onPressed: _appendFriend,
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
