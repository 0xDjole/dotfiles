#!/bin/bash



i3-msg "[class=”.*”] kill;"
# First we append the saved layout of workspace N to workspace M
i3-msg "workspace 1: Editor; append_layout ~/.config/i3/workspace_1.json"
i3-msg "workspace 2: Terminal; append_layout ~/.config/i3/workspace_2.json"
i3-msg "workspace 3: Browser; append_layout ~/.config/i3/workspace_3.json"
i3-msg "workspace 4: Communication; append_layout ~/.config/i3/workspace_4.json"
i3-msg "workspace 5: Helper; append_layout ~/.config/i3/workspace_5.json"

(alacritty --title Editor &)
(alacritty --title Core &)
(google-chrome-stable &)
(discord &)
(slack &)
(alacritty --title Helper &)
(alacritty --title Helper &)
