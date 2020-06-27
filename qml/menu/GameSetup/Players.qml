import QtQuick 2.14
import QtQuick.Controls 2.14
import "../../components"

Item {
    id: root
    width: parent.width
    height: parent.height

    Rectangle {
        id: background
        anchors.fill: parent
        color: "salmon"
    }

    Label {
        id: title
        text: "Players"
        font.pixelSize: 32
    }

    Row {
        id: players
        anchors.centerIn: parent
        spacing: 10

        Repeater {
            model: ListModel {
                id: userlist

                ListElement {}
                ListElement {}

                Component.onCompleted: {
                    userlist.setProperty(0, "state", "VACANT")
                    console.log(userlist.get(0).state)
                    console.log(userlist.get(1).state)
                }
            }
            delegate: ButtonUser {
                //
            }
        }
    }
}
