import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 3.0 as PlasmaComponents

Item {
    id: root
    width: 400; height: 500
    
    property var notes: []
    property int selectedNote: -1
    
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 16
        spacing: 12
        
        // Header
        RowLayout {
            Layout.fillWidth: true
            PlasmaComponents.Label { text: "📝 Notes"; font.bold: true; font.pixelSize: 20 }
            Item { Layout.fillWidth: true }
            PlasmaComponents.Button { icon.name: "list-add"; onClicked: createNote() }
        }
        
        // Search
        PlasmaComponents.TextField {
            id: searchField
            Layout.fillWidth: true
            placeholderText: "Search notes..."
            onTextChanged: loadNotes()
        }
        
        // Notes list
        ListView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            model: notes
            spacing: 8
            clip: true
            
            delegate: Rectangle {
                width: parent.width
                height: 70
                radius: 8
                color: index === selectedNote ? PlasmaCore.Theme.highlightColor : PlasmaCore.Theme.backgroundColor
                border.color: PlasmaCore.Theme.textColor
                border.width: 1
                opacity: border.width > 0 ? 0.1 : 1
                
                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 10
                    spacing: 4
                    
                    PlasmaComponents.Label {
                        text: modelData.title
                        font.bold: true
                        elide: Text.ElideRight
                        Layout.fillWidth: true
                    }
                    PlasmaComponents.Label {
                        text: modelData.preview || ""
                        opacity: 0.7
                        elide: Text.ElideRight
                        Layout.fillWidth: true
                    }
                    PlasmaComponents.Label {
                        text: modelData.modified || ""
                        font.pixelSize: 10
                        opacity: 0.5
                    }
                }
                
                MouseArea {
                    anchors.fill: parent
                    onClicked: selectedNote = index
                    onDoubleClicked: openNote(modelData.id)
                }
            }
        }
    }
    
    Component.onCompleted: loadNotes()
    
    function loadNotes() {
        executable.exec("sanchala-notes list --json" + (searchField.text ? " -s '" + searchField.text + "'" : ""))
    }
    
    function createNote() { executable.exec("sanchala-notes new"); loadNotes() }
    function openNote(id) { executable.exec("sanchala-notes edit " + id) }
    
    PlasmaCore.DataSource {
        id: executable; engine: "executable"
        onNewData: { try { notes = JSON.parse(data["stdout"]) } catch(e) {}; disconnectSource(sourceName) }
        function exec(cmd) { connectSource(cmd) }
    }
}
