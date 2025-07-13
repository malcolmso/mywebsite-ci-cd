# 🌐 malcolmsoto.com

Welcome to my personal tech blog and portfolio — a home for engineering insights, cloud workflows, and infrastructure mastery.

Each article is handcrafted in lightweight HTML, then deployed through AWS S3 + CloudFront using GitHub Actions for seamless CI/CD.

## 📚 Topics I Dive Into
- 🔹 AWS architectures and automations
- 🔹 Proxmox setups and server orchestration
- 🔹 Terraform workflows and infra-as-code experiments

## 🔧 Tech Stack
- 🚀 AWS S3 + CloudFront (blazing-fast global delivery)
- 🔄 GitHub Actions for CI/CD deployment
- ⚙️ Static site powered by clean, modular HTML

---

Check out my latest articles in the `articles/` folder or visit the live site: [malcolmsoto.com](https://malcolmsoto.com)

Want to collaborate or connect? Reach me on [LinkedIn](https://www.linkedin.com/in/malcolm-soto/)

------------------------------------------

## 📝 How to Add a New Article

Whenever you want to publish a new `.docx` article, follow these steps:

---

### 1. Drop the `.docx` File

Place your article file into the `articles/` directory.

Example: articles/My Next Guide.docx


---

### 2. Convert to HTML

Run the conversion script to generate a styled `.html` version with extracted images:

# python zConvertDocxToHtml.py


✅ This will:
- Create `articles/My Next Guide.html`
- Save all images to `assets/images/`
- Wrap the content using your layout and theme

---

### 3. 📇 Regenerate the Blog Inde

Update `blog.html` to reflect your latest articles:

# python zGenerateBlogIndex.py


✅ This will:
- Scan all `.html` files in `articles/`
- Extract a preview from each
- Inject links into a styled, layout-consistent index

---

### 4. 👀 Preview Locally (Optional)

Open the files directly in a browser:

blog.html articles/My Next Guide.html

Or launch VS Code Live Preview for full folder-aware browsing.

---

### 5. 🚀 Push to GitHu

After confirming layout and content:
Commit and push your updates so they sync with your CI/CD pipeline:

# git add articles/ assets/images/ blog.html
# git commit -m "🆕 Added: My Next Guide"
# git push


✅ Your GitHub Actions workflow will:
- Sync updates to your S3 bucket
- Invalidate CloudFront caches (if enabled)
- Show the new content live within seconds


Your site updates instantly.

---

### 🧠 Bonus Tips

- ✔️ Use clear filenames (e.g. `cloudfront-tutorial.docx`) to help organize articles
- 🖼️ Avoid Snipping Tool black outlines — crop or clean images before saving
- 🏷 Want to add categories, timestamps, or captions? The system is ready to expand
