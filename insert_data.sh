#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
# Loop through each line in games.csv
tail -n +2 games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNERGOALS OPPONENTGOALS
do
  echo "$WINNER $OPPONENT"
  $PSQL "INSERT INTO teams (name) VALUES ('$WINNER'), ('$OPPONENT') ON CONFLICT (name) DO NOTHING"
done


# Loop through each line in games.csv
tail -n +2 games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNERGOALS OPPONENTGOALS
do
  # Get the IDs for the winner and opponent teams
  WINNER_ID=`$PSQL "SELECT team_id FROM teams WHERE name='$WINNER'"`
  OPPONENT_ID=`$PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'"`
  
  # Insert the row into the games table
  $PSQL "INSERT INTO games (year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES ('$YEAR', '$ROUND', '$WINNER_ID', '$OPPONENT_ID', '$WINNERGOALS', '$OPPONENTGOALS')"
done
echo "teams data inserted successfully"