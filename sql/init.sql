create user 'yona'@'localhost' IDENTIFIED BY 'password';

set global innodb_file_format = BARRACUDA;
set global innodb_file_format_max = BARRACUDA;
set global innodb_large_prefix = ON;

create database yona
  DEFAULT CHARACTER SET utf8mb4
  DEFAULT COLLATE utf8mb4_bin
;

GRANT ALL ON yona.* to 'yona'@'localhost';
