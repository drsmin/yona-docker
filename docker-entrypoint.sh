#! /bin/sh
 
if [ -f "/inited" ] ; then
        echo "Already database was initialized."
else
        echo "Initializing database..."
	mysql_install_db --user=mysql --datadir=${DB_DATA_PATH}
fi

mysqld_safe --datadir=${DB_DATA_PATH} &

isMysql=1
until [ "${isMysql}" -eq 23 ] ; do
	curl -s --connect-timeout 3 localhost:3306
	isMysql=$?
        echo "Mysqld is initializing.."
        sleep 3
done

if [ -f "/inited" ] ; then
        echo "Mysql was opend"
else
        echo "Initializing user..."
        mysql -uroot < /data/init.sql
	mv /data/yona-dist/bin /data/yona
        mv /data/yona-dist/lib /data/yona
        mv /data/yona-dist/share /data/yona
        rm -rf /data/yona-dist
        touch /inited;
fi

# start yona
cd /data/yona
exec ./bin/yona
