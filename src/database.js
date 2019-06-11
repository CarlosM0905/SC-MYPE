const mysql = require('mysql');
const {promisify} =  require('util');
const { database } = require('./keys')

const conexion = mysql.createPool(database);

conexion.getConnection((err,connection)=>{
    if(err){
        if(err.code === 'PROTOCOL_CONNECTION_LOST'){
            console.error('DATABASE CONNECTION WAS CLOSED');
        }
        else if(err.code === 'ER_CON_COUNT_ERROR'){
            console.error('DATABASE HAS TO MANY CONNECTIONS');
        }
        else if(err.code === 'ECONNREFUSED'){
            console.error('DATABASE CONNECTION WAS REFUSED');
        }
        else{
            console.error('SOMETHING IS WRONG');
        }
        
    }

    if(connection){
        connection.release();
    }
    console.log('La base de datos esta conectada');

    return;

});
// Convirtiendo a promesas las queries de la conexion

conexion.query =  promisify(conexion.query);

module.exports = conexion;