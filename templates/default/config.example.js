var path = require('path'),
    config;

config = {
    production: {
        url: '<%= @url %>',
        mail: {},
        database: {
            client: 'sqlite3',
            connection: {
                filename: path.join(__dirname, '/content/data/ghost.db')
            },
            debug: false
        },
        server: {
            socket: path.join(__dirname, '/sockets/ghost.sock')
        }
    },
};

// Export config
module.exports = config;
