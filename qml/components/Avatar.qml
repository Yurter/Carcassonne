import QtQuick 2.14

Item {
    id: root
    width: 70
    height: 70

    Image {
        id: user_avatar
        anchors.fill: parent
        source: "qrc:/img/default_avatar.png"
    }
}
