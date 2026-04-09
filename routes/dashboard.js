const express = require('express');
const router = express.Router();
const db = require('../db');

// Dashboard completo
router.get('/', (req, res) => {
    const { corrida_id } = req.query;
    
    let whereClause = '';
    let params = [];
    
    if (corrida_id) {
        whereClause = 'WHERE v.corrida_id = ?';
        params.push(corrida_id);
    }

    const queries = {
        melhorVolta: `
            SELECT 
                c.id,
                c.nome,
                c.equipe,
                MIN(v.tempo) as melhor_volta
            FROM voltas v
            JOIN corredores c ON v.corredor_id = c.id
            ${whereClause}
            GROUP BY c.id, c.nome, c.equipe
            ORDER BY melhor_volta ASC
        `,
        tempoTotal: `
            SELECT 
                c.id,
                c.nome,
                c.equipe,
                SUM(v.tempo) as tempo_total,
                COUNT(v.id) as total_voltas
            FROM voltas v
            JOIN corredores c ON v.corredor_id = c.id
            ${whereClause}
            GROUP BY c.id, c.nome, c.equipe
            ORDER BY tempo_total ASC
        `,
        ultimasVoltas: `
            SELECT 
                v.*,
                c.nome as corredor_nome,
                c.equipe
            FROM voltas v
            JOIN corredores c ON v.corredor_id = c.id
            ${whereClause}
            ORDER BY v.data_registro DESC
            LIMIT 10
        `,
        estatisticasGerais: `
            SELECT 
                COUNT(DISTINCT c.id) as total_corredores,
                COUNT(v.id) as total_voltas,
                MIN(v.tempo) as recorde_geral,
                AVG(v.tempo) as media_tempo
            FROM voltas v
            JOIN corredores c ON v.corredor_id = c.id
            ${whereClause}
        `
    };

    Promise.all([
        new Promise((resolve, reject) => {
            db.query(queries.melhorVolta, params, (err, results) => {
                if (err) reject(err);
                else resolve(results);
            });
        }),
        new Promise((resolve, reject) => {
            db.query(queries.tempoTotal, params, (err, results) => {
                if (err) reject(err);
                else resolve(results);
            });
        }),
        new Promise((resolve, reject) => {
            db.query(queries.ultimasVoltas, params, (err, results) => {
                if (err) reject(err);
                else resolve(results);
            });
        }),
        new Promise((resolve, reject) => {
            db.query(queries.estatisticasGerais, params, (err, results) => {
                if (err) reject(err);
                else resolve(results[0]);
            });
        })
    ])
    .then(([melhorVolta, tempoTotal, ultimasVoltas, estatisticas]) => {
        res.json({
            melhor_volta: melhorVolta,
            tempo_total: tempoTotal,
            ultimas_voltas: ultimasVoltas,
            estatisticas: estatisticas
        });
    })
    .catch(err => {
        res.status(500).json({ error: 'Erro ao gerar dashboard', details: err });
    });
});

// Ranking geral
router.get('/ranking', (req, res) => {
    const { corrida_id } = req.query;
    
    let whereClause = '';
    let params = [];
    
    if (corrida_id) {
        whereClause = 'WHERE v.corrida_id = ?';
        params.push(corrida_id);
    }

    db.query(`
        SELECT 
            c.id,
            c.nome,
            c.equipe,
            c.numero,
            COUNT(v.id) as total_voltas,
            MIN(v.tempo) as melhor_volta,
            SUM(v.tempo) as tempo_total,
            ROUND(AVG(v.tempo), 2) as media_volta
        FROM voltas v
        JOIN corredores c ON v.corredor_id = c.id
        ${whereClause}
        GROUP BY c.id, c.nome, c.equipe, c.numero
        ORDER BY melhor_volta ASC, tempo_total ASC
    `, params, (err, results) => {
        if (err) {
            return res.status(500).json({ error: 'Erro ao gerar ranking' });
        }
        
        // Adicionar posição no ranking
        const ranking = results.map((corredor, index) => ({
            posicao: index + 1,
            ...corredor
        }));
        
        res.json(ranking);
    });
});

// Melhor volta geral
router.get('/melhor-volta-geral', (req, res) => {
    const { corrida_id } = req.query;
    
    let whereClause = '';
    let params = [];
    
    if (corrida_id) {
        whereClause = 'AND v.corrida_id = ?';
        params.push(corrida_id);
    }

    db.query(`
        SELECT 
            v.*,
            c.nome as corredor_nome,
            c.equipe
        FROM voltas v
        JOIN corredores c ON v.corredor_id = c.id
        WHERE v.tempo = (
            SELECT MIN(tempo) 
            FROM voltas 
            WHERE 1=1 ${whereClause.replace('AND', '')}
        )
        ${whereClause}
        LIMIT 1
    `, params, (err, results) => {
        if (err) {
            return res.status(500).json({ error: 'Erro ao buscar melhor volta geral' });
        }
        res.json(results[0] || null);
    });
});

// Estatísticas por corredor
router.get('/corredor/:id', (req, res) => {
    const { id } = req.params;

    db.query(`
        SELECT 
            c.*,
            COUNT(v.id) as total_voltas,
            MIN(v.tempo) as melhor_volta,
            MAX(v.tempo) as pior_volta,
            SUM(v.tempo) as tempo_total,
            ROUND(AVG(v.tempo), 2) as media_volta
        FROM corredores c
        LEFT JOIN voltas v ON c.id = v.corredor_id
        WHERE c.id = ?
        GROUP BY c.id
    `, [id], (err, results) => {
        if (err) {
            return res.status(500).json({ error: 'Erro ao buscar estatísticas do corredor' });
        }

        if (results.length === 0) {
            return res.status(404).json({ error: 'Corredor não encontrado' });
        }

        res.json(results[0]);
    });
});

module.exports = router;