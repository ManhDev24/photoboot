import express, { Request, Response } from 'express';
import cors from 'cors';

const app = express();
const PORT = process.env.PORT || 4000;

app.use(cors());
app.use(express.json());

// Health Status Endpoint
app.get('/api/v1/health', (req: Request, res: Response) => {
  res.json({
    status: 'ONLINE',
    service: 'Photobooth Platform API',
    timestamp: new Date().toISOString(),
    database: 'CONNECTED',
    storage: 'S3_READY'
  });
});

// Authentication
app.post('/api/v1/auth/login', (req: Request, res: Response) => {
  const { email, password } = req.body;
  res.json({
    accessToken: 'mock_jwt_token_admin',
    user: { id: 'usr_01', email, role: 'ADMIN', name: 'Photobooth Operator' }
  });
});

// Kiosk Activation
app.post('/api/v1/kiosk/activate', (req: Request, res: Response) => {
  const { eventSlug, kioskDeviceId } = req.body;
  res.json({
    eventId: 'evt_wedding_01',
    eventName: 'Wedding Anna & John',
    activeTemplate: {
      id: 'wedding_01',
      name: 'Wedding Elegant Pink',
      presetType: 'KHO_8',
      aspectRatio: '2:3'
    },
    status: 'ACTIVATED'
  });
});

// Photo Session Creation
app.post('/api/v1/sessions', (req: Request, res: Response) => {
  const { eventId, expectedPhotos } = req.body;
  const sessionId = `ses_${Date.now()}`;
  res.json({
    sessionId,
    eventId,
    expectedPhotos: expectedPhotos || 4,
    status: 'IN_PROGRESS',
    createdAt: new Date().toISOString()
  });
});

// Photo Session Completion & QR Token Generation
app.post('/api/v1/photos/complete', (req: Request, res: Response) => {
  const { sessionId } = req.body;
  const qrToken = `qr_${Math.random().toString(36).substring(2, 10)}`;
  res.json({
    sessionId,
    qrToken,
    qrUrl: `https://photobooth.app/q/${qrToken}`,
    digitalPhotoUrl: `https://storage.photobooth.app/final/${sessionId}.jpg`
  });
});

// Guest QR Gallery Resolution
app.get('/api/v1/gallery/qr/:qrToken', (req: Request, res: Response) => {
  const { qrToken } = req.params;
  res.json({
    qrToken,
    eventName: 'Wedding Anna & John',
    digitalUrl: 'https://images.unsplash.com/photo-1519741497674-611481863552',
    allowDownload: true,
    shareOptions: { instagram: true, facebook: true }
  });
});

app.listen(PORT, () => {
  console.log(`🚀 Photobooth Backend Service running on port ${PORT}`);
});
