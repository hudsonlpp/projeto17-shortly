import express from "express";
import dotenv from "dotenv";
import cors from "cors";
import joi from "joi";
import bcrypt from "bcrypt";
import { v4 as uuidV4 } from 'uuid';
import router from "./routes/index.routes.js";

dotenv.config();

const app = express();
app.use(express.json());
app.use(cors());
app.use(router);

// ROTAS:

const port = process.env.PORT;
app.listen(port, () => console.log(`Server running in port: ${port}`));