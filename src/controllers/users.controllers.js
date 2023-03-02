import { db } from "../database/db.js";
import bcrypt from "bcrypt";

export async function createUser(req, res){
    const { name, email, password } = re.body;

    try{
        const existUser = await db.query(
            'SELECT * FROM users WHERE email = $1',
            [email]
        );
        if(existUser.rowCount > 0) return res.sendStatus(409);
        const passwordHash = bcrypt.hashSync(password,10);

        await db.query(
            'INSERT INTO users (name, email, password) VALUES($1, $2, $3)',
            [name, email, passwordHash]
        );
        res.sendStatus(201);
    } catch (err) {
        res.status(500).send(err.message);
    }
}