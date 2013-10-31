var querystring = require('querystring');
var restify = require('restify');
var sqlite3 = require('sqlite3').verbose();
var db = new sqlite3.Database('quotes.db');

db.run("CREATE TABLE quotes (person TEXT, quote TEXT)", function(err) {
	console.log(err);
});

function getQuotes(req, res, next) {
	var results = new Array();
	if (req.params.name !== undefined) {
		db.all("SELECT rowid AS id, person, quote FROM quotes WHERE person = ?", req.params.name, function(err, rows) {
			res.send(rows);
		});
	} else {
		db.all("SELECT rowid AS id, person, quote FROM quotes", function(err, rows) {
			res.send(rows);
		});
	}
}

function newQuote(req, res, next) {
	if (req.method == 'POST') {

		var body = '';

		req.on('data', function(chunk) {
			body += chunk.toString();
		});

		req.on('end', function() {

			console.dir(postData);

			db.run("INSERT INTO quotes (person, quote) VALUES(?, ?)", req.params.name, postData.quote, function(err, rowId) {
				if (err !== null) {
					res.json(500, {error: err});
				} else {
					res.json(200, {status: 'OK', rowId : rowId});
				}
			});		

		});
	}
}

function getRandom(req, res, next) {
	db.all("SELECT rowid AS id, person, quote FROM quotes", function(err, quotes) {
		var index = Math.floor((Math.random()*quotes.length));
		res.json(200, quotes[index]);
	});
}


var server = restify.createServer();
server.get('/quotes/:name', getQuotes);
server.get('/', getQuotes);
server.get('/random', getRandom);

server.post('/quotes/:name', newQuote);

server.listen(8080, function() {
	console.log('%s listening at %s', server.name, server.url);
})