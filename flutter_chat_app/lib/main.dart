import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_app/bloc/conversation_bloc.dart';
import 'package:flutter_chat_app/repositories/conversation_repository.dart';
import 'package:flutter_chat_app/screens/conversation_list_screen.dart';
import 'package:flutter_chat_app/screens/conversation_detail_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => ConversationRepository(),
      child: BlocProvider(
        create: (context) => ConversationBloc(
          repository: RepositoryProvider.of<ConversationRepository>(context),
        ),
        child: MaterialApp(
          title: 'Chat App',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.blue,
              primary: Colors.blue,
              secondary: Colors.blueAccent,
            ),
            useMaterial3: true,
            appBarTheme: const AppBarTheme(
              centerTitle: true,
              elevation: 0,
            ),
            floatingActionButtonTheme: const FloatingActionButtonThemeData(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            ),
          ),
          initialRoute: '/',
          routes: {
            '/': (context) => const ConversationListScreen(),
            '/conversation': (context) {
              final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
              return ConversationDetailScreen(
                conversationId: args['conversationId'],
                contactName: args['contactName'],
              );
            },
          },
        ),
      ),
    );
  }
}
