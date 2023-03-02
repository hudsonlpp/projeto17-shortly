import { Router } from "express";
import { signin } from "../controllers/auth.controllers.js";
import { createUser} from "../controllers/users.controllers.js";

const router = Router();

router.post("/signup", createUser);
router.post("/signin", signin);

export default router;
