sudo cp ./scripts/ms-repo.pref /etc/apt/preferences.d/
sudo apt-get update
sudo apt install dotnet-sdk-6.0 -y
sudo apt install php-dev -y
dotnet tool install -g microsoft.sqlpackage
sudo apt-get update
sudo apt-get install sqlcmd
sudo ACCEPT_EULA=Y apt-get install -y --allow-downgrades msodbcsql18 odbcinst=2.3.7 odbcinst1debian2=2.3.7 unixodbc-dev=2.3.7 unixodbc=2.3.7
pecl install sqlsrv
pecl install pdo_sqlsrv
sudo apt-get install php-common
sudo phpenmod -v 8.2.0 sqlsrv pdo_sqlsrv
sudo echo extension=sqlsrv.so >> /usr/local/php/8.2.0/ini/php.ini
sudo echo extension=pdo_sqlsrv.so >> /usr/local/php/8.2.0/ini/php.ini