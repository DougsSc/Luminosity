require('dotenv').config()
const express = require('express')
const json = require('body-parser').json
const fs = require('fs')

const app = express()
const port = process.env.PORT || 9000

const DATA_FILE = 'data.json'

let data = {
  position: 1,
  data: []
}
const actions = []

function saveData() {
  data.data = data.data.slice(Math.max(data.data.length - 20, 0))
  fs.writeFileSync(DATA_FILE, JSON.stringify(data))
}

function readData() {
  data = JSON.parse(fs.readFileSync(DATA_FILE))
}

if (!fs.existsSync(DATA_FILE)) {
  saveData()
}

app.use(json())

app.get('/currentPosition', (req, res) => {
  readData();
  res.json(data.position)
})

app.get('/data', (req, res) => {
  readData()
  res.json(data.data)
})

app.post('/data', (req, res) => {
  data.data.push(req.body)
  saveData()
  res.sendStatus(200)
})

app.post('/action', (req, res) => {
  const action = req.body

  if (action.value !== 0) {
    actions.unshift(action)
    return res.sendStatus(200)
  }

  res.sendStatus(400)
})

app.get('/action', (req, res) => {
  const action = actions.pop()
  if (action) {
    readData()
    const nextPosition = Math.max(Math.min(action.value, 1), 0)

    const next = {
      value: nextPosition - data.position
    }

    data.position = nextPosition
    saveData()

    return res.json(next)
  }

  res.json(null)
})

app.listen(port, () => {
  console.log(`Server running on port ${port}`)
})
