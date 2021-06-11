import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:starterapp/localization/localization.dart';

import '../login.dart';

class LoginPage extends StatefulWidget {


  LoginPage();

  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => LoginPage());
  }

  @override
  _LoginPageState createState() {
    return _LoginPageState();
  }

}

class _LoginPageState extends State<LoginPage>{

  _LoginPageState();

  @override
  Widget build(BuildContext context) {
    return BlocListener<LocaleBloc, LocaleState>(
       listener: (context, state) {
         print('current locale ${state.locale}');
       },
       child: BlocBuilder<LocaleBloc, LocaleState>(
         builder: (context, state){
           return Scaffold(
               appBar: AppBar(
                 title: Text(AppLocalizations.of(context).translate('login'), style: TextStyle(fontSize: 16,)),
                 actions: [
                   IconButton(
                     icon: Image.asset(AppLocalizations.of(context).isEnLocale? "assets/images/language.png" : "assets/images/myanmar_lan.png",  width: 20, height: 20,),
                     onPressed: () async {
                       context.read<LocaleBloc>().add(ToggleLanguage(newLanguage: AppLocalizations.of(context).isEnLocale? 'my' : 'en'));
                     },
                   ),

                 ],
               ),
               body: SafeArea(
                   minimum: const EdgeInsets.all(16),
                   child: Container(
                     alignment: Alignment.center,
                     child: _SignInForm(),
                   )
               )
           );
         },
       )
    );

  }

}
class _SignInForm extends StatefulWidget {
  @override
  __SignInFormState createState() => __SignInFormState();
}

class __SignInFormState extends State<_SignInForm> {
  @override
  Widget build(BuildContext context) {

    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state.status.isSubmissionFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(content: Text(state.errorMessage)),
            );
        }
      },
      child: BlocBuilder<LoginBloc, LoginState>(
        builder: (context, state) {
          return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                 _EmailInput(),
                  SizedBox(
                    height: 12,
                  ),
                  _PasswordInput(),
                  const SizedBox(
                    height: 16,
                  ),

                  _LoginButton(),
                  const SizedBox(height: 8.0),
                  const SizedBox(height: 4),
                  _SignUpButton(),
                ],
              ),
          );
        },
      ),
    );
  }
}

class _EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        return TextField(
          key: const Key('loginForm_emailInput_textField'),
          onChanged: (password) =>
              context.read<LoginBloc>().add(LoginEmailChanged(password)),
          obscureText: false,
          decoration: InputDecoration(
            labelText: AppLocalizations.of(context).translate('email'),
            helperText: '',
            errorText: state.email.invalid ? AppLocalizations.of(context).translate('invalid_email') : null,
          ),
        );
      },
    );
  }
}

class _PasswordInput extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) {
        return TextField(
          key: const Key('loginForm_passwordInput_textField'),
          onChanged: (password) =>
              context.read<LoginBloc>().add(LoginPasswordChanged(password)),
          obscureText: true,
          decoration: InputDecoration(
            labelText: AppLocalizations.of(context).translate('password'),
            helperText: '',
            errorText: state.password.invalid ? AppLocalizations.of(context).translate('invalid_password') : null,
          ),
        );
      },
    );
  }

}

class _LoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return  state.status.isSubmissionInProgress
            ? Container(
            child: Center(child: CircularProgressIndicator(),)
            )
            : ElevatedButton(
          key: const Key('loginForm_continue_raisedButton'),
          child: Text(AppLocalizations.of(context).translate('login_btn')),
          onPressed: state.status.isValidated? () {
            context.read<LoginBloc>().add(LoginInWithEmailButtonPressed());
          }
              : null,
        );
      },
    );
  }
}

class _SignUpButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    LoginBloc loginBloc = BlocProvider.of<LoginBloc>(context);
    final theme = Theme.of(context);
    return TextButton(
      key: const Key('loginForm_createAccount_flatButton'),
      onPressed: () => loginBloc.add(SignUpButtonPressed()),
      child: Text(
        AppLocalizations.of(context).translate('create_account'),
        style: TextStyle(color: theme.primaryColor),

      ),
    );
  }
}
