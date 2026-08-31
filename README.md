# 📸 PHOTOISM / PHOTOBOOT PLATFORM

> Commercial-Grade Flutter Photobooth Platform (Desktop Kiosk + Mobile Web/PWA + Real-time AR Filters + Face Beauty + Photo Strip Compositor)

---

## 🌟 Highlights & Features

- 📸 **Camera & Real-time Live Preview**: Cross-platform WebGL & Native camera capture pipeline with instant countdown timer.
- 🌸 **Face Beauty & Retouching**: Built-in 5 beauty modes (Natural Skin, Porcelain Glow, K-Pop Idol Retouch, Eye & Lip Sharpness).
- 🎨 **Color Matrix Filters**: B&W Vintage, 70s Retro, Cyber Neon, Soft Glow, and Beauty Shaders applied at 100% pixel-level accuracy.
- 👑 **AR Vector Props & Tracking**: Live AR props (Royal Crown 👑, Sunglasses 🕶️, Bunny Ears 🐰, Devil Horns 😈, Floating Hearts ❤️, Fire Aura 🔥) dynamically drawn over face coordinates.
- 🖼️ **Real-time Layout Strip Preview**: Life4Cuts / Photoism style live strip builder — captured photos immediately populate into Khổ 8, Khổ 3, and 4-Cut layout slots as you shoot.
- 📲 **Guest Web Gallery & QR Download**: Instant QR code generation linking guests directly to mobile web PWA gallery.
- 🖨️ **300 DPI Thermal Printing & Sync**: Integrated background sync worker and printer interface.
- 🌐 **Vercel Web Deployment**: Fully configured for single-command production deployment on Vercel.

---

## 🚀 Live Demo & Local Development

### 1. Web Local Development
```bash
cd apps/booth_app
flutter build web --release
npx serve -s build/web -l 8080
```
Open `http://localhost:8080` in your browser.

### 2. Backend Server Development
```bash
cd apps/backend
npm install
npm start
```
Runs API server on `http://localhost:4000`.

---

## 🌐 Deploy to Vercel

```bash
# Push latest changes to GitHub
git add .
git commit -m "feat: updates for Vercel deployment"
git push origin main
```

**Vercel Settings**:
- **Framework**: Other
- **Root Directory**: `apps/booth_app`
- **Build Command**: `flutter build web --release`
- **Output Directory**: `build/web`

---

## 🛠️ Architecture Overview

```
apps/
├── booth_app/           # Flutter Clean Architecture Client App
│   ├── lib/
│   │   ├── core/       # Shaders, Theme, Storage, Storage Utils
│   │   ├── features/   # Photo, Session, Effects, Admin, Gallery
│   └── web/            # MediaPipe JS & AR Canvas Renderer
└── backend/            # Fastify / Express TypeScript API Server
```
