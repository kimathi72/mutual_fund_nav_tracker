import axios from "axios";

const api = axios.create({
  baseURL: "http://localhost:3000/api/v1",
  timeout: 15000,
});

api.interceptors.response.use(
  response => response,
  error => {
    console.log(error.response?.data);

    return Promise.reject(error);
  }
);

export default api;