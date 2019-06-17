const express = require('express');
const router = express.Router();



const db = require('../database');

router.get('/', (req, res) => {
    res.render('dashboard/welcome');

});

router.post('/', async (req, res) => {
    let usr_nombre = req.body.user;
    let usr_contrasena = req.body.password;
    let params = { usr_nombre, usr_contrasena };

    let access = await db.query('SELECT * FROM usuario WHERE usr_nombre = ? AND usr_contrasena = ?', [usr_nombre, usr_contrasena]);

    let tam = Object.keys(access).length;
    console.log(params);
    if (tam > 0) {
        res.cookie('user', usr_nombre, { httpOnly: false });
        res.cookie('password', usr_contrasena, { httpOnly: false });
        res.redirect('/dashboard/company');
    } else {
        res.render('dashboard/welcome')
    }


});

router.get('/buy', (req, res) => {
    res.render('dashboard/register_buy');
});

router.get('/company', async (req, res) => {

    // Se recogen los datos del usuario de las cookies del navegador
    let user = req.cookies['user'];
    let password = req.cookies['password'];
    let params = { user, password };

    //Se buscar el id del usuario
    let usr_id = (await db.query('SELECT usr_id FROM usuario WHERE usr_nombre = ? AND usr_contrasena = ?', [user, password]))[0].usr_id;

    //Se seleccionan todas las empresas de la BD
    let empresas = await db.query('SELECT * FROM empresa WHERE emp_usuario = ?',[usr_id]);
    console.log(empresas);
    res.render('dashboard/company', { params, empresas });
});

router.post('/company',async (req, res) => {
    let user = req.cookies['user'];
    let password = req.cookies['password'];
    let params = { user, password };
    //Se buscar el id del usuario
    let emp_usuario = (await db.query('SELECT usr_id FROM usuario WHERE usr_nombre = ? AND usr_contrasena = ?', [user, password]))[0].usr_id;
    console.log(emp_usuario);
    let emp_razon_social = req.body.razon_social;
    let emp_ruc = req.body.ruc;

    
    let empresa = { emp_razon_social , emp_ruc , emp_usuario };

    await db.query('INSERT INTO empresa SET ?',[empresa]);

    res.redirect('/dashboard/company');

});

router.get('/add_buy', (req, res) => {
    res.render('dashboard/add_buy');
});

router.get('/sell', (req, res) => {
    res.render('dashboard/register_sell');
});


router.get('/add_sell', (req, res) => {
    res.render('dashboard/add_sell');
});

module.exports = router;