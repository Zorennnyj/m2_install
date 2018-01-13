#!/bin/bash
MAGENTO_2_VERSIONS[0]='2.0.0';
MAGENTO_2_VERSIONS[1]='2.1.0';
MAGENTO_2_VERSIONS[2]='2.1.1';
MAGENTO_2_VERSIONS[3]='2.2.2';

echo "Select Magento 2 version:"

for i in ${!MAGENTO_2_VERSIONS[*]}; do
  echo "[$i] - ${MAGENTO_2_VERSIONS[$i]};"
done

read version_index;
version=${MAGENTO_2_VERSIONS[$version_index]};
version_stripped=`echo $version| sed 's/\.//g'`;

echo "Enter absolute path for installation directory:"
read directory;
# go to selected directory
cd $directory;

#set default variables
base_url="http://magento$version_stripped.loc/";

db_host='localhost';
db_name="magento_$version_stripped";

admin_firstname="admin";
admin_lastname="admin";
admin_email="admin@example.com";
admin_user="admin";
admin_password="admin123";
backend_frontname="admin";

#language="en_US";
#currency="USD";
#timezone="America/Chicago";
#use_rewrites="1"

echo "Enter Base Url. Press Enter to Skip and use default - '$base_url':";
read new_base_url;
if [ "$new_base_url" ]; then base_url=$new_base_url; fi

echo "Enter DataBase Host. Press Enter to Skip and use default - '$db_host':";
read new_db_host;
if [ "$new_db_host" ]; then db_host=$new_db_host; fi

echo "Enter DataBase Name. Press Enter to Skip and use default - '$db_name':";
read new_db_name;
if [ "$new_db_name" ]; then db_name=$new_db_name; fi

echo "Enter DataBase User:";
read db_user;

echo "Enter DataBase Password:";
read db_password;

echo "Enter Admin First Name. Press Enter to Skip and use default - '$admin_firstname':";
read new_admin_firstname;
if [ "$new_admin_firstname" ]; then admin_firstname=$new_admin_firstname; fi

echo "Enter Admin Last Name. Press Enter to Skip and use default - '$admin_lastname':";
read new_admin_lastname;
if [ "$new_admin_lastname" ]; then admin_lastname=$new_admin_lastname; fi

echo "Enter Admin Email. Press Enter to Skip and use default - '$admin_email':";
read new_admin_email;
if [ "$new_admin_email" ]; then admin_email=$new_admin_email; fi

echo "Enter Admin User Login. Press Enter to Skip and use default - '$admin_user':";
read new_admin_user;
if [ "$new_admin_user" ]; then admin_user=$new_admin_user; fi

echo "Enter Admin User Password. Press Enter to Skip and use default - '$admin_password':";
read new_admin_password;
if [ "$new_admin_password" ]; then admin_password=$new_admin_password; fi

echo "Enter Admin Area Alias. Press Enter to Skip and use default - '$backend_frontname':";
read new_backend_frontname;
if [ "$new_backend_frontname" ]; then backend_frontname=$new_backend_frontname; fi

#get package via composer
echo "Magento $version package - Start:"
composer create-project --repository-url=https://repo.magento.com/ magento/project-community-edition . $version;
# change permissions
find . -type d -exec chmod 766 {} \; && find . -type f -exec chmod 655 {} \;
echo "Magento $version package - End;"

#create DB
echo "Creating DataBase $db_name - Start:";
echo "CREATE DATABASE $db_name" | mysql -u $db_user -p$db_password
echo "Creating DataBase $db_name - End.";

#run installation
echo "Magento $version Installation - Start:";

php bin/magento setup:install --base-url="$base_url" --db-host="$db_host" --db-name="$db_name" --db-user="$db_user" --db-password="$db_password" --admin-firstname="$admin_firstname" --admin-lastname="$admin_lastname" --admin-email="$admin_email" --admin-user="$admin_user" --admin-password="$admin_password" --language="en_US" --currency="USD" --timezone="America/Chicago"  --use-rewrites="1"  --backend-frontname="$backend_frontname"
chmod 777 -R var

echo "Magento $version Installation - End.";
echo "Magento $version Installed:";
echo "UserEnd url - $base_url";
echo "AdminEnd url - $base_url$backend_frontname";
echo "Admin User Login - $admin_user";
echo "Admin User Password - $admin_password";
echo "Welcome to Magento 2 PAINFUL world! ^_^";
echo "Submit your ideas for improvements here --> https://github.com/Zorennnyj/m2_install";