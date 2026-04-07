const express = require('express');
const router = express.Router();
const db = require('../db');

// GET - listar usuários
router.get('/', (req, res) => {
    db.query('SELECT * FROM usuarios', (err, results) => {
        if (err) {
            return res.status(500).json({ error: 'Erro ao buscar usuários' });
        }
        res.json(results);
    });
});

// GET - buscar usuário por ID
router.get('/:id', (req, res) => {
    const { id } = req.params;

    db.query('SELECT * FROM usuarios WHERE id = ?', [id], (err, results) => {
        if (err) {
            return res.status(500).json({ error: 'Erro ao buscar usuário' });
        }

        if (results.length === 0) {
            return res.status(404).json({ error: 'Usuário não encontrado' });
        }

        res.json(results[0]);
    });
});

// POST - criar usuário
router.post('/create', (req, res) => {
    const { nome, email, senha } = req.body;

    db.query(
        'INSERT INTO usuarios (nome, email, senha) VALUES (?, ?, ?)',
        [nome, email, senha],
        (err, results) => {
            if (err) {
                return res.status(500).json({ error: 'Erro ao criar usuário' });
            }

            res.status(201).json({
                id: results.insertId,
                nome,
                email
            });
        }
    );
});

// PUT - editar usuário
router.put('/edit/:id', (req, res) => {
    const { id } = req.params;
    const { nome, email, senha } = req.body;

    db.query(
        'UPDATE usuarios SET nome = ?, email = ?, senha = ? WHERE id = ?',
        [nome, email, senha, id],
        (err) => {
            if (err) {
                return res.status(500).json({ error: 'Erro ao atualizar usuário' });
            }

            res.json({ id, nome, email });
        }
    );
});

// DELETE - deletar usuário
router.delete('/delete/:id', (req, res) => {
    const { id } = req.params;

    db.query('DELETE FROM usuarios WHERE id = ?', [id], (err) => {
        if (err) {
            return res.status(500).json({ error: 'Erro ao deletar usuário' });
        }

        res.json({ message: 'Usuário deletado com sucesso' });
    });
});

module.exports = router;

// REGISTRAR VOLTA
router.post('/voltas', (req, res) => {
    const { corredor_id, tempo } = req.body;

    db.query(
        'INSERT INTO voltas (corredor_id, tempo) VALUES (?, ?)',
        [corredor_id, tempo],
        (err, results) => {
            if (err) return res.status(500).json({ error: 'Erro ao registrar volta' });

            res.status(201).json({ id: results.insertId });
        }
    );
});

// LISTAR VOLTAS
router.get('/voltas', (req, res) => {
    db.query('SELECT * FROM voltas', (err, results) => {
        if (err) return res.status(500).json({ error: 'Erro ao buscar voltas' });
        res.json(results);
    });
});

//MELHOR VOLTA
router.get('/dashboard/melhor-volta', (req, res) => {
    db.query(`
        SELECT corredor_id, MIN(tempo) AS melhor_volta
        FROM voltas
        GROUP BY corredor_id
    `, (err, results) => {
        if (err) return res.status(500).json({ error: 'Erro ao calcular melhor volta' });
        res.json(results);
    });
});

//TEMPOT TOTAL POR CORREDOR
router.get('/dashboard/tempo-total', (req, res) => {
    db.query(`
        SELECT corredor_id, SUM(tempo) AS tempo_total
        FROM voltas
        GROUP BY corredor_id
    `, (err, results) => {
        if (err) return res.status(500).json({ error: 'Erro ao calcular tempo total' });
        res.json(results);
    });
});

//QUANTIDADE POR VOLTA
router.get('/dashboard/quantidade-voltas', (req, res) => {
    db.query(`
        SELECT corredor_id, COUNT(*) AS voltas
        FROM voltas
        GROUP BY corredor_id
    `, (err, results) => {
        if (err) return res.status(500).json({ error: 'Erro ao contar voltas' });
        res.json(results);
    });
});