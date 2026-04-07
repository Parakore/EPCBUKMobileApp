import 'package:flutter/material.dart';

class AppLoader extends StatelessWidget {
  final String? message;
  final bool isDark;

  const AppLoader({super.key, this.message, this.isDark = false});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: isDark ? Colors.white : Theme.of(context).primaryColor,
          ),
          if (message != null) ...[
            const SizedBox(height: 16),
            Text(
              message!,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: isDark
                        ? Colors.white70
                        : Theme.of(context).primaryColor,
                  ),
            ),
          ],
        ],
      ),
    );
  }
}
