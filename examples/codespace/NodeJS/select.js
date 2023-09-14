var Connection = require('tedious').Connection;

var config = {
    server: '<your_server.database.windows.net>',
    authentication: {
        type: 'default',
        options: {
        userName: '<your_username>',
        password: '<your_password>' 
        }
    },
    options: {
        database: 'SampleDB',
        port: <your_database_port>,
        trustServerCertificate: true,
        encrypt: true
    }
};

const connection = new Connection(config);

connection.connect((err) => {  
    // If no error, then good to proceed.  
    console.log("Connected");  
    executeStatement();  
});  

var Request = require('tedious').Request;  
var TYPES = require('tedious').TYPES;  

function executeStatement() {  
    var request = new Request("SELECT * from [TestSchema].[Employees];", function(err) {  
    if (err) {  
        console.log(err);}  
    });  
    var result = "";  
    request.on('row', function(columns) {  
        columns.forEach(function(column) {  
          if (column.value === null) {  
            console.log('NULL');  
          } else {  
            result+= column.value + " ";  
          }  
        });  
        console.log(result);  
        result ="";  
    });  

    request.on('done', function(rowCount, more) {  
    console.log(rowCount + ' rows returned');  
    });  
    
    // Close the connection after the final event emitted by the request, after the callback passes
    request.on("requestCompleted", function (rowCount, more) {
        connection.close();
    });
    connection.execSql(request);  
}