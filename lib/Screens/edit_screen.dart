import 'package:flutter/material.dart';
import 'package:mytask/Screens/home_screen.dart';
import 'package:mytask/bloc/user_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/user.dart';

enum Gender { male, female }

class EditingScreen extends StatefulWidget {
  static String routeName = "/edit";

  @override
  State<EditingScreen> createState() => _EditingScreenState();
}

class _EditingScreenState extends State<EditingScreen> {
  var name = TextEditingController();
  var phone = TextEditingController();
  var address = TextEditingController();
  var state = TextEditingController();
  var city = TextEditingController();
  var email = TextEditingController();
  Gender? gender;
  final _formKey = GlobalKey<FormState>();
  //to check whether builder is running for the first time
  bool first_build = true;

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings?.arguments;
    User? myUser;
    if (args != null) {
      myUser = args as User;
    }
    if (first_build) {
      name.text = myUser?.name ?? "";
      phone.text = myUser?.phone ?? "";
      address.text = myUser?.address ?? "";
      state.text = myUser?.state ?? "";
      city.text = myUser?.city ?? "";
      email.text = myUser?.email ?? "";
      gender = (myUser?.gender == 'male') ? Gender.male : Gender.female;
    }
    first_build = false;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: (myUser == null)
            ? const Text("Add New User")
            : const Text("Update User"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Theme(
            data: ThemeData(
              primarySwatch: Colors.teal,
            ),
            child: Container(
              padding: const EdgeInsets.fromLTRB(8, 15, 8, 15),
              child: Column(children: [
                const SizedBox(
                  height: 20,
                ),
                const SizedBox(height: 20),
                Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: TextFormField(
                            controller: name,
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.person),
                              hintText: 'Full Name',
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                            ),
                            validator: (value) {
                              if (name.text == null || name.text.isEmpty) {
                                return 'Please enter some text';
                              }

                              return null;
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Gender:",
                                textAlign: TextAlign.start,
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: RadioListTile(
                                      title: const Text("Male"),
                                      value: Gender.male,
                                      groupValue: gender,
                                      onChanged: (value) {
                                        setState(() {
                                          gender = value;
                                        });
                                      },
                                    ),
                                  ),
                                  Expanded(
                                    child: RadioListTile(
                                      title: const Text("Female"),
                                      value: Gender.female,
                                      groupValue: gender,
                                      onChanged: (value) {
                                        setState(() {
                                          gender = value;
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: TextFormField(
                            controller: email,
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.email),
                              hintText: 'Email Adress',
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                            ),
                            validator: (value) {
                              if (email.text == null || email.text.isEmpty) {
                                return 'Please enter an Email Address';
                              } else if (!RegExp(
                                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                  .hasMatch(email.text)) {
                                return "Enter a valid Email";
                              }

                              return null;
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: TextFormField(
                            controller: phone,
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.phone),
                              hintText: 'Phone No.',
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                            ),
                            validator: (value) {
                              if (phone.text == null || phone.text.isEmpty) {
                                return 'Please enter some text';
                              }

                              return null;
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: TextFormField(
                            controller: address,
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.home),
                              hintText: 'Adress',
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                            ),
                            validator: (value) {
                              if (address.text == null ||
                                  address.text.isEmpty) {
                                return 'Please enter some text';
                              }

                              return null;
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: TextFormField(
                            controller: state,
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.map),
                              hintText: 'State',
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                            ),
                            validator: (value) {
                              if (state.text == null || state.text.isEmpty) {
                                return 'Please enter some text';
                              }

                              return null;
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: TextFormField(
                            controller: city,
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.location_city),
                              hintText: 'City',
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                            ),
                            validator: (value) {
                              if (city.text == null || city.text.isEmpty) {
                                return 'Please enter some text';
                              }

                              return null;
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate() &&
                                  gender != null) {
                                //condition to check whether it is update request or add request
                                if (myUser != null) {
                                  context.read<UserBloc>().add(UpdateUser(
                                      id: myUser?.id ?? -1,
                                      name: name.text.trim(),
                                      address: address.text.trim(),
                                      city: city.text.trim(),
                                      email: email.text.trim(),
                                      gender: gender == Gender.male
                                          ? "male"
                                          : "female",
                                      phone: phone.text.trim(),
                                      state: state.text.trim()));

                                  if (context.read<UserBloc>().state
                                      is UserSuccess) {
                                    Navigator.pop(context);
                                  }
                                  if (context.read<UserBloc>().state
                                      is UserFailure) {
                                    const SnackBar(
                                        content: Text("Adding failed"));
                                  }

                                  if (context.read<UserBloc>().state
                                      is UserLoading) {
                                    const CircularProgressIndicator.adaptive();
                                  }
                                } else {
                                  context.read<UserBloc>().add(AddUser(
                                      name: name.text.trim(),
                                      address: address.text.trim(),
                                      city: city.text.trim(),
                                      email: email.text.trim(),
                                      gender: gender == Gender.male
                                          ? "male"
                                          : "female",
                                      phone: phone.text.trim(),
                                      state: state.text.trim()));

                                  if (context.read<UserBloc>().state
                                      is UserSuccess) {
                                    Navigator.pop(context);
                                  }
                                  if (context.read<UserBloc>().state
                                      is UserFailure) {
                                    const SnackBar(
                                        content: Text("Adding failed"));
                                  }

                                  if (context.read<UserBloc>().state
                                      is UserLoading) {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return const Center(
                                            child: Column(
                                              children: [
                                                CircularProgressIndicator
                                                    .adaptive(),
                                                Text(
                                                  "Saving the data",
                                                  style: TextStyle(
                                                      color: Colors.black),
                                                )
                                              ],
                                            ),
                                          );
                                        });
                                  }
                                }
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              minimumSize: const Size.fromHeight(50),
                            ),
                            child: const Text(
                              'Submit',
                              style: TextStyle(fontSize: 17),
                            ),
                          ),
                        ),
                      ],
                    ))
              ]),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    name.dispose();
    phone.dispose();
    address.dispose();
    state.dispose();
    city.dispose();
    email.dispose();
    super.dispose();
  }
}
