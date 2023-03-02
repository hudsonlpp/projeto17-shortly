import { Router } from "express";
import authRoutes from "";
import urlsRoutes from "";

const router = Router();

router.use(authRoutes);
router.use(urlsRoutes);

export default router;
