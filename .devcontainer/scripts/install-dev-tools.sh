sudo cp ./scripts/ms-repo.pref /etc/apt/preferences.d/
sudo apt-get update
sudo apt install dotnet-sdk-6.0 -y
sudo apt install php-dev -y
dotnet tool install -g microsoft.sqlpackage
sudo apt-get update
sudo apt-get install sqlcmd
sudo apt-get 
pecl install sqlsrv-5.11.1
pecl install pdo_sqlsrv-5.11.1
