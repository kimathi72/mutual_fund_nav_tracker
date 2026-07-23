import { View, Text, Pressable, StyleSheet } from "react-native";

interface ErrorViewProps {
  message?: string;
  onRetry?: () => void;
}

export function ErrorView({
  message = "Something went wrong.",
  onRetry,
}: ErrorViewProps) {
  return (
    <View style={styles.container}>
      <Text style={styles.message}>
        {message}
      </Text>

      {onRetry && (
        <Pressable
          style={styles.button}
          onPress={onRetry}
        >
          <Text style={styles.buttonText}>
            Retry
          </Text>
        </Pressable>
      )}
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: "center",
    alignItems: "center",
    padding: 24,
  },

  message: {
    fontSize: 16,
    textAlign: "center",
    marginBottom: 16,
  },

  button: {
    paddingHorizontal: 20,
    paddingVertical: 10,
    borderRadius: 8,
    backgroundColor: "#1D4ED8",
  },

  buttonText: {
    color: "#fff",
    fontWeight: "600",
  },
});