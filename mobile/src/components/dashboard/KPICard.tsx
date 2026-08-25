// components/dashboard/KPICard.tsx

import React from 'react';

import {
  Pressable,
  StyleSheet,
} from 'react-native';

import AppCard from '@/components/common/AppCard';
import AppText from '@/components/common/AppText';

import colors from '@/constants/colors';
import spacing from '@/constants/spacing';

interface Props {
  title: string;
  value: string | number;
  subtitle?: string;

  /**
   * Optional action.
   *
   * If supplied, the KPI becomes interactive.
   * If omitted, it behaves as a normal summary card.
   */
  onPress?: () => void;
}

export default function KPICard({
  title,
  value,
  subtitle,
  onPress,
}: Props) {
  const content = (
    <AppCard
      style={[
        styles.card,
        onPress && styles.interactiveCard,
      ]}
    >
      <AppText
        variant="heading"
        style={styles.value}
        numberOfLines={1}
      >
        {value}
      </AppText>

      <AppText
        variant="body"
        style={styles.title}
        numberOfLines={1}
      >
        {title}
      </AppText>

      {subtitle ? (
        <AppText
          variant="caption"
          color={colors.subtitle}
          style={styles.subtitle}
          numberOfLines={1}
        >
          {subtitle}
        </AppText>
      ) : null}
    </AppCard>
  );

  if (!onPress) {
    return content;
  }

  return (
    <Pressable
      onPress={onPress}
      accessibilityRole="button"
      style={({ pressed }) => [
        styles.pressable,
        pressed && styles.pressed,
      ]}
    >
      {content}
    </Pressable>
  );
}

const styles = StyleSheet.create({
  pressable: {
    flex: 1,
    minWidth: 0,
  },

  pressed: {
    opacity: 0.82,
  },

  card: {
    flex: 1,
    minWidth: 0,

    minHeight: 78,

    justifyContent: 'center',

    paddingHorizontal: spacing.md,
    paddingVertical: spacing.sm,
  },

  interactiveCard: {
    // Keeps room for future interactive styling
  },

  value: {
    color: colors.primary,

    fontSize: 22,
    lineHeight: 26,

    fontWeight: '700',

    marginBottom: 2,
  },

  title: {
    fontSize: 12,
    lineHeight: 16,

    fontWeight: '600',
  },

  subtitle: {
    fontSize: 10,
    lineHeight: 14,

    marginTop: 2,
  },
});