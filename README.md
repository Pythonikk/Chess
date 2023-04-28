# Chess

A command line Chess game for two human players to play against each other. It implements the official rules of chess and two common special moves: *pawn en passant* and *castling*. Matches can be saved and loaded if ran locally.

This was my final project for [The Odin Project's](https://www.theodinproject.com) Ruby section.



#### Accessing the Project

This project can be accessed here: [chess replit](https://replit.com/@technikka/Chess). Click 'Run' or the play button to begin.

Please **note** this is not a production build-- printing is slow and colorize  doesnt display well on Replit's console. Saving/loading functions are disabled in this version. Run this project locally for a smooth experience.

## Technologies Used

* Ruby 3.1.0
* YAML
* [colorize gem](https://github.com/fazibear/colorize)


## Description

This is a pretty typical implmentation of the basic game. Some features include:

* Does not allow a player to make illegal moves, such as one that would put their king in check, or neglect to guard a king who is in check.

* Helpful individualized errors explaining why a move cannot be made, such as "Illegal castling: you cannot jump over a square under attack."

* Special moves *pawn en passant* and *castling*

* Uses the [colorize](https://github.com/fazibear/colorize) gem to output color in the console. 
Please **note** the colors I have chosen may not show up properly depending on your terminal color configurations. I preferred a dark sandy background which allowed the colors to show well (see screenshot below).

A couple features not implemented in this version:

* It does not pre-determine a *mate*. When a player is in check and cannot make a move to remove the check, the turn goes to their opponent who must take their king for the game to end.

* It does not announce a *stalemate*. If a stalemate is reached, the players must recognize it and quit the game.



#### Screenshots
<img src="screenshot.png" title="screenshot of game" alt="screenshot of a game in play showing white attempting an illegal move with an error alerting that the move puts their king in check" width="450px">



## Setup/Installation

To run this project locally:

1. Clone this repository
2. Run `bundle install`
3. Run `bundle exec ruby lib/main.rb`

Please note the colors I have chosen may not show up properly depending on your terminal color configurations. You can also change the colors being printed by chanding the code in the Display class. `String.colors` returns all colors available through the colorize gem.



### Reflections as a student:

Though I still have design improvements and additional features in mind, there comes a time to 'take the roast out of the oven', that is to say: calling the current version 'done'. With much more to learn on the Odin journey, further work on this project will have to wait for version 2, as time permits.  

With that said, I do think this version is a pretty fair representation of my Ruby skills at this point. My object-oriented design has improved immensely since previous projects, with less unnecessary dependencies and more adaptability. I successfully implemented an abstract class and extended classes with modules to keep this relatively larger library well-organized and DRY. It's by no means perfect in any of these regards, but an indication of my growth and closer to where i'd like to be.


### What's Next

Ideas for continuous work on this project:

* Play against the computer

* Improved scoresheet and point system. The game would keep score based on piece point values.

* Mate and Stalemate implementation. The game will declare a win/loss/draw.

* Turn this into a web app!
