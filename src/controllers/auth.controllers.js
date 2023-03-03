import bcrypt from "bcrypt";
import { v4 as uuid } from "uuid";
import { db } from "../database/db.js";

export async function signin(req, res) {
    const { email, password } = req.body;

    try {
        const { rows } = await db.query(
            'SELECT * FROM users WHERE email=$1',
            [email]
        );
        const [user] = rows;
        res.send(token);
    } catch(err) {
        res.status(500).sen(err.message);
    }
}