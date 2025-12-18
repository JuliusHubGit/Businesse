# Quick Start Guide

## 5-Minuten Schnellstart

### Schritt 1: Hardware aufbauen

1. **Display verbinden:**
   - Mini HDMI Kabel vom Raspberry Pi zum Display
   - USB-Kabel für Touchscreen (optional)
   - Display an Stromversorgung anschließen

2. **Raspberry Pi vorbereiten:**
   - microSD-Karte mit Raspberry Pi OS einsetzen
   - Stromversorgung anschließen

### Schritt 2: Software installieren

```bash
# Terminal öffnen (oder per SSH verbinden)
cd /home/pi
git clone https://github.com/JuliusHubGit/Businesse.git
cd Businesse
./install.sh
```

Das Installationsskript fragt Sie:
- ✅ Samba installieren? → **Ja** (für einfache Bildübertragung)
- ✅ Autostart aktivieren? → **Ja** (startet automatisch)
- ✅ Bildschirmschoner deaktivieren? → **Ja** (empfohlen)

### Schritt 3: Erste Bilder hinzufügen

**Von Windows:**
```
1. Windows Explorer öffnen
2. Eingeben: \\photoframe.local\Pictures
3. Benutzername: pi
4. Passwort: [Ihr Samba-Passwort]
5. Bilder per Drag & Drop hinzufügen
```

**Direkt auf dem Pi:**
```bash
# Testbilder herunterladen (optional)
cd /home/pi/Pictures
wget https://picsum.photos/1024/600 -O test1.jpg
wget https://picsum.photos/1024/600 -O test2.jpg
wget https://picsum.photos/1024/600 -O test3.jpg
```

### Schritt 4: Starten

**Manuell:**
```bash
cd /home/pi/Businesse
python3 photo_frame.py
```

**Automatisch (nach Installation mit Autostart):**
```bash
sudo systemctl start photoframe.service
```

Oder einfach Raspberry Pi neu starten!

---

## Anpassungen

### Intervall ändern

```bash
cd /home/pi/Businesse
nano config.json
```

Ändern Sie `interval_seconds`:
- `30` = 30 Sekunden
- `60` = 1 Minute
- `300` = 5 Minuten

### Verschiedene Bildordner nutzen

```bash
# Erstellen Sie z.B. Ordner für verschiedene Themen
mkdir -p /home/pi/Pictures/Urlaub
mkdir -p /home/pi/Pictures/Familie

# In config.json ändern:
"image_folder": "/home/pi/Pictures/Urlaub"
```

### Zufällige oder sortierte Reihenfolge

In `config.json`:
- `"shuffle": true` → Zufällige Reihenfolge
- `"shuffle": false` → Alphabetisch sortiert

---

## Nützliche Befehle

### Status prüfen
```bash
sudo systemctl status photoframe.service
```

### Neustart
```bash
sudo systemctl restart photoframe.service
```

### Logs anzeigen
```bash
journalctl -u photoframe.service -f
```

### Service stoppen
```bash
sudo systemctl stop photoframe.service
```

### Autostart deaktivieren
```bash
sudo systemctl disable photoframe.service
```

---

## Bildoptimierung

Für beste Performance:

```bash
# Installieren Sie ImageMagick
sudo apt install imagemagick

# Bilder auf optimale Größe konvertieren (1024x600 für 7" Display)
cd /home/pi/Pictures
mogrify -resize 1024x600 -quality 85 *.jpg
```

---

## Tipps für das perfekte Geschenk

1. **Vorbereitung:**
   - Alles komplett einrichten und testen
   - 10-20 schöne Familienfotos vorinstallieren
   - Beschriften Sie Kabel (z.B. "Display Strom", "Pi Strom")

2. **Dokumentation:**
   - Drucken Sie BENUTZERANLEITUNG.md aus
   - Schreiben Sie WLAN-Passwort und Samba-Passwort auf einen Zettel
   - Fügen Sie Ihre Kontaktdaten für Support hinzu

3. **Gehäuse:**
   - Kaufen Sie ein schönes Gehäuse oder 3D-drucken Sie eines
   - Alternativ: Einfacher Bilderrahmen aus Holz

4. **Übergabe:**
   - Zeigen Sie, wie man den Stecker ein-/aussteckt
   - Demonstrieren Sie das Hinzufügen neuer Bilder
   - Lassen Sie es eingeschaltet!

---

**Viel Erfolg! 🎁**
