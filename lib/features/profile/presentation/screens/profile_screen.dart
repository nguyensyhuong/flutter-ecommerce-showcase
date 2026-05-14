import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../../auth/presentation/providers/auth_providers.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);
    final user = authState.session?.user;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (user == null) {
      return _EmptyProfile(onLogin: () => context.go('/login'));
    }

    final accessToken = authState.session?.accessToken ?? '';

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 60,
            backgroundColor: colorScheme.surface,
            title: const Text('Profile'),
            actions: [
              IconButton(
                onPressed: () {
                  ref.read(authControllerProvider.notifier).logout();
                  context.go('/login');
                },
                icon: const Icon(Icons.logout_rounded),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      colorScheme.primary.withValues(alpha: 0.95),
                      colorScheme.secondary.withValues(alpha: 0.88),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: colorScheme.surface,
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color: colorScheme.outlineVariant.withValues(
                          alpha: 0.35,
                        ),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.08),
                          blurRadius: 24,
                          offset: const Offset(0, 14),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: colorScheme.primary.withValues(
                                    alpha: 0.2,
                                  ),
                                  width: 2,
                                ),
                              ),
                              child: CircleAvatar(
                                radius: 34,
                                backgroundColor:
                                    colorScheme.surfaceContainerHighest,
                                child: ClipOval(
                                  child: CachedNetworkImage(
                                    imageUrl: user.image,
                                    width: 68,
                                    height: 68,
                                    fit: BoxFit.cover,
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.person, size: 32),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    user.displayName,
                                    style: theme.textTheme.headlineSmall
                                        ?.copyWith(fontWeight: FontWeight.w900),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    '@${user.username}',
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Wrap(
                                    spacing: 8,
                                    runSpacing: 8,
                                    children: [
                                      _MiniChip(
                                        icon: Icons.verified_rounded,
                                        label: 'Verified user',
                                        colorScheme: colorScheme,
                                      ),
                                      _MiniChip(
                                        icon: Icons.shopping_bag_outlined,
                                        label: 'Shop ready',
                                        colorScheme: colorScheme,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 18),
                        Text(
                          user.email,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: _MetricCard(
                          title: 'User ID',
                          value: '${user.id}',
                          icon: Icons.badge_outlined,
                          colorScheme: colorScheme,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _MetricCard(
                          title: 'Gender',
                          value: user.gender,
                          icon: Icons.transgender_outlined,
                          colorScheme: colorScheme,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _SectionTitle(title: 'Account', colorScheme: colorScheme),
                  const SizedBox(height: 12),
                  _ActionTile(
                    icon: Icons.lock_outline_rounded,
                    title: 'Access token',
                    subtitle: accessToken.isEmpty
                        ? 'Not available'
                        : '${accessToken.substring(0, accessToken.length > 24 ? 24 : accessToken.length)}...',
                    colorScheme: colorScheme,
                  ),
                  _ActionTile(
                    icon: Icons.refresh_rounded,
                    title: 'Session refresh',
                    subtitle: authState.session?.refreshToken.isNotEmpty == true
                        ? 'Enabled'
                        : 'Unavailable',
                    colorScheme: colorScheme,
                  ),
                  _ActionTile(
                    icon: Icons.logout_rounded,
                    title: 'Logout',
                    subtitle: 'Clear your session and go back to login',
                    colorScheme: colorScheme,
                    destructive: true,
                    onTap: () {
                      ref.read(authControllerProvider.notifier).logout();
                      context.go('/login');
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyProfile extends StatelessWidget {
  const _EmptyProfile({required this.onLogin});

  final VoidCallback onLogin;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(28),
              border: Border.all(
                color: colorScheme.outlineVariant.withValues(alpha: 0.35),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer.withValues(alpha: 0.8),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.person_outline_rounded,
                    size: 42,
                    color: colorScheme.onPrimaryContainer,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'No profile loaded',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Sign in to view your account details, token state, and profile summary.',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 18),
                FilledButton.icon(
                  onPressed: onLogin,
                  icon: const Icon(Icons.login_rounded),
                  label: const Text('Go to login'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.colorScheme,
  });

  final String title;
  final String value;
  final IconData icon;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.32),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: colorScheme.primary),
          const SizedBox(height: 12),
          Text(
            title,
            style: theme.textTheme.labelLarge?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title, required this.colorScheme});

  final String title;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.w900,
        color: colorScheme.onSurface,
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.colorScheme,
    this.destructive = false,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final ColorScheme colorScheme;
  final bool destructive;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final textColor = destructive ? colorScheme.error : colorScheme.onSurface;
    final subtitleColor = destructive
        ? colorScheme.error.withValues(alpha: 0.8)
        : colorScheme.onSurfaceVariant;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(22),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(22),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: colorScheme.outlineVariant.withValues(alpha: 0.35),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: destructive
                        ? colorScheme.errorContainer.withValues(alpha: 0.6)
                        : colorScheme.primaryContainer.withValues(alpha: 0.65),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    icon,
                    color: destructive
                        ? colorScheme.onErrorContainer
                        : colorScheme.onPrimaryContainer,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              fontWeight: FontWeight.w800,
                              color: textColor,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: subtitleColor,
                          height: 1.35,
                        ),
                      ),
                    ],
                  ),
                ),
                if (onTap != null)
                  Icon(Icons.chevron_right_rounded, color: subtitleColor),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MiniChip extends StatelessWidget {
  const _MiniChip({
    required this.icon,
    required this.label,
    required this.colorScheme,
  });

  final IconData icon;
  final String label;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer.withValues(alpha: 0.65),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: colorScheme.onPrimaryContainer),
          const SizedBox(width: 6),
          Text(
            label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: colorScheme.onPrimaryContainer,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
