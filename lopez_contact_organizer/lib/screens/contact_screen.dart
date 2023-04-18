import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'add_contact_screen.dart';
import 'view_contact_screen.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key});

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contact Organizer'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => AddContactScreen(),
                ),
              );
            },
            icon: const FaIcon(FontAwesomeIcons.userPlus),
          )
        ],
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('contacts')
                    .snapshots(),
                builder: (_, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  var docSnap = snapshot.data?.docs;
                  return Expanded(
                    child: ListView.builder(
                      itemCount: docSnap?.length,
                      itemBuilder: (context, index) {
                        var snapData = docSnap?[index];
                        var cid = snapData?.id;
                        String fullname =
                            '${snapData?['firstname']} ${snapData?['lastname']}';
                        String initials =
                            '${snapData?['firstname'][0].toString().toUpperCase()}${snapData?['lastname'][0].toString().toUpperCase()}';
                        return InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                              CupertinoPageRoute(
                                builder: (context) =>
                                    ViewContactScreen(id: cid!),
                              ),
                            );
                          },
                          onLongPress: () {
                            Navigator.of(context).push(
                              CupertinoPageRoute(
                                builder: (context) =>
                                    ViewContactScreen(id: cid!),
                              ),
                            );
                          },
                          child: Card(
                            elevation: 10,
                            child: ListTile(
                              leading: CircleAvatar(
                                child: Text(initials),
                              ),
                              title: Text(
                                fullname,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              ),
                              subtitle: Text('${snapData?['contact']}'),
                              trailing: IconButton(
                                onPressed: () {
                                  // QuickAlert.show(
                                  //   context: context,
                                  //   type: QuickAlertType.confirm,
                                  //   text: null,
                                  //   title: 'Are you sure?',
                                  //   confirmBtnText: 'YES',
                                  //   cancelBtnText: 'No',
                                  //   onConfirmBtnTap: () {
                                  //     //yes
                                  //     Navigator.pop(context);
                                  //     try {
                                  //       FirebaseFirestore.instance
                                  //           .collection('contacts')
                                  //           .doc(cid)
                                  //           .delete();
                                  //     } catch (ex) {}
                                  //   },
                                  // );
                                },
                                icon: const FaIcon(FontAwesomeIcons.trash),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
