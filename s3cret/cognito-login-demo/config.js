Amplify.configure({
  Auth: {
    region: "us-east-1",
    userPoolId: "us-east-1_H5qjYEHZW",
    userPoolWebClientId: "73l9nta00if35u49e0t46fdahq",
    storage: window.localStorage,
    authenticationFlowType: "USER_PASSWORD_AUTH"
  }
});
