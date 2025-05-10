import 'package:flutter/material.dart';
import 'package:flutter_siren/services/signal_service.dart';
import 'package:flutter_siren/variables/variables.dart';
import 'package:flutter_siren/widgets/dialog_button.dart';
import 'package:flutter_siren/widgets/home/delete_signal.dart';
import 'package:flutter_siren/widgets/input_text.dart';

class EditSignalDialog extends StatefulWidget {
  final List<String> signals;

  const EditSignalDialog({
    super.key,
    required this.signals,
  });

  @override
  State<EditSignalDialog> createState() => _EditSignalDialogState();
}

class _EditSignalDialogState extends State<EditSignalDialog> {
  final TextEditingController newSignalController = TextEditingController();
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

  void _appendSignal() {
    if (newSignalController.text.isNotEmpty) {
      setState(() {
        // add signal
        SignalService.addSignalWordToList(newSignalController.text);
        widget.signals.add(newSignalController.text);
        cachedSignalList!.add(newSignalController.text);
        newSignalController.text = '';
        FocusScope.of(context).unfocus();
      });
    }
  }

  void _removeSignal(String word) {
    setState(() {
      // remove signal
      SignalService.deleteSignalWord(word);
      widget.signals.remove(word);
      cachedSignalList!.remove(word);
    });
  }

  void onClickCloseButton() async {
    Navigator.of(context).pop();
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
            height: 400.0,
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
                    'Edit your Signals',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Color(green),
                    ),
                  ),
                  const SizedBox(
                    height: 18.0,
                  ),

                  // add signal input
                  Row(
                    children: [
                      Expanded(
                        child: InputText(
                          inputController: newSignalController,
                          hint: 'Add your Signals',
                        ),
                      ),
                      GestureDetector(
                        onTap: _appendSignal,
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Icon(
                            Icons.add_circle_outline_sharp,
                            color: Colors.blue[700],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 15.0,
                  ),

                  // signal list
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        children: widget.signals
                            .map((word) => Padding(
                                  padding: const EdgeInsets.only(bottom: 10.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                          child: DeleteSignal(word: '# $word')),
                                      GestureDetector(
                                        onTap: () => _removeSignal(word),
                                        child: Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: Icon(
                                              Icons
                                                  .disabled_by_default_outlined,
                                              color: Colors.red[300]),
                                        ),
                                      )
                                    ],
                                  ),
                                ))
                            .toList(),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),

                  // close dialog button
                  DialogButton(
                    text: 'Close',
                    onPressed: onClickCloseButton,
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
