const express = require('express');
const router = express.Router();

const db = require('../database');

router.get('/',(req,res)=>{
    res.render('dashboard/welcome');
    
});

router.get('/buy',(req,res)=>{
    res.render('dashboard/register_buy');
});

router.get('/company',(req,res)=>{
    res.render('dashboard/company');
})

router.get('/add_buy',(req,res)=>{
    res.render('dashboard/add_buy');
});

router.get('/sell',(req,res)=>{
    res.render('dashboard/register_sell');
});


router.get('/add_sell',(req,res)=>{
    res.render('dashboard/add_sell');
});

module.exports = router;