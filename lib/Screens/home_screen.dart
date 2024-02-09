import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:mytask/bloc/user_bloc.dart';

import '../models/user.dart';
import 'edit_screen.dart';

class HomeScreen extends StatefulWidget {
  static String routeName = "/";
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //ScrollControler to detect the scrolling
  final scrollController = ScrollController();

  /* All Functions: */
  /* Delete helper function to call a bloc event which deletes the speicific user */
  void delete_helper(int id) {
    context.read<UserBloc>().add(DeleteUser(id: id));
  }

  /* ScrollListening function to continously check whether the list was scrolled and whenever scroll is detected, Call the bloc event to load more data from next page*/
  void scrollListening() {
    scrollController.addListener(() {
      if (scrollController.position.atEdge) {
        if (scrollController.position.pixels != 0) {
          //bloc event to get more data from API
          context.read<UserBloc>().add(FetchMore());
        }
      }
    });
  }

/* InitState handles 2 functions:
1. A bloc event is called to load the already stored data (Without calling the API)
2. It calls the scrollingListening function to  */
  @override
  void initState() {
    UserState curr_state = context.read<UserBloc>().state;
    //In the main file, already initial event was called so this condition checks whether the app is in loading state or not. If it s in loading state then the user fetch event is not called
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
          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
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
            //Failed condition checking
            if (state is UserFailure) {
              return Center(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Following Error Occured: ${state.error}"),
                  ElevatedButton(
                      onPressed: () {
                        context.read<UserBloc>().add(UserFetched());
                      },
                      child: Text("Revert to home screen"))
                ],
              ));
            }
            /* To show the circular progress indicator, the state should be loading state. LoadingMore is a state which is emitted when more data is fetched on scrolling(Pagination). So while the app is in LoadingMore state, still it must be responsive and running. */
            if (state is! UserSuccess && state is! LoadingMore) {
              return Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator.adaptive(
                      backgroundColor: Colors.white,
                      valueColor: AlwaysStoppedAnimation(Colors.black),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    (state is UserLoading)
                        ? Text(
                            state.loading_message,
                            style: const TextStyle(
                              fontSize: 17,
                            ),
                          )
                        : const Text("")
                  ],
                ),
              );
            }

            //All the users data is stored in this variable
            final data;
            if (state is UserSuccess) {
              data = state.users;
            } else if (state is LoadingMore) {
              data = state.users;
            } else {
              data = [];
              return const Text("No Users Found!");
            }

            //This is a copy of "data" variable. Just to pass it in the listview and avoid problems
            final listdata = data;
            return Container(
              padding: const EdgeInsets.only(top: 15),
              color: const Color.fromARGB(255, 243, 243, 243),
              child: ListView.builder(
                controller: scrollController,
                //Item count is one extra to show the circular loading indicator while more data is fetched (Pagination)
                itemCount: listdata.length + 1,
                itemBuilder: (context, index) {
                  //Checks if the data is empty. which means no users are there.
                  if (listdata.length == 0) {
                    return const Center(
                      child: Text(
                        "NO DATA!",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    );
                  }
                  //If the index exceeds the data length, then it's time to load more data. Hence, checking the condition
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
                                blurRadius: 2,
                                spreadRadius: 3,
                              ),
                            ],
                          ),
                          child: ListTile(
                            title: Container(
                              padding: const EdgeInsets.only(bottom: 5),
                              child: Row(
                                children: [
                                  Text(
                                    (listdata[index].name.length > 15)
                                        ? "${listdata[index].name.toString().substring(0, 12)}..."
                                        : "${listdata[index].name}",
                                    style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  const SizedBox(
                                    width: 4,
                                  ),
                                  (listdata[index].gender == 'male')
                                      ? const Row(
                                          children: [
                                            Icon(Icons.male, size: 13),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              "Male",
                                              style: TextStyle(
                                                  fontSize: 10,
                                                  color: Color.fromARGB(
                                                      255, 95, 95, 95)),
                                            )
                                          ],
                                        )
                                      : const Row(
                                          children: [
                                            Icon(Icons.female, size: 13),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              "Female",
                                              style: TextStyle(
                                                  fontSize: 10,
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
                                              arguments: (listdata[index]));
                                        },
                                        icon: const Icon(
                                          Icons.edit,
                                          size: 20,
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
                                              delete_helper(data[index].id);
                                              listdata.remove(data[index]);
                                            });
                                          }
                                        },
                                        icon: const Icon(
                                          Icons.delete,
                                          size: 20,
                                        )),
                                  ),
                                ],
                              ),
                            ),
                            subtitle: Row(
                              children: [
                                const Icon(
                                  Icons.mail_outline,
                                  size: 14,
                                ),
                                const SizedBox(
                                  width: 2,
                                ),
                                Text(
                                  (listdata[index].email.length > 30)
                                      ? "${listdata[index].email.toString().substring(0, 20)}...."
                                      : "${listdata[index].email}",
                                  style: const TextStyle(fontSize: 11),
                                ),
                              ],
                            ),
                          ),
                        ));
                  } else {
                    if (state is! UserSuccess) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 32),
                        child: Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const CircularProgressIndicator.adaptive(
                                backgroundColor: Colors.white,
                                valueColor:
                                    AlwaysStoppedAnimation(Colors.black),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              (state is UserLoading)
                                  ? Text(
                                      state.loading_message,
                                      style: const TextStyle(
                                        fontSize: 17,
                                      ),
                                    )
                                  : const Text("")
                            ],
                          ),
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

  @override
  void dispose() {
    scrollController.dispose(); // TODO: implement dispose
    super.dispose();
  }
}
