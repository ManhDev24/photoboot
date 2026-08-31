/**
 * Photobooth Platform — Decoupled AR WebGL / Canvas Renderer
 * Renders video frames, face anchored props, stickers, makeup overlays, and particle triggers.
 */

window.PhotoboothARRenderer = {
  activeEffect: 'none',
  particles: [],

  setEffect: function(effectId) {
    this.activeEffect = effectId;
    if (effectId === 'hearts') {
      this.spawnHeartParticles(30);
    }
  },

  setVideoFilter: function(filterCss) {
    this.applyGlobalCameraFilter(filterCss);
  },

  applyGlobalCameraFilter: function(cssFilter) {
    let styleEl = document.getElementById('flt-camera-filter-style');
    if (!styleEl) {
      styleEl = document.createElement('style');
      styleEl.id = 'flt-camera-filter-style';
      document.head.appendChild(styleEl);
    }
    if (!cssFilter || cssFilter === 'none') {
      styleEl.innerHTML = '';
    } else {
      styleEl.innerHTML = `
        video, flt-platform-view, flt-platform-view-slot, [flt-platform-view], canvas {
          filter: ${cssFilter} !important;
          -webkit-filter: ${cssFilter} !important;
        }
      `;
    }
  },

  spawnHeartParticles: function(count) {
    this.particles = [];
    for (let i = 0; i < count; i++) {
      this.particles.push({
        x: Math.random() * 800,
        y: 600 + Math.random() * 100,
        vy: -2 - Math.random() * 4,
        vx: (Math.random() - 0.5) * 2,
        size: 20 + Math.random() * 25,
        opacity: 1.0,
        color: '#EC4899'
      });
    }
  },

  renderFrame: function(canvasContext, videoElement, landmarks) {
    if (!canvasContext || !videoElement) return;

    const width = canvasContext.canvas.width;
    const height = canvasContext.canvas.height;

    // Draw video background frame
    canvasContext.drawImage(videoElement, 0, 0, width, height);

    // Draw Face Anchored AR Effect
    if (landmarks && landmarks.forehead) {
      const fh = landmarks.forehead;
      const eyeL = landmarks.leftEye;
      const eyeR = landmarks.rightEye;
      const faceWidth = Math.abs(eyeR.x - eyeL.x) * width;

      if (this.activeEffect === 'crown') {
        canvasContext.font = `${faceWidth * 1.2}px serif`;
        canvasContext.textAlign = 'center';
        canvasContext.fillText('👑', fh.x * width, fh.y * height - 20);
      } else if (this.activeEffect === 'glasses') {
        const eyeCenterX = (eyeL.x + eyeR.x) / 2 * width;
        const eyeCenterY = (eyeL.y + eyeR.y) / 2 * height;
        canvasContext.font = `${faceWidth * 1.1}px serif`;
        canvasContext.textAlign = 'center';
        canvasContext.fillText('😎', eyeCenterX, eyeCenterY + 10);
      } else if (this.activeEffect === 'bunny') {
        canvasContext.font = `${faceWidth * 1.4}px serif`;
        canvasContext.textAlign = 'center';
        canvasContext.fillText('🐰', fh.x * width, fh.y * height - 30);
      }
    }

    // Render Particle Systems (e.g. Hearts)
    if (this.particles.length > 0) {
      for (let i = this.particles.length - 1; i >= 0; i--) {
        const p = this.particles[i];
        p.y += p.vy;
        p.x += p.vx;
        p.opacity -= 0.015;

        canvasContext.save();
        canvasContext.globalAlpha = Math.max(0, p.opacity);
        canvasContext.font = `${p.size}px serif`;
        canvasContext.fillText('❤️', p.x, p.y);
        canvasContext.restore();

        if (p.opacity <= 0) {
          this.particles.splice(i, 1);
        }
      }
    }
  }
};
