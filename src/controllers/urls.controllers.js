import { nanoid } from "nanoid";
import { db } from "../database/db.js";

export async function shortenUrl(req, res){
    const { id } = res.locals.user;
    const { url } = req.body;
    const shortUrl = nanoid(8);

    try{
        const {rows} = await db.query(
            `
            INSERT INTO shortens(url, "shortUrl", "userId")
            VALUES ($1, $2, $3) RETURNING id
            `,
            [url, shortUrl, id]
        );

        res.status(201).send({id: rows[0].id, shortUrl})
    }   catch (err) {
        res.status(500).send(err.message)
    }
}

export async function getUrlById(req, res){
    const { id } = req.params;
    try{
        const { rows } = await db.query(
            'SELECT * FROM shortens WHERE id = $1',
            [id]
        );
        if(rows.length == 0) return res.sendStatus(404);
        const [url] = rows;
        const newUrl = {
            id: url.id,
            shortUrl: url.shortUrl,
            url: url.url,
        };
        res.send(newUrl);
    } catch (err) {
        res.status(500).send(err.message)
    }
}

export async function openShortUrl(req, res){
    const { shortUrl } = req.params;
    try{
        const { rows } = await db.query(
            `SELECT * FROM shortens WHERE "shortUrl" = $1`,
            [shortUrl]
        );
        if(rows.length === 0 ) return res.sendStatus(404);
        const [url] = rows;
        let views = rows.visitCount;
        views++;
        await db.query(
            `UPDATE shortens SET "visitCount" = "visitCount" +1 WHERE "shortUrl" = $1
            RETURNING url;`,
            [shortUrl]
        );
        res.redirect(url.url);
    } catch(err) {
        res.status(500).send(err.message)
    }
}

export async function deleteUrl(req, res){
    const { id } = req.params;
    const { user } = res.locals.user;
    try{
        const result = await db.query(
            `
            SELECT * FROM shortens WHERE id = $1
            `,
            [id]
        );
        if(result.rowCount == 0) return res.sendStatus(404);
        const [url] = result.rows;
        if(url.userId != user.id) return res.sendStatus(401);
        await db.query(
            `
            DELETE FROM shortens WHERE id=$1
            `, [id]
            );
        res.sendStatus(204);
    } catch (err) {
        return res.status(500).send(err.message)
    }
}