import axios from "axios";

const API_URL = process.env.EXPO_PUBLIC_API_URL;

if (!API_URL) {
  console.warn("EXPO_PUBLIC_API_URL is not configured");
}

const api = axios.create({
  baseURL: API_URL,
  timeout: 15000,
  headers: {
    Accept: "application/json",
    "Content-Type": "application/json",
  },
});

api.interceptors.response.use(
  (response) => response,
  (error) => {
    return Promise.reject(error);
  },
);

export default api;