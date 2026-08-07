// KeyboardPage.qml - Keyboard layout selection
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import org.kde.kirigami 2.19 as Kirigami

Item {
    id: keyboardPage
    property string selectedLayout: "us"
    property string selectedVariant: ""
    
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 40
        spacing: 24
        
        Label {
            text: "Keyboard Layout"
            font.pixelSize: 28
            font.weight: Font.DemiBold
            Layout.alignment: Qt.AlignHCenter
        }
        
        Label {
            text: "Choose your keyboard layout"
            opacity: 0.7
            Layout.alignment: Qt.AlignHCenter
        }
        
        TextField {
            id: layoutSearch
            Layout.fillWidth: true
            placeholderText: "Search keyboard layouts..."
        }
        
        ListView {
            id: layoutList
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            model: ListModel {
                ListElement { code: "us"; name: "English (US)"; flag: "\ud83c\uddfa\ud83c\uddf8" }
                ListElement { code: "gb"; name: "English (UK)"; flag: "\ud83c\uddec\ud83c\udde7" }
                ListElement { code: "de"; name: "German"; flag: "\ud83c\udde9\ud83c\uddea" }
                ListElement { code: "fr"; name: "French"; flag: "\ud83c\uddeb\ud83c\uddf7" }
                ListElement { code: "es"; name: "Spanish"; flag: "\ud83c\uddea\ud83c\uddf8" }
                ListElement { code: "jp"; name: "Japanese"; flag: "\ud83c\uddef\ud83c\uddf5" }
                ListElement { code: "id"; name: "Indonesian"; flag: "\ud83c\uddee\ud83c\udde9" }
            }
            
            delegate: ItemDelegate {
                width: layoutList.width
                highlighted: model.code === selectedLayout
                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 12
                    Label { text: model.flag; font.pixelSize: 24 }
                    Label { text: model.name; font.weight: Font.Medium }
                    Item { Layout.fillWidth: true }
                    Label { text: model.code.toUpperCase(); opacity: 0.5 }
                }
                onClicked: selectedLayout = model.code
            }
        }
        
        // Visual keyboard preview
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 100
            color: Kirigami.Theme.alternateBackgroundColor
            radius: 12
            
            Label {
                anchors.centerIn: parent
                text: "[Keyboard Preview: " + selectedLayout.toUpperCase() + "]"
                opacity: 0.6
            }
        }
        
        // Type to test
        TextField {
            id: testField
            Layout.fillWidth: true
            placeholderText: "Type here to test your keyboard layout..."
            font.pixelSize: 16
        }
    }
}
