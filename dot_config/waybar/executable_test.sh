echo $(find $HOME/.config/waybar/*.css -iname "*.css" -execdir basename {} .css ';') >> ~/out.txt
