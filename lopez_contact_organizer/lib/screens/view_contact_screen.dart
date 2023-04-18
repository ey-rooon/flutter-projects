import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

import 'contact_screen.dart';

class ViewContactScreen extends StatefulWidget {
  String id;
  ViewContactScreen({super.key, required this.id});

  @override
  State<ViewContactScreen> createState() => _ViewContactScreenState();
}

class _ViewContactScreenState extends State<ViewContactScreen> {
  final fnameController = TextEditingController();
  final lnameController = TextEditingController();
  final phoneController = TextEditingController();
  final addrController = TextEditingController();
  final emailController = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  bool isEdit = true;

  void editContact() async {
    await FirebaseFirestore.instance.collection('contacts').doc(widget.id).set({
      'firstname': fnameController.text,
      'lastname': lnameController.text,
      'contact': phoneController.text,
      'address': addrController.text,
      'email': emailController.text
    });
    Navigator.of(context).pushReplacement(
      CupertinoPageRoute(
        builder: (context) => const ContactScreen(),
      ),
    );
  }

  void validateInput() {
    //cause form to validate
    if (_formkey.currentState!.validate()) {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.confirm,
        text: null,
        title: 'Are you sure?',
        confirmBtnText: 'YES',
        cancelBtnText: 'No',
        onConfirmBtnTap: () {
          //yes
          Navigator.pop(context);
          editContact();
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('contacts')
            .doc(widget.id)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          var docSnap = snapshot.data;
          fnameController.text = docSnap?['firstname'];
          lnameController.text = docSnap?['lastname'];
          phoneController.text = docSnap?['contact'];
          addrController.text = docSnap?['address'];
          emailController.text = docSnap?['email'];
          return Scaffold(
            appBar: AppBar(
              title: const Text('View Contact'),
              actions: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      isEdit = !isEdit;
                    });
                  },
                  icon: const FaIcon(FontAwesomeIcons.penToSquare),
                )
              ],
            ),
            body: SafeArea(
              child: Container(
                padding: const EdgeInsets.all(12.0),
                child: Form(
                  key: _formkey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: fnameController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return '*Required. Please enter Your firstname.';
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            labelText: 'First Name',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: lnameController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return '*Required. Please enter Your lastname.';
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            labelText: 'Last Name',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: phoneController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return '*Required. Please enter Your Phone Number.';
                            }
                            return null;
                          },
                          keyboardType: TextInputType.phone,
                          decoration: const InputDecoration(
                            labelText: 'Phone Number',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: addrController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return '*Required. Please enter Your Address.';
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            labelText: 'Address',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: emailController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return '*Required. Please enter Your Email.';
                            }
                            return null;
                          },
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            labelText: 'Email',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      Visibility(
                        visible: !isEdit,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton.icon(
                            onPressed: validateInput,
                            icon: const FaIcon(FontAwesomeIcons.penToSquare),
                            label: const Text('Save'),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}
