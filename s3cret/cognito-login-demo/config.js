// Initialize Amplify with Cognito User Pool settings
Amplify.configure({
  Auth: {
    // AWS Region where your Cognito User Pool lives
    region: "us-east-1",

    // Your Cognito User Pool ID
    userPoolId: "us-east-1_H5qjYEHZW",

    // Your Cognito App Client ID
    userPoolWebClientId: "73l9nta00if35u49e0t46fdahq",

    // Optional: Enables cookie storage for session tracking
    storage: window.localStorage,

    // Optional: Customize authentication flow
    authenticationFlowType: "USER_PASSWORD_AUTH"
  }
});
