import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:regexed_validator/regexed_validator.dart';
import 'contact_screen.dart';

class AddContactScreen extends StatefulWidget {
  AddContactScreen({super.key});

  @override
  State<AddContactScreen> createState() => _AddContactScreenState();
}

class _AddContactScreenState extends State<AddContactScreen> {
  final fnameController = TextEditingController();
  final lnameController = TextEditingController();
  final phoneController = TextEditingController();
  final addrController = TextEditingController();
  final emailController = TextEditingController();
  final _formkey = GlobalKey<FormState>();

  void addContact() {
    FirebaseFirestore.instance.collection('contacts').add({
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
          addContact();
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Contact'),
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(12.0),
          child: Form(
            key: _formkey,
            child: SingleChildScrollView(
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
                        if (!validator.phone(value) || value.length < 11) {
                          return '*Invalid Phone Number.';
                        }
                        return null;
                      },
                      maxLength: 11,
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
                        if (!validator.email(value)) {
                          return '*Invalid Email.';
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
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton.icon(
                      onPressed: validateInput,
                      icon: const FaIcon(FontAwesomeIcons.plus),
                      label: const Text('Add Contact'),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
