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
        if (!user) return res.sendStatus(401);
        if(bcrypt.compareSync(password, user.password)){
            const token = uuid();
            await db.query(
                `
                INSERT INTO sessions (token, "userId")
                VALUES ($1, $2)
                `,
                [token, user.id]
            );
            return res.send(token)
        }
        return res.sendStatus(401)
    } catch(err) {
        res.status(500).send(err.message);
    }
}