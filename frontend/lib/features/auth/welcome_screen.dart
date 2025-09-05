import 'package:flutter/material.dart';
import '../../../core/utils/responsive_helper.dart';
import '../../../shared/widgets/responsive_layout.dart';
import 'login_screen.dart';
import 'signup_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ResponsiveLayoutBuilder(
        mobile: (context, constraints) => _buildMobileLayout(context),
        tablet: (context, constraints) => _buildTabletLayout(context),
        desktop: (context, constraints) => _buildDesktopLayout(context),
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return _WelcomeContent(
      showSideBySideButtons: false,
      backgroundHeight: MediaQuery.of(context).size.height * 0.6,
    );
  }

  Widget _buildTabletLayout(BuildContext context) {
    return _WelcomeContent(
      showSideBySideButtons: true,
      backgroundHeight: MediaQuery.of(context).size.height * 0.5,
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 1200),
        child: Row(
          children: [
            // Left side - Map background
            Expanded(
              flex: 3,
              child: Container(
                height: MediaQuery.of(context).size.height,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/africa_map_background.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.3),
                        Colors.black.withOpacity(0.7),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            // Right side - Welcome content
            Expanded(
              flex: 2,
              child: Container(
                padding: const EdgeInsets.all(48),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Welcome to Catalystic Wanders',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    _buildLanguageSelector(context),
                    const SizedBox(height: 40),
                    _buildAuthButtons(context, showSideBySide: false),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WelcomeContent extends StatelessWidget {
  final bool showSideBySideButtons;
  final double backgroundHeight;

  const _WelcomeContent({
    required this.showSideBySideButtons,
    required this.backgroundHeight,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Background image with overlay
          Container(
            height: backgroundHeight,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/africa_map_background.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.3),
                    Colors.black.withOpacity(0.7),
                  ],
                ),
              ),
            ),
          ),

          // Content section
          Container(
            padding: ResponsiveHelper.getResponsivePadding(context),
            child: Column(
              children: [
                const SizedBox(height: 20),
                Text(
                  'Welcome to Catalystic Wanders',
                  style: ResponsiveHelper.isMobile(context)
                      ? Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                        )
                      : Theme.of(context).textTheme.headlineLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                        ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                _buildLanguageSelector(context),
                const SizedBox(height: 40),
                _buildAuthButtons(context, showSideBySide: showSideBySideButtons),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Widget _buildLanguageSelector(BuildContext context) {
  return GestureDetector(
    onTap: () => _showLanguageDialog(context),
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.language,
            color: Theme.of(context).primaryColor,
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(
            'Language',
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 8),
          Icon(
            Icons.arrow_drop_down,
            color: Theme.of(context).primaryColor,
            size: 20,
          ),
        ],
      ),
    ),
  );
}

Widget _buildAuthButtons(BuildContext context, {required bool showSideBySide}) {
  final emailButton = _AuthButton(
    text: 'Continue with email',
    icon: Icons.email_outlined,
    onPressed: () => _navigateToLogin(context),
    isPrimary: true,
  );

  final googleButton = _AuthButton(
    text: 'Continue with Google',
    icon: Icons.g_mobiledata,
    onPressed: () => _handleGoogleSignIn(context),
    isPrimary: false,
  );

  final signUpText = TextButton(
    onPressed: () => _navigateToSignUp(context),
    child: RichText(
      text: TextSpan(
        text: "Don't have an account? ",
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: Colors.grey[600],
        ),
        children: [
          TextSpan(
            text: 'Sign up',
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    ),
  );

  if (showSideBySide && ResponsiveHelper.isTablet(context)) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: emailButton),
            const SizedBox(width: 16),
            Expanded(child: googleButton),
          ],
        ),
        const SizedBox(height: 24),
        signUpText,
      ],
    );
  }

  return Column(
    children: [
      emailButton,
      const SizedBox(height: 16),
      googleButton,
      const SizedBox(height: 24),
      signUpText,
    ],
  );
}

class _AuthButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback onPressed;
  final bool isPrimary;

  const _AuthButton({
    required this.text,
    required this.icon,
    required this.onPressed,
    required this.isPrimary,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isPrimary
              ? Theme.of(context).primaryColor
              : Colors.white,
          foregroundColor: isPrimary
              ? Colors.white
              : Colors.black87,
          elevation: isPrimary ? 2 : 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
            side: isPrimary
                ? BorderSide.none
                : BorderSide(color: Colors.grey.withOpacity(0.3)),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 20),
            const SizedBox(width: 12),
            Text(
              text,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void _navigateToLogin(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const LoginScreen()),
  );
}

void _navigateToSignUp(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const SignUpScreen()),
  );
}

void _handleGoogleSignIn(BuildContext context) {
  // Implement Google Sign-In logic
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text('Google Sign-In integration coming soon'),
    ),
  );
}

void _showLanguageDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Select Language'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Text('🇺🇸', style: TextStyle(fontSize: 20)),
            title: const Text('English'),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: const Text('🇿🇦', style: TextStyle(fontSize: 20)),
            title: const Text('Afrikaans'),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: const Text('🇿🇦', style: TextStyle(fontSize: 20)),
            title: const Text('isiZulu'),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: const Text('🇿🇦', style: TextStyle(fontSize: 20)),
            title: const Text('Sesotho'),
            onTap: () => Navigator.pop(context),
          ),
        ],
      ),
    ),
  );
}
