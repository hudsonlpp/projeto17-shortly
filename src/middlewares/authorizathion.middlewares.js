import { db } from "../database/db.js";

export async function authValidation(req, res, next) {
    const { authorization } = req.headers;
    const token = authorization?.replace("Bearer ", "");

    if(!token) return res.sendStatus(401);

    try{
        const { rows } = await db.query(
            'SELECT * FROM sessions WHERE token = $1',
            [token]
        );
    
        const [session] = rows;
        if (!session) return res.sendStatus(401);

        const {rows: users } = await db.query(
            'SELECT * FROM users WHERE id = $1',
            [session.userId]
        );
    } catch (err) {
        res.status(500).send(err.message);
    }
}