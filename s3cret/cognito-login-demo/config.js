import { UserManager } from "oidc-client-ts";

export const userManager = new UserManager({
  authority: "https://cognito-idp.us-east-1.amazonaws.com/us-east-1_H5qjYEHZW",
  client_id: "73l9nta00if35u49e0t46fdahq",
  redirect_uri: "https://malcolmsoto.com/s3cret/cognito-login-demo/thank-you.html",
  response_type: "code",
  scope: "email openid phone"
});
