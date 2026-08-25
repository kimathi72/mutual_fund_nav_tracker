import axios from "axios";

const api = axios.create({
  baseURL: "http://localhost:3000/api/v1",
  timeout: 15000,
  headers: {
    Accept: "application/json",
    "Content-Type": "application/json",
  },
});

api.interceptors.response.use(
  (response) => response,

  (error) => {
    console.error(
      "API Error:",
      error.response?.status,
      error.response?.data
    );

    return Promise.reject(error);
  }
);

export default api;