import { Router } from "express";
import { shortenUrl, getUrlById, deleteUrl, openShortUrl } from "../controllers/urls.controllers.js";
import { authValidation } from "../middlewares/authorizathion.middlewares.js";
import { validateSchema } from "../middlewares/schemaValidation.middlewares.js";
import urlSchema from "../models/urlSchema.js";

const router = Router();

router.post("/urls/shorten", validateSchema(urlSchema), authValidation, shortenUrl);
router.get("urls/:id", getUrlById);
router.get("urls/open/:shortUrl", openShortUrl);
router.delete("/urls/:id", authValidation, deleteUrl);

export default router;
