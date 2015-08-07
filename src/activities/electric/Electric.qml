/* GCompris - electric.qml
 *
 * Copyright (C) 2015 Sagar Chand Agarwal <atomsagar@gmail.com>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
 *   Sagar Chand Agarwal <atomsagar@gmail.com> (Qt Quick Port)
 *   Pulkit Gupta <pulkitgenius@gmail.com> (Qt Quick - Babymatch.qml )
 *
 *   This program is free software; you can redistribute it and/or modify
 *   it under the terms of the GNU General Public License as published by
 *   the Free Software Foundation; either version 3 of the License, or
 *   (at your option) any later version.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU General Public License for more details.
 *
 *   You should have received a copy of the GNU General Public License
 *   along with this program; if not, see <http://www.gnu.org/licenses/>.
 */
import QtQuick 2.1
import GCompris 1.0

import "../../core"
import "electric.js" as Activity

ActivityBase {
    id: activity

    property string url: "qrc:/gcompris/src/activities/electric/resource/"
    property int levelCount: 3

    onStart: focus = true
    onStop: {}

    pageComponent: Rectangle {
        id: background
        anchors.fill: parent
        color: "#ABCDEF"
        signal start
        signal stop

        property bool vert: background.width > background.height

        Component.onCompleted: {
            activity.start.connect(start)
            activity.stop.connect(stop)
        }

        // Add here the QML items you need to access in javascript
        QtObject {
            id: items
            property Item main: activity.main
            property alias background: background
            property alias bar: bar
            property alias bonus: bonus
        }

        Loader {
            id: dataset
            asynchronous: false
        }

        onStart: { Activity.start(items) }
        onStop: { Activity.stop() }

        GCText {
            anchors.centerIn: parent
            text: "electric"
            fontSize: largeSize
        }

        DialogHelp {
            id: dialogHelp
            onClose: home()
        }

        Bar {
            id: bar
            content: BarEnumContent { value: help | home | level }
            onHelpClicked: {
                displayDialog(dialogHelp)
            }
            onPreviousLevelClicked: Activity.previousLevel()
            onNextLevelClicked: Activity.nextLevel()
            onHomeClicked: activity.home()
        }

        Bonus {
            id: bonus
            Component.onCompleted: win.connect(Activity.nextLevel)
        }

        Rectangle {
            id: leftWidget
            width: background.vert ?
                       90 * ApplicationInfo.ratio :
                       background.width
            height: background.vert ?
                        background.height :
                        90 * ApplicationInfo.ratio
            color: "#FFFF42"
            border.color: "#FFD85F"
            border.width: 4
            anchors.left: parent.left
            //            ListWidget {
            //                id: availablePieces
            //                vert: background.vert
            //            }
        }

        Rectangle {
            id: toolTip
            anchors.top: toolTipTxt.top
            anchors.horizontalCenter: toolTipTxt.horizontalCenter
            width: toolTipTxt.width + 10
            height: toolTipTxt.height + 5
            visible: false
            opacity: 0.8
            radius: 10
            z: 100
            border.width: 2
            border.color: "black"
            gradient: Gradient {
                GradientStop { position: 0.0; color: "#000" }
                GradientStop { position: 0.9; color: "#666" }
                GradientStop { position: 1.0; color: "#AAA" }
            }
            property alias text: toolTipTxt.text
        }

        GCText {
            id: toolTipTxt
            anchors {
                bottom: bar.top
                bottomMargin: 10
                left: leftWidget.left//horizontalCenter
                leftMargin: 5
            }
            visible: toolTip.visible
            z: 101
            fontSize: regularSize
            color: "white"
            style: Text.Outline
            styleColor: "black"
            horizontalAlignment: Text.AlignHCenter
            wrapMode: TextEdit.WordWrap
        }

        Rectangle {
            id: grid

            color: "transparent"
            z: 2
            x: background.vert ? 90 * ApplicationInfo.ratio : 0
            y: background.vert ? 0 : 90 * ApplicationInfo.ratio
            width: background.vert ?
                       background.width - 90 * ApplicationInfo.ratio : background.width
            height: background.vert ?
                        background.height - (bar.height * 1.1) :
                        background.height - (bar.height * 1.1) - 90 * ApplicationInfo.ratio
        }

        Rectangle {
            id: instruction
            anchors.fill: instructionTxt
            opacity: 0.8
            radius: 10
            z: 3
            border.width: 2
            border.color: "black"
            gradient: Gradient {
                GradientStop { position: 0.0; color: "#000" }
                GradientStop { position: 0.9; color: "#666" }
                GradientStop { position: 1.0; color: "#AAA" }
            }
            property alias text: instructionTxt.text

            Behavior on opacity { PropertyAnimation { duration: 200 } }
        }

        GCText {
            id: instructionTxt
            anchors {
                top: background.vert ? grid.top : leftWidget.bottom
                topMargin: -10
                horizontalCenter: background.vert ? grid.horizontalCenter : leftWidget.horizontalCenter
            }
            opacity: instruction.opacity
            z: instruction.z
            fontSize: regularSize
            color: "white"
            style: Text.Outline
            styleColor: "black"
            horizontalAlignment: Text.AlignHCenter
            width: Math.max(Math.min(parent.width * 0.9, text.length * 11), parent.width * 0.3)
            wrapMode: TextEdit.WordWrap
        }
    }

}
