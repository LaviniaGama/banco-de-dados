const mysql = require('mysql2')
const dotenv = require('dotenv')
require('dotenv').config();

dotenv.config();

const connection = mysql.createConnection({
    'user': 'root',
    'password': 'root',
    'database': 'corrida_db',
    'host': 'localhost',
    'port': 3307
});

//conectar ao banco de dados
connection.connect((err) => {
    if (err) {
        console.error('erro ao conectar ao banco de dados:', err);
        return;
    } else {
        console.log('Conexão bem-sucedida ao banco de dados');
    }
})

module.exports = connection;
