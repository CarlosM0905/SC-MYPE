const express = require('express');
const exphbs = require('express-handlebars');
const morgan = require('morgan');
const path = require('path');

// Inicializaciones
const app = express();

// Configuraciones
app.set('port',process.env.PORT || 4000);
app.set('views', path.join(__dirname,'views'));
app.engine('.hbs',exphbs({
    defaultLayout: 'main',
    layoutsDir: path.join(app.get('views'),'layouts'),
    partialsDir: path.join(app.get('views'),'partials'),
    extname: '.hbs',
    helpers: require('./lib/handlebars')
}));

app.set('view engine', '.hbs');

// Middlewares Funciones de envio/ respuesta al servidor
app.use(morgan('dev'));
// Permite recibir los datos de los formularios
app.use(express.urlencoded({
    extended:false
}));
app.use(express.json());

// Variables globales
app.use((req,res,next)=>{
    next();
});

// Rutas
app.use(require('./routes/index'));
app.use(require('./routes/authentication'));
app.use('/dashboard',require('./routes/dashboard'));

// Archivos publicos
app.use(express.static(path.join(__dirname,'public')));

// Iniciar el servidor

app.listen(app.get('port'), ()=>{
    console.log('Servidor en el puerto', app.get('port'));
});