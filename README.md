# Onset Pickup Plugin

Simple package for the Onset openworld sandbox game.

## What does it do?
The package allows you to create player health and vehicle repair pickups wherever you like which automatically reload with the server. No database needed, the files are stored in the same folder as your server executable in a file called pickups.json

You can restrict access to create/delete commands by putting your admins steam IDs in the administrativeSteamIDs table at the top of pickups.server.lua (I plan to change this but this is my lazy solution for now). If you want anyone to be able to use these commands, add 999 to the table (default).

![Preview](https://cdn.discordapp.com/attachments/656550879176163329/664950092079562752/unknown.png)

## How to use
Put the files & package.json in to a folder in your packages folder as normal and start the package or add it to your server_config.json

To create a health pickup:
/createpickup health

To create a vehicle repair pickup:
/createpickup repair

To delete a pickup:
Walk in to a pickup created by the package and type /deletepickup

## Current known issues
When pickups.json file exists but is empty, there will be a (harmless) error in the console when attempting to load the pickups.

## Future scope
I intend to greatly add to this with a GUI, proper permissions and some other stuff. If you have any suggestions, feel free to let me know.

## Acknowledgements
"Borrowed" the file and json files from [Digital's sandbox editor](https://github.com/dig/onset-sandbox-editor) - thanks!.
