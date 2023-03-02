import { Router } from "express";
import { shortenUrl } from "../controllers/urls.controllers.js";
import { authValidation } from "../middlewares/authorizathion.middlewares.js";

const router = Router();

router.post("/urls/shorten", authValidation, shortenUrl);
router.get("urls/:id", getUrlById);

export default router;
