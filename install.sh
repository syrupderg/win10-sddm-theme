#!/bin/bash

echo ""

echo " (1) - Install Windows 10 SDDM Theme"
echo " (2) - Install Windows Cursor Icon"
echo " (3) - Fix SDDM for Wayland and add On Screen Keyboard support"

echo ""

echo "Please type only number(s) to pick options: (e.g: "1 2")"
   
read -p ":: " input

function sddm() {

    sudo curl --no-clobber --output-dir "/usr/share/sddm/themes" -LO https://github.com/syrupderg/win10-sddm-theme/releases/download/1.2/win10-sddm-theme.tar.gz

    sudo tar -xzf /usr/share/sddm/themes/win10-sddm-theme.tar.gz -C /usr/share/sddm/themes

    sudo rm -rf /usr/share/sddm/themes/win10-sddm-theme.tar.gz

    edit
}

function edit() {

    if [[ $XDG_CURRENT_DESKTOP == "KDE" ]]; then

    sudo sed -i '/Current=/d' /etc/sddm.conf.d/kde_settings.conf

    sudo sed -i '/Theme]/a\
Current=win10-sddm-theme
' /etc/sddm.conf.d/kde_settings.conf

    else

    sudo sed -i '/Current=/d' /etc/sddm.conf

    sudo sed -i '/Theme]/a\
Current=win10-sddm-theme
' /etc/sddm.conf

    fi
}

function wayland() {

    if [ ! -f "/etc/sddm.conf.d/10-wayland.conf" ]; then

    sudo mkdir -p /etc/sddm.conf.d

    sudo tee "/etc/sddm.conf.d/10-wayland.conf" > /dev/null <<EOF
[General]
DisplayServer=wayland
GreeterEnvironment=QT_WAYLAND_SHELL_INTEGRATION=layer-shell

[Wayland]
CompositorCommand=kwin_wayland --drm --no-lockscreen --no-global-shortcuts --locale1 --inputmethod plasma-keyboard
EOF

    fi

}

function cursor() {
    sudo curl --no-clobber --output-dir "/usr/share/icons" -LO https://github.com/syrupderg/windows-cursors/releases/download/1.0/windows-cursors.tar.gz

    sudo tar -xzf /usr/share/icons/windows-cursors.tar.gz -C /usr/share/icons/

    sudo cp /usr/share/icons/windows-cursors/index.theme /usr/share/icons/default/index.theme

    sudo cp -r /usr/share/icons/windows-cursors/cursors /usr/share/icons/default

    sudo rm -rf /usr/share/icons/windows-cursors

    sudo rm -f /usr/share/icons/windows-cursors.tar.gz
}

if [[ $input == "1" ]]; then

    echo ""
    echo "Installing Windows 10 SDDM Theme..."
    echo ""

    sddm

    echo "Done."

elif [[ $input == "2" ]]; then

    echo ""
    echo "Installing Windows Cursor Icons..."
    echo ""

    cursor

    echo "Done."

elif [[ $input == "3" ]]; then

    echo ""
    echo "Fixing SDDM for Wayland and adding On Screen Keyboard support..."
    echo ""

    cursor

    echo "Done."

elif [[ $input == "1 2" ]]; then

    echo ""
    echo "Installing Windows 10 SDDM Theme and Windows Cursor Icons..."
    echo ""

    sddm
    cursor

    echo "Done."

elif [[ $input == "1 2 3" ]]; then

    echo ""
    echo "Installing Windows 10 SDDM Theme, Windows Cursor Icons and fixing SDDM for Wayland and adding On Screen Keyboard support..."
    echo ""

    sddm
    cursor
    wayland

    echo "Done."


elif [[ $input == "2 3" ]]; then

    echo ""
    echo "Windows Cursor Icons and fixing SDDM for Wayland and adding On Screen Keyboard support..."
    echo ""

    sddm
    cursor

    echo "Done."

elif [[ $input == "1 3" ]]; then

    echo ""
    echo "Installing Windows 10 SDDM Theme and fixing SDDM for Wayland and adding On Screen Keyboard support..."
    echo ""

    sddm
    wayland

    echo "Done."

else

    echo ""
    echo "Invalid number, please try again."; exit 1

fi
