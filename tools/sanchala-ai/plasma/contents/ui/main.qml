import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 3.0 as PlasmaComponents
import org.kde.plasma.plasmoid 2.0

Item {
    id: root
    
    Plasmoid.icon: "sanchala-ai"
    Plasmoid.title: "Sanchala AI"
    Plasmoid.toolTipMainText: "Sanchala AI Assistant"
    Plasmoid.toolTipSubText: "Local, private AI"
    
    Plasmoid.preferredRepresentation: Plasmoid.compactRepresentation
    
    Plasmoid.compactRepresentation: PlasmaCore.IconItem {
        source: "sanchala-ai"
        active: mouseArea.containsMouse
        
        MouseArea {
            id: mouseArea
            anchors.fill: parent
            hoverEnabled: true
            onClicked: plasmoid.expanded = !plasmoid.expanded
        }
    }
    
    Plasmoid.fullRepresentation: ColumnLayout {
        Layout.preferredWidth: 350
        Layout.preferredHeight: 400
        spacing: 10
        
        PlasmaComponents.Label {
            text: "🤖 Sanchala AI"
            font.bold: true
            font.pixelSize: 16
            Layout.alignment: Qt.AlignHCenter
        }
        
        Rectangle {
            Layout.fillWidth: true
            height: 1
            color: PlasmaCore.Theme.textColor
            opacity: 0.2
        }
        
        ScrollView {
            id: chatScroll
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            
            ListView {
                id: chatList
                model: chatModel
                spacing: 8
                
                delegate: Rectangle {
                    width: chatList.width - 20
                    height: msgText.implicitHeight + 16
                    radius: 8
                    color: model.isUser ? "#3daee9" : "#31363b"
                    x: model.isUser ? 10 : 0
                    
                    PlasmaComponents.Label {
                        id: msgText
                        text: model.text
                        anchors.fill: parent
                        anchors.margins: 8
                        wrapMode: Text.WordWrap
                    }
                }
            }
        }
        
        RowLayout {
            Layout.fillWidth: true
            spacing: 8
            
            PlasmaComponents.TextField {
                id: inputField
                Layout.fillWidth: true
                placeholderText: "Ask anything..."
                onAccepted: sendMessage()
            }
            
            PlasmaComponents.Button {
                icon.name: "document-send"
                onClicked: sendMessage()
            }
        }
        
        PlasmaComponents.Label {
            text: "100% Local • No Cloud"
            font.pixelSize: 10
            opacity: 0.6
            Layout.alignment: Qt.AlignHCenter
        }
    }
    
    ListModel { id: chatModel }
    
    function sendMessage() {
        if (inputField.text.trim() === "") return
        
        chatModel.append({text: inputField.text, isUser: true})
        
        var prompt = inputField.text
        inputField.text = ""
        
        // Call D-Bus service
        executable.exec("sanchala-ai chat \"" + prompt + "\"")
    }
    
    PlasmaCore.DataSource {
        id: executable
        engine: "executable"
        connectedSources: []
        
        function exec(cmd) {
            connectSource(cmd)
        }
        
        onNewData: {
            var output = data["stdout"].trim()
            if (output) {
                chatModel.append({text: output, isUser: false})
            }
            disconnectSource(sourceName)
        }
    }
}
