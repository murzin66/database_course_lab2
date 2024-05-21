// католог с модулем для синхр. работы с MySQL, который должен быть усталовлен командой: sync-mysql
const dir_nms = 'C:\\Program Files\\nodejs\\node_modules\\sync-mysql';

// работа с базой данных.
const Mysql = require(dir_nms)
const connection = new Mysql({
    host:'localhost', 
    user:'root', 
    password:'', 
    database:'observatory'
})

// обработка параметров из формы.
var qs = require('querystring');
function reqPost (request, response) {
    if (request.method == 'POST') {
        var body = '';

        request.on('data', function (data) {
            body += data;
        });

        request.on('end', function () {
			var post = qs.parse(body);
			var sInsert = "INSERT INTO scientists (text, description, keywords) VALUES (\""+post['col1']+"\",\""+post['col2']+"\",\""+post['col3']+"\")";
			var results = connection.query(sInsert);
            console.log('Done. Hint: '+sInsert);
        });
    }
}

// выгрузка массива данных.
function ViewSelect(res) {
	var results = connection.query('SHOW COLUMNS FROM scientists');
	res.write('<tr>');
	for(let i=0; i < results.length; i++)
		res.write('<td>'+results[i].Field+'</td>');
	res.write('</tr>');
	//Creating trigger
	try {
		create_trigger=connection.query("CREATE TRIGGER sector_before_update BEFORE UPDATE ON sector FOR EACH ROW BEGIN SET NEW.date_update = NOW(); END");
	}
	catch (err){
		console.error('error in create trigger: ' + err.stack);
	}
	//creating procedure and call
	try{
	var createProcedure = connection.query("CREATE PROCEDURE Join_procedure(IN Table1 VARCHAR(40), IN Table2 VARCHAR(40))    BEGIN        SET @sql = CONCAT('SELECT * FROM ', Table1, ' AS t1 CROSS JOIN ', Table2, ' AS t2 ON t1.id = t2.id');PREPARE stmt FROM @sql;EXECUTE stmt;DEALLOCATE PREPARE stmt;END");
	}
	catch (err){
		console.error('error in create procedure: ' + err.stack);
	}
	
	var results = connection.query("CALL Join_procedure('scientists','sector')");
	if (results && results[0]) {
            let data = results[0];
            for (let i = 0; i < data.length; i++) {
                res.write('<tr><td>' + String(data[i].id) + '</td><td>' + data[i].text + '</td><td>' + data[i].description + '</td><td>' + data[i].keywords + '</td></tr>');
            }
        }
}
	
function ViewVer(res) {
	var results = connection.query('SELECT VERSION() AS ver');
	res.write(results[0].ver);
}

// создание ответа в браузер, на случай подключения.
const http = require('http');
const server = http.createServer((req, res) => {
	reqPost(req, res);
	console.log('Loading...');
	
	res.statusCode = 200;
//	res.setHeader('Content-Type', 'text/plain');

	// чтение шаблока в каталоге со скриптом.
	var fs = require('fs');
	var array = fs.readFileSync(__dirname+'\\select.html').toString().split("\n");
	console.log(__dirname+'\\select.html');
	for(i in array) {
		// подстановка.
		if ((array[i].trim() != '@tr') && (array[i].trim() != '@ver')) res.write(array[i]);
		if (array[i].trim() == '@tr') ViewSelect(res);
		if (array[i].trim() == '@ver') ViewVer(res);
	}
	res.end();
	console.log('1 User Done.');
});

// запуск сервера, ожидание подключений из браузера.
const hostname = '127.0.0.1';
const port = 3000;
server.listen(port, hostname, () => {
  console.log(`Server running at http://${hostname}:${port}/`);
});
