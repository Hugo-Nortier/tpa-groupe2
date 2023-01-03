const express = require('express');
const app = express();
const port = process.env.PORT || 9001;
const server = require('http').Server(app);
const bodyParser = require('body-parser');
const PrestoClient = require('prestodb');


app.use(express.static(__dirname + '/public'));
app.use(bodyParser.urlencoded({ extended: false }));
app.use(bodyParser.json());

app.use((req, res, next) => {
	res.header("Access-Control-Allow-Origin", "*");
	res.header("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept");
	res.header("Access-Control-Allow-Methods", "POST, GET, OPTIONS, PUT, DELETE");

	next();
});

app.options('/*', (_, res) => {
    res.sendStatus(200);
});

let prestoClient = new PrestoClient({
	url: 'http://localhost:8080',
	user: 'presto',
	  nextUriTimeout: 200 // in miliseconds
  });
   
 

// Lance le serveur avec express
server.listen(port);
console.log("Serveur lancé sur le port : " + port);
app.get('/', (req, res) => {
	res.sendFile(__dirname + '/public/index.html');
});

app.get('/api/categories/count', (req, res) => {
	prestoClient.sendStatement('select categorie,count(*) from hive.default.immatriculations_predites group by categorie')
	.then((result) => {
		res.send(result);
	})
	.catch((error) => {
		  console.error({ error })
	  });
});

app.get('/api/marques/count', (req, res) => {
	prestoClient.sendStatement('select categorie,marque,count(*) from hive.default.immatriculations_predites group by categorie,marque')
	.then((result) => {
		res.send(result);
	})
	.catch((error) => {
		  console.error({ error })
	  });
});

app.get('/api/modeles/count', (req, res) => {
	prestoClient.sendStatement('select categorie,marque,nom,count(*) from hive.default.immatriculations_predites group by categorie,marque,nom')
	.then((result) => {
		res.send(result);
	})
	.catch((error) => {
		  console.error({ error })
	  });
});

app.get('/api/marketing', (req, res) => {
	prestoClient.sendStatement('SELECT situationfamiliale,categorie,count(categorie) FROM  hive.default.immatriculations_predites i INNER JOIN hive.default.clients c ON i.immatriculation = c.immatriculation group by situationfamiliale,categorie')
	.then((result) => {
		res.send(result);
	})
	.catch((error) => {
		  console.error({ error })
	  });
});


app.get('/api/energie', (req, res) => {
	prestoClient.sendStatement('(SELECT count(*) FROM hive.default.catalogue WHERE moyenneenergie<100) '+
	'UNION (SELECT count(*) FROM hive.default.catalogue WHERE moyenneenergie>101 AND moyenneenergie<120) '+
	'UNION (SELECT count(*) FROM hive.default.catalogue WHERE moyenneenergie>121 AND moyenneenergie<140) '+
	'UNION (SELECT count(*) FROM hive.default.catalogue WHERE moyenneenergie>141 AND moyenneenergie<160) '+
	'UNION (SELECT count(*) FROM hive.default.catalogue WHERE moyenneenergie>161 AND moyenneenergie<200) '+
	'UNION (SELECT count(*) FROM hive.default.catalogue WHERE moyenneenergie>201 AND moyenneenergie<250) '+
	'UNION (SELECT count(*) FROM hive.default.catalogue WHERE moyenneenergie>251)'
	)
	.then((result) => {
		res.send(result);
	})
	.catch((error) => {
		  console.error({ error })
	  });
});
