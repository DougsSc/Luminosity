require('dotenv').config()

import express from 'express'
import { json } from 'body-parser'

const app = express()
const port = process.env.PORT || 9000

const PADDLE_TIME = 5000;

const data = []
const actions = []

app.use(json())

app.get('/data', (req, res) => {
  res.json(data);
})

app.post('/data', (req, res) => {
  data.push(req.body)
  res.sendStatus(200)
})

app.post('/action', (req, res) => {
  const action = req.body;

  switch (action.type) {
    case 'turnPaddles':
      actions.unshift({
        motor: 'paddles',
        direction: action.value < 0 ? 'right' : 'left',
        time: action.value * PADDLE_TIME
      })
      break
  }
})

app.get('/action', (req, res) => {
  res.json(actions.pop() ?? null);
})

app.listen(port, () => {
  console.log(`Server running on port ${port}`)
})
