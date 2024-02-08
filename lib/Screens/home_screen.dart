import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mytask/bloc/user_bloc.dart';

import 'edit_screen.dart';

class HomeScreen extends StatefulWidget {
  static String routeName = "/";
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void delete_helper(String id) {
    context.read<UserBloc>().add(DeleteUser(id: id));
  }

  final scrollController = ScrollController();
  void scrollListening() {
    scrollController.addListener(() {
      if (scrollController.position.atEdge) {
        if (scrollController.position.pixels != 0) {
          context.read<UserBloc>().add(FetchMore());
        }
      }
    });
  }

  @override
  void initState() {
    UserState curr_state = context.read<UserBloc>().state;
    if (curr_state == UserSuccess) {
      context.read<UserBloc>().add(UserFetched());
    }
    super.initState();
    scrollListening();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 255, 255, 255),
          title: const Text(
            "U S E R S",
            style: TextStyle(color: Colors.black),
          ),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, EditingScreen.routeName);
                },
                icon: const Icon(
                  Icons.add_circle,
                  color: Colors.black,
                )),
          ],
        ),
        body: BlocBuilder<UserBloc, UserState>(
          builder: (context, state) {
            if (state is UserFailure) {
              return Text(state.error);
            }

            if (state is! UserSuccess && state is! LoadingMore) {
              return const Center(
                child: CircularProgressIndicator.adaptive(),
              );
            }

            final data;
            if (state is UserSuccess) {
              data = state.users;
            } else if (state is LoadingMore) {
              data = state.users;
            } else {
              data = [];
              return const Text("No Users Found!");
            }
            final listdata = data;
            return Container(
              padding: const EdgeInsets.only(top: 15),
              color: const Color.fromARGB(255, 243, 243, 243),
              child: ListView.builder(
                controller: scrollController,
                itemCount: listdata.length + 1,
                itemBuilder: (context, index) {
                  if (listdata.length == 0) {
                    return const Center(
                      child: Text(
                        "NO DATA!",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    );
                  }

                  if (index < listdata.length) {
                    return Padding(
                        padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: const [
                              BoxShadow(
                                color: Color.fromARGB(255, 228, 227, 227),
                                offset: Offset(0, 0),
                                blurRadius: 1,
                                spreadRadius: 4,
                              ),
                            ],
                          ),
                          child: ListTile(
                            title: Container(
                              padding: EdgeInsets.only(bottom: 5),
                              child: Row(
                                children: [
                                  Text(
                                    listdata[index].name,
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  (listdata[index].gender == 'male')
                                      ? const Row(
                                          children: [
                                            Icon(Icons.male, size: 21),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              "Male",
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  color: Color.fromARGB(
                                                      255, 95, 95, 95)),
                                            )
                                          ],
                                        )
                                      : const Row(
                                          children: [
                                            Icon(Icons.female, size: 21),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              "Female",
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  color: Color.fromARGB(
                                                      255, 95, 95, 95)),
                                            )
                                          ],
                                        )
                                ],
                              ),
                            ),
                            trailing: Container(
                              width: 100,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Container(
                                    child: IconButton(
                                        onPressed: () {
                                          Navigator.pushNamed(
                                              context, EditingScreen.routeName,
                                              arguments: listdata[index]);
                                        },
                                        icon: const Icon(
                                          Icons.edit,
                                        )),
                                  ),
                                  Container(
                                    child: IconButton(
                                        onPressed: () async {
                                          String? response =
                                              await showDialog<String>(
                                            context: context,
                                            builder: (BuildContext context) =>
                                                AlertDialog(
                                              title: const Text('Delete User!'),
                                              content: const Text(
                                                  "Do you want to delete?"),
                                              actions: <Widget>[
                                                TextButton(
                                                  onPressed: () =>
                                                      Navigator.pop(
                                                          context, 'Cancel'),
                                                  child: const Text('Cancel'),
                                                ),
                                                TextButton(
                                                  onPressed: () =>
                                                      Navigator.pop(
                                                          context, 'Yes'),
                                                  child: const Text('Yes'),
                                                )
                                              ],
                                            ),
                                          );

                                          if (response == 'Yes') {
                                            setState(() {
                                              delete_helper(listdata[index].id);
                                              listdata.remove(data[index]);
                                            });
                                          }
                                        },
                                        icon: const Icon(
                                          Icons.delete,
                                        )),
                                  ),
                                ],
                              ),
                            ),
                            subtitle: Row(
                              children: [
                                Icon(
                                  Icons.mail_outline,
                                  size: 17,
                                ),
                                SizedBox(
                                  width: 2,
                                ),
                                Text(
                                  listdata[index].email,
                                  style: TextStyle(fontSize: 15),
                                ),
                              ],
                            ),
                          ),
                        ));
                  } else {
                    if (state is! UserSuccess) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 32),
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                    if (state is UserSuccess) {
                      if (state.hasData) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 32),
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      } else {
                        return Container();
                      }
                    }
                  }
                },
              ),
            );
          },
        ));
  }
}
