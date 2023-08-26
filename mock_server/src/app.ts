import express, { Response } from 'express';

import bookings from './bookings';

const app = express();

const port = 8077;

const _setResHeaders = (res: Response) => {
    res.header("Access-Control-Allow-Origin", "*");
    res.header("Access-Control-Allow-Headers", "X-Requested-With");
    res.setHeader('Content-Type', 'application/json');
    res.setHeader('Cache-Control', 's-max-age=1, stale-while-revalidate');
}

app.get("/api/hotel-listeners", async (_req, res) => {
    _setResHeaders(res);
    res.status(200).send(JSON.stringify(bookings, null, 2));
});

app.listen(port, () => console.log(`Server initialized on port ${port}`));