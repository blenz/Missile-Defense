# Missile-Defense

	  The point of this game is to protect the city from the incoming missiles. To shoot missiles, 
	simply tap the missiles and the laser will dstroy them. As the the player destroys more missiles 
	the game gets harder by increasing the missiles speed and adding more missiles. The player loses 
	onces 4 missiles hit the city. The goal is to shoot as many rockets as possible until the city 
	gets destroyed. The player can then save their score so either the user or someone else can try 
	and beat it.

	  The app is fairly simple in how its used. In the actual game, the missiles are created above
	the screen using transition animation to hit the city. If the user's touch comes
	within a certain range of the missiles coordinates then the missile is destroyed and reset above 
	the screen. The laser animation gives the effect that the laser is shooting down the missiles.
	Each time the user destroys a missile the game keeps count and also keeps count of the city's 
	health. Each hit takes 25% of the city's health. The game checks to see how many missiles have
	been destroyed and increases missile speed and adds missiles accordingly. Once the player loses, they are 
	prompted to either "Play Again",  "Save Score", "Menu(go back to the menu)". If the player chooses
	to save their score, the player is then prompted to input their name. Once completed, 
	the game puts their score and name into appData so it can be saved or loaded each time 
	the game is started or terminated. The scores are then put into a tableview so the player can see
	their score as well as others.
