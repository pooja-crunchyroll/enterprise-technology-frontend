import nookies from "nookies";

export const userIsLoggedIn = async (cookies: any) => {
  try {
    if (cookies.token) {
      return cookies.token != "";
    } else {
      return false;
    }
  } catch (error) {
    return false;
  }
};
