const express = require('express');
const router = express.Router();
const db = require('../db');

// POST - registrar volta
router.post('/register', (req, res) => {
    const { corredor_id, tempo, corrida_id } = req.body;

    // Validar se o corredor existe
    db.query('SELECT id FROM corredores WHERE id = ?', [corredor_id], (err, results) => {
        if (err) {
            return res.status(500).json({ error: 'Erro ao verificar corredor' });
        }

        if (results.length === 0) {
            return res.status(404).json({ error: 'Corredor não encontrado' });
        }

        // Inserir volta
        db.query(
            'INSERT INTO voltas (corredor_id, tempo, corrida_id) VALUES (?, ?, ?)',
            [corredor_id, tempo, corrida_id || 1],
            (err, results) => {
                if (err) {
                    return res.status(500).json({ error: 'Erro ao registrar volta' });
                }

                res.status(201).json({ 
                    id: results.insertId,
                    message: 'Volta registrada com sucesso'
                });
            }
        );
    });
});

// GET - listar todas as voltas
router.get('/', (req, res) => {
    db.query(`
        SELECT v.*, c.nome as corredor_nome 
        FROM voltas v
        JOIN corredores c ON v.corredor_id = c.id
        ORDER BY v.data_registro DESC
    `, (err, results) => {
        if (err) {
            return res.status(500).json({ error: 'Erro ao buscar voltas' });
        }
        res.json(results);
    });
});

// GET - voltas por corredor
router.get('/corredor/:corredor_id', (req, res) => {
    const { corredor_id } = req.params;

    db.query(`
        SELECT * FROM voltas 
        WHERE corredor_id = ? 
        ORDER BY tempo ASC
    `, [corredor_id], (err, results) => {
        if (err) {
            return res.status(500).json({ error: 'Erro ao buscar voltas do corredor' });
        }
        res.json(results);
    });
});

// DELETE - deletar volta
router.delete('/delete/:id', (req, res) => {
    const { id } = req.params;

    db.query('DELETE FROM voltas WHERE id = ?', [id], (err) => {
        if (err) {
            return res.status(500).json({ error: 'Erro ao deletar volta' });
        }

        res.json({ message: 'Volta deletada com sucesso' });
    });
});

module.exports = router;