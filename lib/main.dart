
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'authentication/blocs/blocs.dart';
import 'authentication/repository/repository.dart';
import 'localization/localization.dart';
import 'login/login.dart';
import 'posts/cubits/cubits.dart';
import 'posts/posts.dart';
import 'signup/blocs/blocs.dart';
import 'signup/signup.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MultiRepositoryProvider(
        providers: [
          RepositoryProvider<AuthenticationRepository>(
            create: (context) => AuthenticationRepository(),
          ),
          RepositoryProvider<PostRepository>(
              create: (context) => PostRepository(),
          ),
        ],
        child:
              MultiBlocProvider(
                  providers: [
                    BlocProvider<AuthenticationBloc>(
                      create: (context) {
                         AuthenticationRepository authenticationRepository = RepositoryProvider.of<AuthenticationRepository>(context);
                         return AuthenticationBloc(repository: authenticationRepository)
                            ..add(AppLoaded());
                      }
                    ),
                    BlocProvider<LoginBloc>(create: (context) {
                        AuthenticationBloc authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);
                        AuthenticationRepository authenticationRepository = RepositoryProvider.of<AuthenticationRepository>(context);

                        return LoginBloc(authenticationBloc: authenticationBloc, authenticationRepository: authenticationRepository);
                      }
                    ),

                    BlocProvider<SignUpBloc>(create: (context) {
                      AuthenticationBloc authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);
                      AuthenticationRepository authenticationRepository = RepositoryProvider.of<AuthenticationRepository>(context);

                      return SignUpBloc(authenticationBloc: authenticationBloc, authenticationRepository: authenticationRepository);
                    }
                    ),

                    BlocProvider<PostListCubit>(
                      create: (context) {
                        PostRepository postRepository = RepositoryProvider.of<PostRepository>(context);
                        return PostListCubit(repository: postRepository);
                      }
                    ),
                    BlocProvider<PostCubit>(
                      create: (context) {
                        PostRepository postRepository = RepositoryProvider.of<
                            PostRepository>(context);
                        return PostCubit(repository: postRepository);
                      }
                    ),
                    BlocProvider<LocaleBloc>(
                        create: (context) => LocaleBloc()..add(LanguageLoadStarted())
                    ),
                  ],
                  child: MyApp(),
              ),
    )
  );

}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() {
     return _MyAppState();
  }

}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          if (state is AuthenticationAuthenticated) {
            return BlocBuilder<LocaleBloc, LocaleState>(
                buildWhen: (previousState, currentState) =>
                previousState != currentState,
                builder: (_, localeState) {
                  return MaterialApp(
                      title: 'Starter App',
                      theme: ThemeData(
                        primarySwatch: Colors.blue,
                      ),
                      supportedLocales: AppLocalizationsSetup.supportedLocales,
                      localizationsDelegates: AppLocalizationsSetup.localizationsDelegates,
                      localeResolutionCallback: AppLocalizationsSetup
                          .localeResolutionCallback,
                      // Each time a new state emitted, the app will be rebuilt with the new
                      // locale.
                      locale: localeState.locale,
                      home: MyHomePage(title: "Posts"),
                  );
                  }
            );
          } else if(state is RedirectToSignUpPage){
            return BlocBuilder<LocaleBloc, LocaleState>(
                buildWhen: (previousState, currentState) =>
                previousState != currentState,
                builder: (_, localeState) {
                  return MaterialApp(
                      title: 'Starter App',
                      theme: ThemeData(
                        primarySwatch: Colors.blue,
                      ),
                      supportedLocales: AppLocalizationsSetup.supportedLocales,
                      localizationsDelegates: AppLocalizationsSetup.localizationsDelegates,
                      localeResolutionCallback: AppLocalizationsSetup
                          .localeResolutionCallback,
                      // Each time a new state emitted, the app will be rebuilt with the new
                      // locale.
                      locale: localeState.locale,
                      home: SignUpPage(title: "",)
                  );
                }
            );
          }else{
            return BlocBuilder<LocaleBloc, LocaleState>(
                buildWhen: (previousState, currentState) =>
                previousState != currentState,
                builder: (_, localeState) {
                  return MaterialApp(
                      title: 'Starter App',
                      theme: ThemeData(
                        primarySwatch: Colors.blue,
                      ),
                      supportedLocales: AppLocalizationsSetup.supportedLocales,
                      localizationsDelegates: AppLocalizationsSetup.localizationsDelegates,
                      localeResolutionCallback: AppLocalizationsSetup
                          .localeResolutionCallback,
                      // Each time a new state emitted, the app will be rebuilt with the new
                      // locale.
                      locale: localeState.locale,
                      home: LoginPage()
                  );

                      }
                );
          }
        }

    );

  }

}


