#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=salon --tuples-only -c"

MAIN_MENU() {
  echo -e "1) Cut\n2) Color\n3) Style"
  read SERVICE_ID_SELECTED

  case $SERVICE_ID_SELECTED in
    1) DO_STUFF 1;;
    2) DO_STUFF 2;;
    3) DO_STUFF 3;;
    *) MAIN_MENU "Please enter a valid option";;
  esac
}

DO_STUFF() {
  echo -e "\nEnter your phone number:"
  read CUSTOMER_PHONE
  
  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
  
  if [[ -z $CUSTOMER_ID ]]
  then
    echo -e "\nEnter your name:"
    read CUSTOMER_NAME
    INSERT_RESULT=$($PSQL "INSERT INTO customers(name, phone) VALUES('$CUSTOMER_NAME', '$CUSTOMER_PHONE')")
  fi

  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")

  echo -e "\nEnter service time:"
  read SERVICE_TIME

  INSERT_RESULT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $1, '$SERVICE_TIME')")
  
  SERVICE=$($PSQL "SELECT name FROM services WHERE service_id=$1")
  CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'")
  echo "I have put you down for a $(echo $SERVICE | sed -E 's/^ +| +$//') at $SERVICE_TIME, $(echo $CUSTOMER_NAME | sed -E 's/^ +| +$//')."
}

MAIN_MENU
