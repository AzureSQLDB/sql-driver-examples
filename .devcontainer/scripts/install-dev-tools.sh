sudo cp ./scripts/ms-repo.pref /etc/apt/preferences.d/
sudo apt-get update
sudo apt install dotnet-sdk-6.0 -y
sudo apt install php-dev -y
dotnet tool install -g microsoft.sqlpackage
sudo apt-get update
sudo apt-get install sqlcmd
sudo su
ACCEPT_EULA=Y apt-get install -y --allow-downgrades msodbcsql18 odbcinst=2.3.7 odbcinst1debian2=2.3.7 unixodbc-dev=2.3.7 unixodbc=2.3.7
pecl install sqlsrv
pecl install pdo_sqlsrv
apt-get install php-common
phpenmod sqlsrv pdo_sqlsrv
echo extension=sqlsrv.so >> /usr/local/php/8.2.0/ini/php.ini
echo extension=pdo_sqlsrv.so >> /usr/local/php/8.2.0/ini/php.ini
exit

