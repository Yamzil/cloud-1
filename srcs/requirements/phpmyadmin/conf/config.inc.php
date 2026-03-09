<?php

$cfg['blowfish_secret'] = '\Kr1l9hY0ehi]~RAzZ2+lpbbRPt^*@xO';

$i = 0; 
$i++; // First Server

$cfg['Servers'][$i]['auth_type'] = 'cookie';
$cfg['Servers'][$i]['host'] = 'mariadb';
$cfg['Servers'][$i]['port'] = '3306';

$cfg['Servers'][$i]['AllowNoPassword'] = false;

$cfg['TempDir'] = '/tmp/phpmyadmin_tmp';