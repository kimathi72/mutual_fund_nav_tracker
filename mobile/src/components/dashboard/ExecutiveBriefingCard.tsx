// components/dashboard/ExecutiveBriefingCard.tsx

import React from 'react';
import { StyleSheet, View } from 'react-native';

import Markdown from 'react-native-markdown-display';

import AppCard from '@/components/common/AppCard';
import AppText from '@/components/common/AppText';

import colors from '@/constants/colors';
import spacing from '@/constants/spacing';

import type { ExecutiveBriefing } from '@/models/ExecutiveBriefing';

import formatDate from '@/utils/formatDate';
import statusColor from '@/utils/statusColor';

interface Props {
  briefing: ExecutiveBriefing;
}

export default function ExecutiveBriefingCard({
  briefing,
}: Props) {
  const hasError =
    briefing.status.toLowerCase() === 'error' &&
    Boolean(briefing.error);

  const content = hasError
    ? briefing.error ?? 'Unable to generate executive briefing.'
    : briefing.briefing;

  return (
    <AppCard style={styles.card}>
      <View style={styles.header}>
        <AppText
          variant="heading"
          style={styles.title}
        >
          Executive Briefing
        </AppText>

        <View
          style={[
            styles.badge,
            {
              backgroundColor: statusColor(
                briefing.status
              ),
            },
          ]}
        >
          <AppText
            variant="caption"
            color="#FFFFFF"
            style={styles.badgeText}
          >
            {briefing.status}
          </AppText>
        </View>
      </View>

      <View style={styles.markdownContainer}>
        <Markdown style={markdownStyles}>
          {content}
        </Markdown>
      </View>

      <View style={styles.footer}>
        <View style={styles.footerItem}>
          <AppText
            variant="caption"
            color={colors.subtitle}
          >
            Provider
          </AppText>

          <AppText
            variant="caption"
            style={styles.footerValue}
          >
            {briefing.provider}
          </AppText>
        </View>

        <View style={styles.footerItem}>
          <AppText
            variant="caption"
            color={colors.subtitle}
          >
            Model
          </AppText>

          <AppText
            variant="caption"
            style={styles.footerValue}
          >
            {briefing.model}
          </AppText>
        </View>

        <View
          style={[
            styles.footerItem,
            styles.footerItemLast,
          ]}
        >
          <AppText
            variant="caption"
            color={colors.subtitle}
          >
            Generated
          </AppText>

          <AppText
            variant="caption"
            style={styles.footerValue}
          >
            {formatDate(briefing.generated_at)}
          </AppText>
        </View>
      </View>
    </AppCard>
  );
}

const styles = StyleSheet.create({
  card: {
    marginHorizontal: spacing.md,
    marginBottom: spacing.lg,
  },

  header: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
  },

  title: {
    flex: 1,
    marginRight: spacing.md,
  },

  badge: {
    paddingHorizontal: spacing.sm,
    paddingVertical: spacing.xs,
    borderRadius: 20,
  },

  badgeText: {
    fontWeight: '600',
    textTransform: 'capitalize',
  },

  markdownContainer: {
    marginTop: spacing.md,
  },

  footer: {
    marginTop: spacing.lg,
    paddingTop: spacing.md,
    borderTopWidth: StyleSheet.hairlineWidth,
    borderTopColor: colors.border,
    flexDirection: 'row',
    justifyContent: 'space-between',
  },

  footerItem: {
    flex: 1,
    marginRight: spacing.md,
  },

  footerItemLast: {
    marginRight: 0,
    alignItems: 'flex-end',
  },

  footerValue: {
    marginTop: spacing.xs,
  },
});

const markdownStyles = StyleSheet.create({
  body: {
    color: colors.text,
    fontSize: 15,
    lineHeight: 23,
  },

  heading1: {
    color: colors.text,
    fontSize: 24,
    lineHeight: 30,
    fontWeight: '700',
    marginTop: spacing.md,
    marginBottom: spacing.sm,
  },

  heading2: {
    color: colors.text,
    fontSize: 20,
    lineHeight: 26,
    fontWeight: '700',
    marginTop: spacing.md,
    marginBottom: spacing.sm,
  },

  heading3: {
    color: colors.text,
    fontSize: 17,
    lineHeight: 23,
    fontWeight: '700',
    marginTop: spacing.md,
    marginBottom: spacing.xs,
  },

  paragraph: {
    color: colors.text,
    fontSize: 15,
    lineHeight: 23,
    marginTop: 0,
    marginBottom: spacing.sm,
  },

  strong: {
    fontWeight: '700',
    color: colors.text,
  },

  em: {
    fontStyle: 'italic',
  },

  bullet_list: {
    marginBottom: spacing.sm,
  },

  ordered_list: {
    marginBottom: spacing.sm,
  },

  list_item: {
    marginBottom: spacing.xs,
  },

  code_inline: {
    backgroundColor: colors.background,
    color: colors.primary,
    paddingHorizontal: spacing.xs,
  },

  fence: {
    backgroundColor: colors.background,
    borderColor: colors.border,
    borderWidth: StyleSheet.hairlineWidth,
    borderRadius: 8,
    padding: spacing.md,
    marginVertical: spacing.sm,
  },

  link: {
    color: colors.primary,
  },

  blockquote: {
    borderLeftColor: colors.primary,
    borderLeftWidth: 3,
    paddingLeft: spacing.md,
    marginVertical: spacing.sm,
  },

  table: {
    borderWidth: StyleSheet.hairlineWidth,
    borderColor: colors.border,
  },

  th: {
    backgroundColor: colors.background,
    fontWeight: '700',
    padding: spacing.sm,
  },

  td: {
    padding: spacing.sm,
    borderTopWidth: StyleSheet.hairlineWidth,
    borderColor: colors.border,
  },
});