import express, { Request, Response } from 'express';
import Person from './Person';

const app = express();
const port = 3000;

const person1 = new Person('John Doe', 30);
person1.greet();

app.get('/', (req: Request, res: Response) => {
  res.send('Hello World!');
});

app.listen(port, () => {
  console.log(`Example app listening at http://localhost:${port}`);
});
