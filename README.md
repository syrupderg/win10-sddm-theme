# Windows 10 Login Screen SDDM Theme

## Table of contents

1. [Gallery](#gallery)
2. [Missing Features](#missing-features)
3. [Requirement](#requirements)
4. [Installation](#installation)
   - [From KDE Plasma system settings](#from-kde-plasma-system-settings)
   - [Manual installation on KDE Plasma desktop environment](#manual-installation-on-kde-plasma-desktop-environment)
   - [If you're not using KDE Plasma](#if-youre-not-using-kde-plasma)

5. [Testing](#testing)

## Gallery

<details>
  <summary>Click to view screenshots</summary>

![win10-sddm-gallery1](https://github.com/birbkeks/win10-sddm-theme/assets/67545942/874cec18-953d-44db-832b-4f88fb0444e3)

![win10-sddm-gallery2](https://github.com/birbkeks/win10-sddm-theme/assets/67545942/ed41c78f-4822-456a-93e0-3cc25860fdc7)

![win10-sddm-gallery3](https://github.com/birbkeks/win10-sddm-theme/assets/67545942/3cf94dd4-c2b1-418e-a169-657d1a3e3a04)

![win10-sddm-gallery4](https://github.com/birbkeks/win10-sddm-theme/assets/67545942/25dc7836-6c3c-4e24-9121-dbc94a325a5d)

</details>

## Missing Features
Missing features from Windows 10 login screen that's planned to be added in the future:

- Internet icons
- Successful login message [(this is a SDDM bug, waiting it to be fixed)](https://github.com/sddm/sddm/issues/1960)

## Requirements

> [!CAUTION]
>Please install [Segoe UI Regular](https://github.com/microsoft/reactxp/raw/master/samples/TodoList/src/resources/fonts/SegoeUI-Regular.ttf),
  [Segoe UI Light](https://github.com/microsoft/reactxp/raw/master/samples/TodoList/src/resources/fonts/SegoeUI-Light.ttf) and
    [Segoe MDL2](https://github.com/syncfusion/xamarin-demos/raw/master/Forms/TabView/TabView.UWP/Assets/Fonts/Segoe%20MDL2%20Assets.ttf)
      font to use this SDDM theme!

No extra Qt packages are required for 6 and higher versions of KDE Plasma and Qt.
On XFCE or other desktop environments might require additional Qt packages. (Currently I do not know which ones are required.)

> [!IMPORTANT]
>5 and lower versions of KDE Plasma/Qt might require additional Qt packages but there are no quarantee of the theme working properly. Please do NOT open an issue if you are using older versions of KDE Plasma/Qt.


## Installation

You can use installation script to install this theme, [required fonts](#requirements) and [Windows Cursors](https://github.com/birbkeks/windows-cursors)! 

```
wget https://raw.githubusercontent.com/birbkeks/win10-sddm-theme/main/install.sh
chmod +x install.sh
./install.sh
```

> [!CAUTION]
>Please make sure to install [required fonts](#requirements) first!

### From KDE Plasma system settings:
1. Open System Settings.
2. Go to Colors & Themes and click on Login Screen (SDDM).
3. Click on "Get New..." and search for this theme, and install it from there.

### Manual installation on KDE Plasma desktop environment:
1- You can download this theme from [github releases](https://github.com/birbkeks/win10-sddm-theme/releases) or from [store.kde.org](https://store.kde.org/p/2170777) page! <br>
2- Extract "win10-sddm-theme.tar.gz" to `/usr/share/sddm/themes`. <br>
3- Edit /etc/sddm.conf.d/kde_settings.conf  and under `[Theme]`, change `Current=` to `Current=win10-sddm-theme`.

### If you're not using KDE Plasma:
1- You can download this theme from [github releases](https://github.com/birbkeks/win10-sddm-theme/releases) or from [store.kde.org](https://store.kde.org/p/2170777) page! <br>
2- Extract "win10-sddm-theme.tar.gz" to `/usr/share/sddm/themes`. <br>
3- Edit /etc/sddm.conf  and under `[Theme]`, change `Current=` to `Current=win10-sddm-theme`.

## Testing

If you want to test this theme before using it, you can use this command on your terminal to test this or other SDDM themes. Make sure to replace "/path/to/directory" with the directory of SDDM theme you installed.

```
env -i HOME=$HOME DISPLAY=$DISPLAY XAUTHORITY=$XAUTHORITY sddm-greeter-qt6 --test-mode --theme /path/to/directory
```

![](preview.png)
