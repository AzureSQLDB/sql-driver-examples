sudo cp ./scripts/ms-repo.pref /etc/apt/preferences.d/
sudo apt-get update
sudo apt-get install azure-functions-core-tools-4
sudo apt install dotnet-sdk-6.0 -y
npm install -g @azure/static-web-apps-cli
dotnet tool install -g microsoft.sqlpackage
dotnet new -i Microsoft.Build.Sql.Templates
dotnet tool install --global Microsoft.DataApiBuilder
sudo apt-get update
sudo apt-get install sqlcmd
echo 'PATH=$PATH:$HOME/.dotnet/tools' >> ~/.bashrc
echo "rm packages-microsoft-prod.deb"
rm packages-microsoft-prod.deb
echo "rm microsoft.gpg"
rm microsoft.gpg
ls
mkdir -p /home/vscode/.swa/dataApiBuilder/0.7.6/
cd /home/vscode/.swa/dataApiBuilder/0.7.6/
wget https://github.com/Azure/data-api-builder/releases/download/v0.7.6/dab_linux-x64-0.7.6.zip
unzip dab_linux-x64-0.7.6.zip
chmod 777 *