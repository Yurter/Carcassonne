import QtQuick 2.14
import QtQuick.Controls 2.14

Item {
    id: root
    width: parent.width
    height: parent.height

    Rectangle {
        id: background
        anchors.fill: parent
        color: "lightgreen"
    }

    Column {
        anchors.centerIn: parent
        spacing: 5

        Rectangle {
            id: logo
            width: 200
            height: 70
            color: "lightblue"
            border.width: 1
            anchors.horizontalCenter: parent.horizontalCenter

            Label {
                text: "Carcassonne"
                anchors.centerIn: parent
                font.pixelSize: 32
            }
        }

        Button {
            id: btnPlayLocal
            text: "Play local"
            font.pixelSize: 24
            width: 200
            anchors.horizontalCenter: parent.horizontalCenter
            onClicked: {
                main_stack.push("qrc:/qml/menu/GameSetup/Players.qml")
            }
        }

        Button {
            enabled: false
            id: btnPlayOnline
            text: "Play online"
            font.pixelSize: 24
            width: 200
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }

    Button {
        anchors {
            right: parent.right
            bottom: parent.bottom
        }
        text: "Exit"
        width: 70
        height: 40
        onClicked: {
            Qt.quit()
        }
    }
}
