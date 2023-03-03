import { Router } from "express";
import { authValidation } from "../middlewares/authorizathion.middlewares.js";
import { getUserById, ranking } from "../controllers/users.controllers.js";

const router = Router();

router.get("/users/me", authValidation, getUserById);
router.get("/ranking", ranking)

export default router;
