#! /bin/bash

if [[ $1 == "test" ]]
then
  # ./insert_data test
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  # ./insert_data
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

#Vaciar las tablas si es que tienen filas ya insertadas
#Si solo quiero hacer la acción, se escribe ' $($PSQL "truncate teams, games") '
#Acordarse que para solamente imprimir algo, es ' echo "hola" '
#No hace falta que sea case sensitive. Pero se escribe "TRUNCATE tabla1, tabla2, ... ;"
echo $($PSQL "truncate teams, games")

# insert into teams and games
#' cat ' es para leer contenido de archivos
#
#' IFS ' = "Internal Field Separator": carácter utilizado para separar los campos en una línea
# de texto cuando se realiza la lectura o el procesamiento de datos.
#
#' | ' Supongamos que tenemos: "comando1 | comando2"
#Lo que sucede aquí es que la salida del comando1 se transfiere directamente al comando2.
#Esto significa que el resultado producido por comando1 se utiliza como entrada para comando2.
#En otras palabras: " cat games.csv " abre el archivo y ' | ' lo "conecta" o hace de "puente" o "conexión" hacia el while.
#
#' read dato1, dato2 ' Están en el encabezado del archivo games.csv
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS

#Inicia el ' while '
do 

  #Por que hay años diferentes, uno de 2018 y otro 2014 (son los ejemplos).
  #Si estamos trabajando con 2018, entonces hay que encontrar todos los que son
  #con ese año en particular.
  if [[ $YEAR != "year" ]] 
  then

    #Agarra un nombre,
    #si lo encuentra en la base de datos, entonces devuelve el team_id, 
    #si no lo encuentra, entonces lo agrega

    # Obtener team_id (ganador) a partir del dato leido con ' read ' (leemos "WINNER").
    TEAM_ID_WINNER=$($PSQL "select team_id from teams where name='$WINNER'")
    
    #' -z ': Verifica si TEAM_ID_WINNER es una cadena "vacía".
    #Explicación:
    #[[ -z $TEAM_ID_OPPONENT ]] se evalúa como verdadera si la cadena $TEAM_ID_OPPONENT está vacía, 
    #lo que significa que no se encontró ningún equipo oponente con el nombre $OPPONENT en la tabla teams.
    #Si esta condición es verdadera, significa que el equipo oponente no está presente en la tabla teams,
    #por lo tanto, necesitamos insertarlo.
    if [[ -z $TEAM_ID_WINNER ]]
    then
      # inserta nombre team ganador.
      INSERT_WINNER_RESULT=$($PSQL "insert into teams(name) values('$WINNER')")

      #' 0 1 ':Inserción exitosa generada.
      if [[ $INSERT_WINNER_RESULT == "INSERT 0 1" ]]
      then
        echo Insertado ganador en la tabla teams, $WINNER
      fi
    fi

    # get team_id (opponent)
    # Obtener team_id (oponente) a partir del dato leido con ' read ' (leemos "OPPONENT").
    TEAM_ID_OPPONENT=$($PSQL "select team_id from teams where name='$OPPONENT'")
    
    #' -z ': Verifica si TEAM_ID_WINNER es una cadena "vacía".
    #[[ -z $TEAM_ID_OPPONENT ]] se evalúa como verdadera si la cadena $TEAM_ID_OPPONENT está vacía, 
    #lo que significa que no se encontró ningún equipo oponente con el nombre $OPPONENT en la tabla teams.
    #Si esta condición es verdadera, significa que el equipo oponente no está presente en la tabla teams,
    #por lo tanto, necesitamos insertarlo.
    if [[ -z $TEAM_ID_OPPONENT ]]
    then

    # inserta nombre team oponente.
    INSERT_OPPONENT_RESULT=$($PSQL "insert into teams(name) values('$OPPONENT')")

      #' 0 1 ':Inserción exitosa generada.
      if [[ $INSERT_OPPONENT_RESULT == "INSERT 0 1" ]]
      then
        echo Insertado oponente en la tabla teams, $OPPONENT
      fi
    fi
    
    #Obtener el id del equipo ganador o oponente.
    TEAM_ID=$($PSQL "select team_id from teams where name='$WINNER' or name='$OPPONENT'")

    #Definir el equipo ganador a partir de su team_id
    TEAM_ID_WINNER=$($PSQL "select team_id from teams where name='$WINNER'")
    #Definir el equipo oponente a partir de su team_id
    TEAM_ID_OPPONENT=$($PSQL "select team_id from teams where name='$OPPONENT'")

    #Insertar dentro de la tabla "games" los valores leídos de games.csv
    INSERT_GAME_RESULT=$($PSQL "insert into games(year,round,winner_id,opponent_id,winner_goals,opponent_goals) values($YEAR,'$ROUND',$TEAM_ID_WINNER,$TEAM_ID_OPPONENT,$WINNER_GOALS,$OPPONENT_GOALS)")
    
    #' 0 1 ':Inserción exitosa generada.
    if [[ $INSERT_GAME_RESULT == "INSERT 0 1" ]]
    then
      echo Insertado dentro de tabla games, $YEAR $ROUND
    fi
  fi
done
