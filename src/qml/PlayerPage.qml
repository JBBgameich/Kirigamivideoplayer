/*
* Copyright (C) 2014-2015 Leszek Lesner <leszek@zevenos.com>
*
* This library is free software; you can redistribute it and/or
* modify it under the terms of the GNU Lesser General Public
* License as published by the Free Software Foundation; either
* version 2.1 of the License, or (at your option) version 3, or any
* later version accepted by the membership of KDE e.V. (or its
* successor approved by the membership of KDE e.V.), which shall
* act as a proxy defined in Section 6 of version 3 of the license.
*
* This library is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
* Lesser General Public License for more details.
*
* You should have received a copy of the GNU Lesser General Public
* License along with this library.  If not, see <http://www.gnu.org/licenses/>.
*
*/

import QtQuick 2.1
import QtQuick.Layouts 1.1
import QtQuick.Controls 2.0 as Controls
import QtMultimedia 5.7
import org.kde.plasma.core 2.0
import org.kde.kirigami 2.0 as Kirigami

import org.nemomobile.qtmpris 1.0

import "qrc:/src/js/timeFormat.js" as TimeHelper
import "qrc:/src/js/db.js" as DB

Kirigami.Page {
	implicitWidth: 5000
	leftPadding: 0
	rightPadding: 0
	bottomPadding: 0
	topPadding: 0

	title: {
		if (streamTitle != "") {
			return streamTitle
		}
		else {
			return streamUrl
		}
	}

	id: videoPlayerPage

	Component.onCompleted: {
		// Automaticly start playing
		videoWindow.play();
		mprisPlayer.song = videoPlayerPage.title
	}

	onStreamUrlChanged: {
		// TODO: maybe youtube or other url checks
		videoWindow.source = streamUrl;
		// Correct Page title, this is just needed to work around a bug, maybe I've done this bad
		videoPlayerPage.title = mainWindow.streamTitle;
		// Write into history database
		DB.addHistory(streamUrl,videoPlayerPage.title);
		// Don't forgt to write it to the List aswell
		mainWindow.add2History(streamUrl,videoPlayerPage.text);
	}

	property string originalUrl: mainWindow.originalUrl
	property string streamUrl: mainWindow.streamUrl
	property bool isYtUrl: mainWindow.isYtUrl
	property string streamTitle: mainWindow.streamTitle
	property string artist: videoWindow.metaData.albumArtist ? videoWindow.metaData.albumArtist : ""
	property int subtitlesSize: mainWindow.subtitlesSize
	property bool boldSubtitles: mainWindow.boldSubtitles
	property string subtitlesColor: mainWindow.subtitlesColor
	property bool enableSubtitles: mainWindow.enableSubtitles
	property variant currentVideoSub: []
	property string url720p: mainWindow.url720p
	property string url480p: mainWindow.url480p
	property string url360p: mainWindow.url360p
	property string url240p: mainWindow.url240p
	property string ytQual: mainWindow.ytQual
	property bool autoplay: mainWindow.autoplay
	
	actions {
		main: Kirigami.Action {
			iconName: { 
				if (videoWindow.playbackState != MediaPlayer.PlayingState) 
					return "media-playback-start"
				else 
					return "media-playback-pause"
			}
			onTriggered: {
				if (videoWindow.playbackState != MediaPlayer.PlayingState) { 
					play();
                }
				else {
					pause();
                }
			}
			shortcut: "Space"
		}
		left: Kirigami.Action {
			iconName: "view-fullscreen"
			onTriggered: toggleControls()
		}
		right: Kirigami.Action {
			iconName: "media-playback-stop"
			onTriggered: {
				stop();
			}
		}
	}

	Rectangle {
		anchors.fill: parent
		color: "black"
	}

	IconItem {
		id: onlyAudioIcon
		source: "audio-x-generic"
		anchors.centerIn: parent
		width: parent.width / 2
		height: width
		visible: !videoWindow.hasVideo
	}

	// start / stop functions
	function play() {
		videoWindow.play();
		mprisPlayer.playbackStatus = Mpris.Playing;
		mprisPlayer.song = videoPlayerPage.title;
	}

	function pause() {
		videoWindow.pause();
		mprisPlayer.playbackStatus = Mpris.Paused;
	}

	function stop() {
		videoWindow.stop();
		mprisPlayer.playbackStatus = Mpris.Stopped;
		pageStack.pop();
	}


	function showControls() {
		timeLine.visible = true;
		timeLineLbl.visible = true;
		controlsVisible = true;
	}

	function hideControls() {
		timeLine.visible = false;
		timeLineLbl.visible = false;
		globalDrawer.drawerOpen = false;
		applicationWindow().controlsVisible = false;
	}

	function toggleControls() {
		if (timeLine.visible && applicationWindow().controlsVisible) 
			hideControls();
		else if (!timeLine.visible && !applicationWindow().controlsVisible) 
			showControls();	
	}

	Video {
		id: videoWindow
		anchors.fill: parent
		onDurationChanged: timeLine.to = duration / 1000
		onPositionChanged: timeLine.value = position / 1000

		MouseArea {
			anchors.fill: parent
			onClicked: toggleControls()
		}

		onStopped: {
			showControls()
			pageStack.pop
        }
	}
	
	MprisPlayer {
		id: mprisPlayer

		property string artist
		property string song

		serviceName: "vplayer"

		// Mpris2 Root Interface
		identity: "Video Player"
		supportedUriSchemes: ["file"]

		// Mpris2 Player Interface
		canControl: true

		canGoNext: false
		canGoPrevious: false
		canPause: playbackStatus == Mpris.Playing
		canPlay: playbackStatus != Mpris.Playing
		canSeek: true

		playbackStatus: Mpris.Stopped
		loopStatus: Mpris.None
		shuffle: false
		volume: 1

		onPauseRequested: pause()
		onPlayRequested: play()
		onStopRequested: stop()
		onSeekRequested: {
			if (videoWindow.seekable) videoWindow.seek(value * 1000)
		}
	}

	Kirigami.Label {
		id: timeLineLbl
		text: TimeHelper.formatTime(timeLine.value) + "/" + TimeHelper.formatTime(timeLine.maximumValue)
		anchors.bottom: videoWindow.bottom
		anchors.right: videoWindow.right
	}
	
	Controls.Slider {
		id: timeLine
		from: 1
		width: parent.width
		onPressedChanged: {
			if (!pressed) {
				if (videoWindow.seekable) videoWindow.seek(value * 1000)
			}
		}
	}
}
