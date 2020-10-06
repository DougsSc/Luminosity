const express = require('express')
const bodyParser = require('body-parser')
const fs = require('fs')

const app = express()
const port = 9000

let dados = []

function writeJson() {
  fs.writeFileSync('data.json', JSON.stringify(dados))
}

function readJson() {
  dados = JSON.parse(fs.readFileSync('data.json'))
}

readJson()

app.use(bodyParser.json())

app.set('view engine', 'pug')

app.get('/', (req, res) => {
  res.render('index', { dados })
})

app.get('/dados', (req, res) => {
  res.json(dados);
})

app.post('/dados', (req, res) => {
  dados.push(req.body)
  writeJson()

  res.sendStatus(200)
})

app.listen(port, () => {
  console.log(`Server running on port ${port}`)
})
