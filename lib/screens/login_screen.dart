import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sw2_parcial1_movil/screens/screens.dart';
import 'package:sw2_parcial1_movil/services/services.dart';
import 'package:sw2_parcial1_movil/theme/app_theme.dart';
import 'package:sw2_parcial1_movil/utils/utils.dart';
import 'package:sw2_parcial1_movil/widgets/widgets.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    return Scaffold(
        body: ListView(
      padding: EdgeInsets.only(top: 0),
      physics: BouncingScrollPhysics(),
      children: [
        Stack(
          children: [HeaderLogin(), LogoHeader()],
        ),
        _Titulo(),
        SizedBox(height: 40),
        Form(
          key: _formKey,
          child: Column(
            children: [
              _EmailAndPassword(
                  emailController: _emailController,
                  passwordController: _passwordController),
              _ForgotPassword(),
              const SizedBox(height: 40),
              Container(
                margin: const EdgeInsets.all(25),
                decoration: BoxDecoration(
                    color: AppTheme.primaryColor,
                    borderRadius: BorderRadius.circular(50)),
                    width: double.infinity ,
                child: TextButton(
                  onPressed: authService.isLoading
                      ? null
                      : () async {
                          if (_formKey.currentState?.validate() ?? false) {
                            final email = _emailController.text.trim();
                            final password = _passwordController.text.trim();
                            //print(email);
                            final succes =
                                await authService.login(email, password);
                            if (succes) {
                              if (context.mounted) {
                                Navigator.pushReplacementNamed(context, 'home');
                              }
                            } else {
                              if (context.mounted) {
                                displayDialog(
                                    context,
                                    'Error de inicio de Sesion',
                                    'Email o contraseña incorrectos',
                                    Icons.error,
                                    Colors.red);
                              }
                            }
                          }
                        },
                  child:  TextFrave(
                    text: authService.isLoading 
                        ? 'Espere...' 
                        : 'SIGN IN',
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    ));
  }
}

/* class _BottonSignIn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(25),
      decoration: BoxDecoration(
          color: Color(0xff5511b0), borderRadius: BorderRadius.circular(50)),
      child: TextButton(
        child:
            const TextFrave(text: 'SIGN IN', color: Colors.white, fontSize: 18),
        onPressed: () {},
      ),
    );
  }
} */

class _ForgotPassword extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(right: 25, top: 20),
      alignment: Alignment.centerRight,
      child: const TextFrave(text: 'Forgot Password?'),
    );
  }
}

class _EmailAndPassword extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;

  const _EmailAndPassword(
      {required this.emailController, required this.passwordController});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        children: [
          TextFieldCustom(
            icono: Icons.mail_outline,
            type: TextInputType.emailAddress,
            texto: 'Email Address',
            controller: emailController,
            errorMessagge: 'Ingrese su Email',
            
          ),
          const SizedBox(height: 20),
          TextFieldCustom(
            icono: Icons.visibility_off,
            type: TextInputType.text,
            pass: true,
            texto: 'Password',
            controller: passwordController,
            errorMessagge: 'Ingrese su Contraseña',
          ),
        ],
      ),
    );
  }
}

class _Titulo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Row(
        children: [
          const TextFrave(
              text: 'SIGN IN', fontSize: 25, fontWeight: FontWeight.bold),
          const TextFrave(text: '/', fontSize: 25, color: Colors.grey),
          TextButton(
              onPressed: () => Navigator.of(context)
                  .push(MaterialPageRoute(builder: (_) => SingUpScreen())),
              child: const TextFrave(
                  text: 'SIGN UP',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey))
        ],
      ),
    );
  }
}
