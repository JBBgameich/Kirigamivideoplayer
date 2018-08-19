/*
 * Copyright (C) 2017 JBBgameich <jbb.mail@gmx.de>
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

import org.kde.kirigami 2.0 as Kirigami

Kirigami.GlobalDrawer {
	id: drawer

	title: "Video Player"
	titleIcon: "vplayer"

	drawerOpen: false
	// show open button on the left side
	handleVisible: true
	modal: true

	function switchPage(page) {
		pageStack.clear()
		pageStack.push(page)
	}

	actions: [
		Kirigami.Action {
			text: qsTr("History")
			iconName: "view-list-icons"
			onTriggered: switchPage(historyPageComponent)
		},
		Kirigami.Action {
			text: qsTr("Youtube Search")
			iconName: "smtube"
			onTriggered: switchPage(youtubeSearchComponent)
		},
		Kirigami.Action {
			text: qsTr("Open File")
			iconName: "document-open"
			onTriggered: switchPage(openDialogComponent)
		},
		Kirigami.Action {
			text: qsTr("Open Url")
			iconName: "applications-internet"
			onTriggered: switchPage(openUrlComponent)
		},
		Kirigami.Action {
			text: qsTr("About Video Player")
			iconName: "help-about"
			onTriggered: switchPage(aboutPageComponent)
		}
	]
}

