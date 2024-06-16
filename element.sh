#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

ARG1=$1

GET_ELEMENT_INFO() {
  # No arguments provided
  if [[ -z $ARG1 ]]
  then
    echo Please provide an element as an argument.
  else
    if [[ $ARG1 =~ ^[0-9]+$ ]]
    then
      # check number
      ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number = $ARG1;")
      if [[ -z $ATOMIC_NUMBER ]]
      then
        echo I could not find that element in the database.
      else
        # get element info
        GET_INFO=$($PSQL "SELECT atomic_number, symbol, name, types.type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements FULL JOIN properties USING (atomic_number) FULL JOIN types USING (type_id) WHERE atomic_number = $ARG1;")
        echo $GET_INFO | while IFS='|' read ATOMIC_NUMBER SYMBOL NAME TYPE ATOMIC_MASS MELTING_POINT BOILING_POINT
        do
          echo "The element with atomic number $ATOMIC_NUMBER is $NAME ("$SYMBOL"). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
        done
      fi
    elif [[ $ARG1 =~ ^[A-Za-z]{1,2}$ ]]
    then
      # check symbol
      SYMBOL_CHECK=$($PSQL "SELECT symbol FROM elements WHERE symbol ILIKE '$ARG1';")
      if [[ -z $SYMBOL_CHECK ]]
      then
        echo I could not find that element in the database.
      else
        # get element info
        GET_INFO=$($PSQL "SELECT atomic_number, symbol, name, types.type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements FULL JOIN properties USING (atomic_number) FULL JOIN types USING (type_id) WHERE LOWER(symbol) = LOWER('$ARG1');")
        echo $GET_INFO | while IFS='|' read ATOMIC_NUMBER SYMBOL NAME TYPE ATOMIC_MASS MELTING_POINT BOILING_POINT
        do
          echo "The element with atomic number $ATOMIC_NUMBER is $NAME ("$SYMBOL"). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
        done
      fi
    elif [[ $ARG1 =~ ^[A-Za-z]{3,}$ ]]
    then
      # check name
      NAME_CHECK=$($PSQL "SELECT name FROM elements WHERE name ILIKE '$ARG1';")
      if [[ -z $NAME_CHECK ]]
      then
        echo I could not find that element in the database.
      else
        # get element info
        GET_INFO=$($PSQL "SELECT atomic_number, symbol, name, types.type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements FULL JOIN properties USING (atomic_number) FULL JOIN types USING (type_id) WHERE LOWER(name) = LOWER('$ARG1');")
        echo $GET_INFO | while IFS='|' read ATOMIC_NUMBER SYMBOL NAME TYPE ATOMIC_MASS MELTING_POINT BOILING_POINT
        do
          echo "The element with atomic number $ATOMIC_NUMBER is $NAME ("$SYMBOL"). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
        done
      fi
    else
      echo I could not find that element in the database.
    fi
  fi
}
GET_ELEMENT_INFO
