#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WGOALS OPGOALS
do
#if [[ $YEAR != "year" ]]
#then

#get team_id (winner)
if [[ $WINNER != "winner" ]]
then
GET_TEAM_WID=$($PSQL "SELECT team_id FROM teams WHERE name = '$WINNER'")

#if not found
if [[ -z $GET_TEAM_WID ]]
then
INSERT_INTO_T=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
fi
fi


#get new team_id (looser - opponent)
if [[ $OPPONENT != "opponent" ]]
then
GET_TEAM_LID=$($PSQL "SELECT team_id FROM teams WHERE name = '$OPPONENT'")
echo Este es el oponente $OPPONENT $GET_TEAM_LID

#if opponent is not already teams insert it.
if [[ -z $GET_TEAM_LID ]]
then 
INSERT_INTO_T=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
fi
fi

if [[ $YEAR != 'year' ]]
then
#get game_id
GET_GAME_ID=$($PSQL "SELECT game_id FROM games WHERE year = $YEAR AND (round = '$ROUND' AND winner_id = (SELECT team_id FROM teams WHERE name = '$WINNER') AND  opponent_id = (SELECT team_id FROM teams WHERE name = '$OPPONENT') AND  winner_goals = $WGOALS AND opponent_goals = $OPGOALS)")
if [[ -z $GET_GAME_ID ]]
then
echo game_id empty
INSERT_INTO_GAMES=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES ($YEAR, '$ROUND', (SELECT team_id FROM teams WHERE name = '$WINNER'), (SELECT team_id FROM teams WHERE name = '$OPPONENT'), $WGOALS, $OPGOALS)")
fi
fi
#if [[ $ROUND != "round" ]]
#then
#echo $ROUND
#fi
######
#get team_id
#if [[ $WINNER != "winner" ]]
#then
#GET_TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$WINNER'")

#if not found
#if [[ -z $GET_TEAM_ID ]]
#then
#INSERT_INTO_T=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
#fi
#fi

#get new team_id
#if [[ $OPPONENT != "opponent" ]]
#then
#GET_TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$OPPONENT'")
#echo Este es el oponente $OPPONENT $GET_TEAM_ID

#if opponent is not already teams insert it.
#if [[ -z $GET_TEAM_ID ]]
#then 
#INSERT_INTO_T=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
#fi
#fi
done

