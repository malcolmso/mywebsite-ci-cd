document.addEventListener("DOMContentLoaded", () => {
  document.getElementById("signupButton").addEventListener("click", signUp);
  document.getElementById("loginButton").addEventListener("click", signIn);
});

async function signUp() {
  const email = document.getElementById("email").value.trim();
  const password = document.getElementById("password").value.trim();

  if (!email || !password) {
    showOutput("❗ Please enter both email and password.");
    return;
  }

  try {
    const { user } = await Amplify.Auth.signUp({
      username: email,
      password
    });
    showOutput(`✅ Signed up as: ${user.getUsername()}`);
  } catch (err) {
    showOutput(`❌ Sign-Up Error: ${err.message}`);
  }
}

async function signIn() {
  const email = document.getElementById("email").value.trim();
  const password = document.getElementById("password").value.trim();

  if (!email || !password) {
    showOutput("❗ Please enter both email and password.");
    return;
  }

  try {
    const user = await Amplify.Auth.signIn(email, password);
    showOutput(`✅ Logged in as: ${user.username}`);
    window.location.href = "thank-you.html";
  } catch (err) {
    showOutput(`❌ Login Error: ${err.message}`);
  }
}

function showOutput(message) {
  document.getElementById("output").textContent = `Status: ${message}`;
}
