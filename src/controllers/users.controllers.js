import { db } from "../database/db.js";
import bcrypt from "bcrypt";

export async function createUser(req, res){
    const { name, email, password } = req.body;

    try{
        const existUser = await db.query(
            'SELECT * FROM users WHERE email = $1',
            [email]
        );
        console.log(existUser)
        if(existUser.rowCount > 0) return res.sendStatus(409);
        const passwordHash = bcrypt.hashSync(password,10);
        console.log(passwordHash)

        await db.query(
            'INSERT INTO users (name, email, password) VALUES($1, $2, $3)',
            [name, email, passwordHash]
        );
        return res.sendStatus(201);
    } catch (err) {
        console.log(err)
        return res.status(500).send(err.message);
    }
}

export async function getUserById(req, res){
    const { user } = res.locals;
    try {
        const visitResult = await db.query(
            'SELECT SUM(s.views) FROM shortens s WHERE s."userId" = $1',
            [user.id]
        );
        const [visitCount] = visitResult.rows;
        const urlsResult = await db.query(
            'SELECT * FROM shortens s WHERE s."userId" = $1',
            [user.id]
        );
        res.send({
            id: user.id,
            name: user.name,
            visitCount: visitCount.sum,
            shortenedUrls: urlsResult.rows,
        });
    } catch (err) {
        res.status(500).send(err.message);
    }
}


export async function ranking(req, res){
    try {
        const { rows } = await db.query(
            `
            SELECT 
                u.id, u.name,
                COUNT(s.id) AS "linkCount",
            FROM users u
            LEFT JOIN shortens s ON s."userId" = u.id
            GROUP BY u.id
            ORDER BY "visitCount" Desc
            LIMIT 10 
            `);
        res.send(rows);
    } catch (err) {
        res.status(500).send(err.message);
    }
}
