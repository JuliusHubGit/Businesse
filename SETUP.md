# Setup und Installation

## Raspberry Pi Vorbereitung

### 1. Betriebssystem Installation

#### Option A: Raspberry Pi Imager (Empfohlen)
1. Download [Raspberry Pi Imager](https://www.raspberrypi.com/software/)
2. microSD-Karte in Computer einstecken
3. Imager starten und auswählen:
   - **OS:** Raspberry Pi OS (32-bit) mit Desktop
   - **Storage:** Ihre microSD-Karte
4. Einstellungen (Zahnrad-Symbol):
   - Hostname setzen (z.B. `photoframe`)
   - SSH aktivieren
   - WLAN konfigurieren (SSID und Passwort)
   - Benutzername und Passwort setzen (Standard: `pi`)
   - Zeitzone einstellen
5. Schreiben und warten

#### Option B: Manuelle Installation
1. Download [Raspberry Pi OS](https://www.raspberrypi.com/software/operating-systems/)
2. Mit Tool wie Etcher auf microSD-Karte schreiben
3. SSH aktivieren: leere Datei `ssh` im boot-Verzeichnis erstellen
4. WLAN konfigurieren: `wpa_supplicant.conf` im boot-Verzeichnis erstellen

### 2. Erste Schritte

1. microSD-Karte in Raspberry Pi einsetzen
2. Display und Stromversorgung anschließen
3. Raspberry Pi startet automatisch
4. Bei SSH: `ssh pi@photoframe.local` (oder IP-Adresse)
5. Beim ersten Start: System aktualisieren
```bash
sudo apt update
sudo apt upgrade -y
```

### 3. Display Konfiguration

Das 7" HDMI Display sollte automatisch erkannt werden. Falls nicht:

```bash
# Display-Auflösung prüfen
tvservice -s

# Falls Anpassung nötig in /boot/config.txt:
sudo nano /boot/config.txt

# Fügen Sie hinzu (falls nötig):
hdmi_group=2
hdmi_mode=87
hdmi_cvt=1024 600 60 6 0 0 0
```

Neustart: `sudo reboot`

## Photo Frame Software Installation

### 1. Repository klonen

```bash
cd /home/pi
git clone https://github.com/JuliusHubGit/Businesse.git
cd Businesse
```

### 2. Abhängigkeiten installieren

```bash
# Python-Pakete installieren
pip3 install -r requirements.txt

# Oder manuell:
pip3 install Pillow
```

### 3. Bildordner erstellen

```bash
mkdir -p /home/pi/Pictures
```

### 4. Konfiguration anpassen

```bash
nano config.json
```

Beispiel-Konfiguration:
```json
{
  "image_folder": "/home/pi/Pictures",
  "interval_seconds": 30,
  "shuffle": true,
  "fullscreen": true
}
```

**Parameter:**
- `image_folder`: Pfad zum Ordner mit Bildern
- `interval_seconds`: Zeit in Sekunden zwischen Bildwechseln (30 = 30 Sekunden)
- `shuffle`: Zufällige Reihenfolge (true) oder sortiert (false)
- `fullscreen`: Vollbildmodus (true/false)

### 5. Testlauf

```bash
# Testbilder hinzufügen (optional)
# Eigene Bilder nach /home/pi/Pictures kopieren

# Programm starten
python3 photo_frame.py
```

**Tastenkombinationen:**
- `Escape`: Vollbildmodus verlassen
- `q`: Programm beenden

## Automatischer Start beim Booten

### Option A: Systemd Service (Empfohlen)

1. Service-Datei erstellen:
```bash
sudo nano /etc/systemd/system/photoframe.service
```

2. Inhalt einfügen:
```ini
[Unit]
Description=Photo Frame Slideshow
After=graphical.target

[Service]
Type=simple
User=pi
WorkingDirectory=/home/pi/Businesse
Environment=DISPLAY=:0
Environment=XAUTHORITY=/home/pi/.Xauthority
ExecStart=/usr/bin/python3 /home/pi/Businesse/photo_frame.py
Restart=on-failure
RestartSec=10

[Install]
WantedBy=graphical.target
```

3. Service aktivieren:
```bash
sudo systemctl daemon-reload
sudo systemctl enable photoframe.service
sudo systemctl start photoframe.service
```

4. Status prüfen:
```bash
sudo systemctl status photoframe.service
```

### Option B: Autostart (Alternative)

1. Autostart-Datei erstellen:
```bash
mkdir -p /home/pi/.config/autostart
nano /home/pi/.config/autostart/photoframe.desktop
```

2. Inhalt:
```ini
[Desktop Entry]
Type=Application
Name=Photo Frame
Exec=python3 /home/pi/Businesse/photo_frame.py
```

## Bildschirmschoner deaktivieren

```bash
sudo nano /etc/xdg/lxsession/LXDE-pi/autostart
```

Folgende Zeilen hinzufügen:
```
@xset s noblank
@xset s off
@xset -dpms
```

## Energiespareinstellungen

Für einen Bilderrahmen, der immer läuft:

```bash
# In /boot/config.txt
sudo nano /boot/config.txt

# Hinzufügen:
hdmi_blanking=1
```

## Troubleshooting

### Display zeigt kein Bild
- HDMI-Kabel prüfen
- Display-Stromversorgung prüfen
- `/boot/config.txt` Einstellungen prüfen

### Programm startet nicht automatisch
- Service-Status prüfen: `sudo systemctl status photoframe.service`
- Logs anzeigen: `journalctl -u photoframe.service -f`
- DISPLAY-Variable prüfen

### Bilder werden nicht angezeigt
- Bildordner-Pfad in `config.json` prüfen
- Berechtigungen prüfen: `ls -la /home/pi/Pictures`
- Unterstützte Formate: JPG, PNG, GIF, BMP

### Python-Fehler
- Pillow installiert?: `pip3 list | grep Pillow`
- Python-Version: `python3 --version` (sollte 3.7+)
