import { nanoid } from "nanoid";
import { db } from "../database/db.js";

export async function shortenUrl(req, res){
    const { id } = res.locals.user;
    const { url } = req.body;
    const shortUrl = nanoid(8);

    try{
        await db.query(
            `
            INSERT INTO shortens(url, "shortUrl", "userId")
            VALUES ($1, $2, $3)
            `,
            [URL, shortUrl, id]
        );

        res.status(201).send({shortUrl})
    }   catch (err) {
        res.status(500).send(err.mensage)
    }
}