![](screenshot.jpg)

# POSH Profile
Prompt built using several tools found on github:
* [Oh-My-Posh](https://github.com/JanJoris/oh-my-posh)
* [Powerline Fonts](https://github.com/powerline/fonts)
* [Solarized - Command Prompt theme](https://github.com/neilpa/cmd-colors-solarized)

I'm using a workaround for Oh-My-Posh so that I do not need ConEMU. Setting a Powerline font as the Powershell prompt font plus including the `$Env:ConEmuANSI = $true` env variable at the top of the prompt allows you to fully utilize Oh-My-Posh in a normal ps prompt as well as VSCode. 

In your VSCode config make sure you set your prompt font family to which ever Powerline font you are using. 