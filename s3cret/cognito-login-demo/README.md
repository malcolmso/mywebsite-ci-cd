Target Directory: s3cret/cognito-login-demo

Inside the folder:

    index.html – Minimal UI: Email, Password, Login / Sign-Up buttons

    style.css – Styled for your hacker lab aesthetic

    app.js – Handles login / signup using AWS SDK or Amplify

    config.js – Stores Cognito pool info and region safely (no secrets)

    README.md – Optional walkthrough or setup instructions

Fastest Launch Strategy

starting from scratch:

    Create the user pool in AWS Cognito (with email-based login)

    Set up the hosted UI or embed directly

    Drop working code into s3cret/cognito-login-demo/

    Deploy to S3 or push via CloudFront

 #######
 🛠️ Step-by-Step: Cognito Setup for a Public Demo
1. 🧰 Create the User Pool

    Go to your AWS Console → Cognito → Create user pool

    Pool name: s3cret-lab-demo

    Attributes: Use just email (no phone or username)

    Enable email-based sign-up

    Disable MFA, for simplicity

    💡 You'll be able to delete this pool anytime — no long-term costs.

2. 🌐 App Client Settings

    In the pool, go to App integration → App clients

    Create an app client:

        Name: lab-client

        Disable client secret (needed for browser apps)

        Enable sign-in and sign-up flows

    Save the App client ID — you’ll plug this into config.js

3. 🔒 Set Up Domain

    Go to App integration → Domain name

    Use a unique subdomain like s3cret-lab-demo

    This gives you a login URL (in case you use hosted UI later)

4. 🧬 Update Your Code

In cognito-login-demo/config.js, drop in your pool info:

const awsConfig = {
  Auth: {
    region: "us-east-1", // or whatever your region is
    userPoolId: "us-east-1_abc123",         // from Cognito
    userPoolWebClientId: "abc123clientid",  // from App client
  }
};
Amplify.configure(awsConfig);

5. 🚀 Host Securely on S3

Upload your demo site to a public S3 bucket:

    No backends, no tokens, no secrets required

    Just static files + Amplify

    Use CloudFront if you want HTTPS or domain routing

    ☁️ Free-tier eligible, and no IAM keys embedded

🎯 End Result

Anyone who visits the page can sign up, log in, and see the flow — no backend or sensitive info involved. It’s exactly what a hiring manager or dev lead would want to see.

You want me to create dummy values to simulate the config file for staging? Or guide you through deployment with CLI? Let’s lock it in.
