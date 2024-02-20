''
@define-color background-darker rgba(30, 31, 41, 230);
@define-color background #282a36;
@define-color selection #44475a;
@define-color foreground #f8f8f2;
@define-color comment #6272a4;
@define-color cyan #8be9fd;
@define-color green #50fa7b;
@define-color orange #ffb86c;
@define-color pink #ff79c6;
@define-color purple #bd93f9;
@define-color red #ff5555;
@define-color yellow #f1fa8c;

* {
    border: none;
    border-radius: 0;
    font-family: "JetBrainsMono Nerd Font";
    font-size: 11pt;
    min-height: 0;
}
window#waybar {
    opacity: 0.9;
    background: @background-darker;
    color: @foreground;
    border-bottom: 2px solid @background;
}
#workspaces button {
    padding: 0 10px;
    background: @background;
    color: @foreground;
}
#workspaces button:hover {
    box-shadow: inherit;
    text-shadow: inherit;
    background-image: linear-gradient(0deg, @selection, @background-darker);
}
#workspaces button.active {
    background-image: linear-gradient(0deg, @purple, @selection);
}
#workspaces button.urgent {
    background-image: linear-gradient(0deg, @red, @background-darker);
}
#taskbar button.active {
    background-image: linear-gradient(0deg, @selection, @background-darker);
}
#clock {
    padding: 0 4px;
    background: @background;
}
''
