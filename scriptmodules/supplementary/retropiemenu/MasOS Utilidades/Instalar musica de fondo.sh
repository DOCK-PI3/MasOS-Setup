#!/usr/bin/env bash

infobox= ""
infobox="${infobox}___________________________________________________________________________\n\n"
infobox="${infobox}Instalador Herramienta Musica de fondo para ES , BGM MasOS\n\n"
infobox="${infobox}14-06-2019...Version del script: 5.0a \n"
infobox="${infobox}Reproductor usado python-es-bgm ,creado por Rydra https://github.com/Rydra/bgm-for-es \n"
infobox="${infobox}Install BGM MasOS Backgroud Music Tool for emulationstation\n\n"
infobox="${infobox}-Scrip instalador creado por mabedeep para MasOS 4.X.X\n By MasOS Team\n\n"
infobox="${infobox}NOTA: Agregada opcion para actualizar el detector de cores BGM... \nMas de 70 emuladores y ports ,aparte los cores de retroarch añadidos!\n\n"
infobox="${infobox}Script 100% funcional. Si falla alguna opcion avisenos por telegram! Salu2\n\n"
infobox="${infobox}___________________________________________________________________________\n\n"

dialog --backtitle "MasOS BGM Toolkit" \
--title "Instalador BGM Musica de fondo para ES" \
--msgbox "${infobox}" 23 80

function main_menu() {
    local choice

    while true; do
        choice=$(dialog --backtitle "$BACKTITLE" --title " MAIN MENU " \
            --ok-label OK --cancel-label Exit \
            --menu "Que accion le gustaria realizar?" 25 75 20 \
            1 "Instalar BGM MasOS Background Music" \
			2 "Desactivar o Activar BGM MasOS ,solo despues de instalar" \
            3 "Limpiar de .MP3 el directorio music" \
			4 "EXTRA BGM Descargar DOCK-PI3 ARCADE COLLECTIONS" \
			5 "EXTRA BGM Descargar HEAZYHAX Default install" \
			6 "EXTRA BGM Descargar DOCK-PI3 BSO COLLECTIONS" \
			7 "BGM MasOS Detector de cores, emuladores y ports. ACTUALIZAR..." \
            2>&1 > /dev/tty)

        case "$choice" in
            1) Instalar_BGMUSICA  ;;
			2) off_on_bgm  ;;
			3) limpiar_mp3Dir  ;;
            4) dockpi3_bgmPack  ;;
			5) default_bgmPack  ;;
			6) dockpi3_bgmPackBSO  ;;
			7) detector_cores  ;;
			*)  break ;;
        esac
    done
}

function Instalar_BGMUSICA() {                                          #
dialog --infobox "... Nuevo Script instalador musica de fondo para ES bgm..." 30 55 ; sleep 3
sudo killall emulationstation
# sudo killall emulationstation-dev
sudo sh -c 'echo "deb [trusted=yes] https://repo.fury.io/rydra/ /" > /etc/apt/sources.list.d/es-bgm.list'
sudo apt update
sudo apt install -y python-pygame python-es-bgm
echo -e "\n\n\n   Descargando algo de musica para usted.\n\n\n"
sleep 3
sudo mkdir /home/pi/MasOS/roms/music
sudo chown -R pi:pi /home/pi/MasOS/roms/music
cd /home/pi/MasOS/roms/ && wget http://eazyhax.com/downloads/music.zip -O /home/pi/MasOS/roms/music.zip
unzip -o music.zip && rm music.zip
sudo chown -R pi:pi /etc/bgmconfig.ini
   sudo cat > /etc/bgmconfig.ini <<_EOF_
[default]
startdelay = 0
musicdir = /home/pi/MasOS/roms/music
restart = True
startsong =
_EOF_
echo -e "\n\n\n   El directorio por defecto donde introducir los .mp3 es /home/pi/MasOS/roms/music \n\n\n.Meta sus mp3 y reinicie el sistema para empezar a escuchar su musica.\n\n\nReiniciando en 7s"
sleep 7
sudo chown -R pi:pi /home/pi/MasOS/roms/music
sudo rm -R /home/pi/RetroPie/roms
sudo reboot
}

#########################################################################
# Activar o descativar la musica de fondo ,para es bgm #
function off_on_bgm() {
        if [[ -f /etc/bgmconfig.ini ]]; then
			sudo chown -R pi:pi /etc/bgmconfig.ini
			sudo mv /etc/bgmconfig.ini /etc/bgmconfig_off.ini
			echo -e "\n\n\n   Desactivando la musica de fondo y reiniciando en 3s.\n\n\n"
		sleep 3
		sudo reboot
    else
        if [[ -f /etc/bgmconfig_off.ini ]]; then
			sudo chown -R pi:pi /etc/bgmconfig_off.ini
			sudo mv /etc/bgmconfig_off.ini /etc/bgmconfig.ini
			echo -e "\n\n\n   Activando la musica de fondo y reiniciando en 3s.\n\n\n"
		sleep 3
		sudo reboot
	fi
		fi
# ---------------------------- #
}

#########################################################################
# Limpiar directorio de musica #
function limpiar_mp3Dir() {
			echo -e "\n\n\n   Este script elimina el directorio completo y lo crea nuevo !....\n\n\n"
		sleep 2
			sudo chown -R pi:pi /home/pi/MasOS/roms/music
			sudo rm -R /home/pi/MasOS/roms/music
			sudo mkdir /home/pi/MasOS/roms/music
			sudo chown -R pi:pi /home/pi/MasOS/roms/music
			echo -e "\n\n\n   Se eliminaron todos sus ficheros de /music.....\n\n\n"
		sleep 2
# ---------------------------- #
}

#########################################################################
# Descargar pack dock-pi3 bgm #
function dockpi3_bgmPack() {
			echo -e "\n\n\n   Descargando pack personal Arcade dock-pi3.  ,.....Espere!.....\n\n\nTamaño en disco: 141 mb\n\n\nCanciones: 39 ficheros\n\n\nCategoria: ARCADES\n\n\nFormato: .mp3"
			sleep 5
			cd && wget https://archive.org/download/BGMDOCKPI3COLLECTIONS/BGM_DOCK-PI3_COLLECTIONS.zip -O /home/pi/BGM_DOCK-PI3_COLLECTIONS.zip
			sudo chown -R pi:pi /home/pi/MasOS/roms/music
			unzip -o BGM_DOCK-PI3_COLLECTIONS.zip && cp -R /home/pi/BGM_DOCK-PI3_COLLECTIONS/*.mp3 /home/pi/MasOS/roms/music/
			cd
			rm BGM_DOCK-PI3_COLLECTIONS.zip && rm -R /home/pi/BGM_DOCK-PI3_COLLECTIONS/
			sudo chown -R pi:pi /home/pi/MasOS/roms/music
		  echo -e "\n\n\n   El pack dock-pi3 se descargo correctamente!.....\n\n\nRecuerde reiniciar el sistema para empezar a escuchar la musica.!\n\n\n"
		sleep 3
# ---------------------------- #
}

#########################################################################
# Descargar pack dock-pi3 bgm BSO #
function dockpi3_bgmPackBSO() {
			echo -e "\n\n\n   Descargando pack personal BSO dock-pi3.  ,.....Espere!.....\n\n\nTamaño en disco: 260 mb\n\n\nCanciones: 35 ficheros\n\n\nCategoria: Pelis BSO\n\n\nFormato: .mp3"
			sleep 5
			cd && wget https://archive.org/download/BGMDOCKPI3BSO/BGM_DOCK-PI3_BSO.zip -O /home/pi/BGM_DOCK-PI3_BSO.zip
			sudo chown -R pi:pi /home/pi/MasOS/roms/music
			unzip -o BGM_DOCK-PI3_BSO.zip && cp -R /home/pi/BGM_DOCK-PI3_BSO/*.mp3 /home/pi/MasOS/roms/music/
			cd
			rm BGM_DOCK-PI3_BSO.zip && rm -R /home/pi/BGM_DOCK-PI3_BSO/
			sudo chown -R pi:pi /home/pi/MasOS/roms/music
		  echo -e "\n\n\n   El pack dock-pi3 BSO se descargo correctamente!.....\n\n\nRecuerde reiniciar el sistema para empezar a escuchar la musica.!\n\n\n"
		sleep 3
# ---------------------------- #
}

#########################################################################
# Descargar pack Default bgm #
function default_bgmPack() {
			echo -e "\n\n\n   Descargando el pack que se instala por Defecto.\n\n\nPack creado por EAZYHAX , http://eazyhax.com .....Espere!.....\n\n\n"
			sleep 3
			sudo chown -R pi:pi /home/pi/MasOS/roms/music
				cd /home/pi/MasOS/roms/ && wget http://eazyhax.com/downloads/music.zip -O /home/pi/MasOS/roms/music.zip
					unzip -o music.zip && rm music.zip
				  sudo chown -R pi:pi /home/pi/MasOS/roms/music
				echo -e "\n\n\n   El pack por defecto se descargo correctamente!.....\n\n\nRecuerde reiniciar el sistema para empezar a escuchar la musica.!\n\n\n"
			sleep 3
# ---------------------------- #
}

#########################################################################
# Detector de cores ,emuladores y ports , bgm #
function detector_cores() {
			echo -e "\n\n\n  Actualizando el detector BGM MasOS.....Espere!.....\n\n\n"
			sleep 3
			  sudo service bgm stop
			sudo chown -R pi:pi /usr/lib/python2.7/dist-packages/bgm/
		  sudo cp -R /usr/lib/python2.7/dist-packages/bgm/Application.py /usr/lib/python2.7/dist-packages/bgm/Application_back.py
		sudo cat > /usr/lib/python2.7/dist-packages/bgm/Application.py <<_EOF_
import random
import os
from Queue import LifoQueue
import time


class State:
    def __init__(self, name):
        self.name = name

State.paused = State("Paused")
State.stopped = State("Stopped")
State.playingMusic = State("PlayingMusic")


class Application:
    random.seed()

    def getSongs(self):
        return [song for song in os.listdir(self.musicdir) if song[-4:] == ".mp3" or song[-4:] == ".ogg"]

    def getRandomQueue(self):

        song_queue = LifoQueue()
        song_list = self.getSongs()

        if self.startsong in song_list:
            song_queue.put(self.startsong)
            song_list.remove(self.startsong)

        while len(song_list) > 0:
            song_to_add = random.randint(0, len(song_list) - 1)
            song_queue.put(song_list[song_to_add])
            song_list.remove(song_list[song_to_add])

        return song_queue

    # ACTIONS

    def delay(self):
        time.sleep(2)

    def stopMusic(self):
        self.musicPlayer.stop()

    def fadeUp(self):
        self.musicPlayer.fadeUpMusic()

    def fadeDown(self):
        self.musicPlayer.fadeDownMusic(not self.restart)

    def playMusic(self):
        if self.songQueue.empty():
            self.songQueue = self.getRandomQueue()

        song = os.path.join(self.musicdir, self.songQueue.get())
        self.musicPlayer.playSong(song)

    # CONDITIONS

    def hasToStopMusic(self, status):
        return not status["emulatorIsRunning"] and (status["musicIsDisabled"] or not status["esRunning"])

    def emulatorIsNotRunning(self, status):
        return not status["emulatorIsRunning"]

    def shouldFadeDownAndStop(self, status):
        return status["emulatorIsRunning"] and self.restart

    def shouldFadeDownAndPause(self, status):
        return status["emulatorIsRunning"] and not self.restart

    def hasToPlayMusic(self, status):
        return status["esRunning"] and not status["emulatorIsRunning"]

    def musicIsNotPlaying(self, status):
        return not self.musicPlayer.isPlaying

    def __init__(self, process_service, music_player, settings, forced_initial_status = None):
        self.processService = process_service
        self.musicPlayer = music_player

        self.startdelay = settings.getint("default", "startdelay")
        self.musicdir = settings.get("default", "musicdir")
        self.restart = settings.getboolean("default", "restart")
        self.startsong = settings.get("default", "startsong")

        self.songQueue = self.getRandomQueue()

        self.emulatornames = ["retroarch", "ags", "advmame", "amiberry", "coolcv", "uae4all2", "uae4arm", "capricerpi", "linapple", "hatari", "stella", "n64", "dreamcast",
                              "atari800", "xroar", "vice", "dolphin", "daphne", "gearboy", "kat5200", "reicast", "pifba", "osmose", "gpsp", "jzintv", "jukebox", "fruitbox", 
                              "solarus_run", "basiliskll", "mame", "mame4all", "minivmac", "drastic", "dgen", "openmsx", "mupen64plus", "gngeo", "dosbox", "dosbox-sdl2",
                              "zelda_roth_se", "ppsspp", "simcoupe", "np2", "pcsx2", "oricutron", "scummvm", "snes9x", "pisnes", "frotz", "fbzx", "fuse", "fs-uae", "gemrb",
                              "zsxd", "zsdx", "cgenesis", "zdoom", "pcsx", "pokemini", "px68k", "quasi88", "eduke32", "lincity", "love", "kodi", "alephone", "micropolis",
                              "openbor", "OpenBOR", "openttd", "rpix86", "sdltrs", "ti99sim", "uae4all", "opentyrian", "cannonball", "tyrquake", "quake3", "ioquake3.arm", "residualvm",
                              "xrick", "sdlpop", "xm7", "zesarux", "uqm", "stratagus", "wolf4sdl", "ports", "chromium", "gamemaker", "MalditaCastilla", "retropie", "solarus"]

        self.transitionTable = {
            State.paused: [
                (self.hasToStopMusic, self.stopMusic, State.stopped),
                (self.emulatorIsNotRunning, self.fadeUp, State.playingMusic),
                (None, self.delay, State.paused)],

            State.stopped: [
                (self.hasToPlayMusic, self.playMusic, State.playingMusic),
                (None, self.delay, State.stopped)],

            State.playingMusic: [
                (self.hasToStopMusic, self.stopMusic, State.stopped),
                (self.shouldFadeDownAndPause, self.fadeDown, State.paused),
                (self.shouldFadeDownAndStop, self.fadeDown, State.stopped),
                (self.musicIsNotPlaying, self.playMusic, State.playingMusic),
                (None, self.delay, State.playingMusic)]
        }

        if forced_initial_status is None:
            self.currentState = self.getInitialState()
        else:
            self.currentState = forced_initial_status

    def getInitialState(self):
        if self.musicPlayer.isPlaying:
            return State.playingMusic
        elif self.musicPlayer.isPaused:
            return State.paused
        else:
            return State.stopped

    def getState(self):

        state = {
            "musicIsDisabled": self.musicIsDisabled(),
            "esRunning": self.processService.processIsRunning("emulationstatio"),
            "emulatorIsRunning": self.processService.anyProcessIsRunning(self.emulatornames),
            "songIsBeingPlayed": self.musicPlayer.isPlaying,
            "restart": self.restart
        }

        return state

    def waitForProcess(self, process_name):
        while not self.processService.processIsRunning(process_name):
            time.sleep(1)

    def musicIsDisabled(self):
        return os.path.exists('/home/pi/PyScripts/DisableMusic')

    def waitomxPlayer(self):
        # Look for OMXplayer - if it's running, someone's got a splash screen going!

        while self.processService.processIsRunning("omxplayer"):
            time.sleep(1)  # OMXPlayer is running, sleep 1 to prevent the need for a splash.

        while self.processService.processIsRunning("omxplayer.bin"):
            time.sleep(1)

    def executeState(self):

        status = self.getState()
        transitions = self.transitionTable[self.currentState]
        for condition, action, nextState in transitions:

            if condition is None or condition(status):
                action()
                self.currentState = nextState
                break

    def run(self):

        # Delay audio start per config option above
        if self.startdelay > 0:
            time.sleep(self.startdelay)

        self.waitomxPlayer()

        while True:
            self.executeState()

_EOF_
				  
echo -e "\n\n\n   Detector actualizado correctamente!.....\n\n\nReiniciando el sistema.!\n\n\n"
		sleep 3
sudo reboot
# ---------------------------- #
}


main_menu