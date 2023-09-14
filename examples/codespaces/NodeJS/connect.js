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
        database: 'master',
        port: <your_database_port>,
        trustServerCertificate: true,
        encrypt: true
    }
};

const connection = new Connection(config);

connection.connect((err) => {  
        if (err) 
        {
            console.log(err)
        }else{
            console.log("Connected");
            connection.close();
        }
});