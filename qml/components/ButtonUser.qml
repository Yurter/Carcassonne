import QtQuick 2.14
import QtQuick.Controls 2.14

Item {
    id: root
    width: avatar.width + 10
    height: avatar.height + 10
    Text {
        text: root.state
    }

    state: "HOST"
    states: [
        State {
            name: "HOST"
            PropertyChanges {
            }
        }
        , State {
            name: "VACANT"
            PropertyChanges {
                target: btnAddSpot
                visible: true
            }
        }
        , State {
            name: "TAKEN"
            PropertyChanges {
                target: btnRemove
                visible: true
            }
        }
    ]

    Avatar {
        id: avatar
        anchors.centerIn: parent
    }

    Button {
        id: btnRemove
        text: "X"
        width: 20
        height: 20
        anchors.right: parent.right
        visible: false
    }

    Button {
        id: btnAddSpot
        text: "+"
        width: 40
        height: 40
        font.pixelSize: 32
        anchors.centerIn: parent
        visible: false
    }
}
