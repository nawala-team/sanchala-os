// TourOfferPage.qml - Feature tour invitation
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import org.kde.kirigami 2.19 as Kirigami

Item {
    id: tourOfferPage
    property string selectedTour: ""
    
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 40
        spacing: 24
        
        Label {
            text: "Take a Tour?"
            font.pixelSize: 28
            font.weight: Font.DemiBold
            Layout.alignment: Qt.AlignHCenter
        }
        
        Label {
            text: "Learn about Sanchala OS features with a quick guided tour"
            opacity: 0.7
            Layout.alignment: Qt.AlignHCenter
        }
        
        Item { height: 20 }
        
        // Tour options
        Repeater {
            model: ListModel {
                ListElement {
                    tourId: "desktop"
                    title: "Desktop Essentials"
                    desc: "Learn the basics: panel, dock, app launcher, and workspaces"
                    duration: "3 min"
                    icon: "desktop"
                    recommended: true
                }
                ListElement {
                    tourId: "security"
                    title: "Security Features"
                    desc: "Discover Sanchala Guardian and protection features"
                    duration: "2 min"
                    icon: "security-high"
                    recommended: false
                }
                ListElement {
                    tourId: "privacy"
                    title: "Privacy Dashboard"
                    desc: "Control what apps can access and monitor your privacy"
                    duration: "2 min"
                    icon: "preferences-system-privacy"
                    recommended: false
                }
            }
            
            delegate: Rectangle {
                Layout.fillWidth: true
                height: 90
                radius: 12
                color: selectedTour === model.tourId ? Kirigami.Theme.highlightColor : Kirigami.Theme.alternateBackgroundColor
                border.color: model.recommended && selectedTour !== model.tourId ? Kirigami.Theme.highlightColor : "transparent"
                border.width: 2
                
                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 16
                    spacing: 16
                    
                    Rectangle {
                        width: 56; height: 56
                        radius: 12
                        color: selectedTour === model.tourId ? Kirigami.Theme.highlightedTextColor : Kirigami.Theme.backgroundColor
                        opacity: 0.2
                        
                        Kirigami.Icon {
                            anchors.centerIn: parent
                            source: model.icon
                            width: 32; height: 32
                        }
                    }
                    
                    ColumnLayout {
                        spacing: 4
                        Layout.fillWidth: true
                        
                        RowLayout {
                            Label {
                                text: model.title
                                font.weight: Font.Medium
                                color: selectedTour === model.tourId ? Kirigami.Theme.highlightedTextColor : Kirigami.Theme.textColor
                            }
                            Rectangle {
                                visible: model.recommended
                                width: recLabel.width + 12
                                height: 18
                                radius: 9
                                color: Kirigami.Theme.positiveBackgroundColor
                                Label {
                                    id: recLabel
                                    anchors.centerIn: parent
                                    text: "Recommended"
                                    font.pixelSize: 10
                                    color: Kirigami.Theme.positiveTextColor
                                }
                            }
                        }
                        Label {
                            text: model.desc
                            font.pixelSize: 12
                            opacity: 0.7
                            color: selectedTour === model.tourId ? Kirigami.Theme.highlightedTextColor : Kirigami.Theme.textColor
                        }
                    }
                    
                    Label {
                        text: model.duration
                        opacity: 0.6
                        color: selectedTour === model.tourId ? Kirigami.Theme.highlightedTextColor : Kirigami.Theme.textColor
                    }
                }
                
                MouseArea {
                    anchors.fill: parent
                    onClicked: selectedTour = model.tourId
                }
            }
        }
        
        Item { Layout.fillHeight: true }
        
        // Actions
        RowLayout {
            Layout.alignment: Qt.AlignHCenter
            spacing: 16
            
            Button {
                text: "Skip for Now"
                flat: true
                onClicked: finishSetup(false)
            }
            
            Button {
                text: selectedTour ? "Start Tour" : "Get Started"
                highlighted: true
                onClicked: finishSetup(selectedTour !== "")
            }
        }
        
        Label {
            text: "You can access tours anytime from the Help menu"
            font.pixelSize: 12
            opacity: 0.6
            Layout.alignment: Qt.AlignHCenter
        }
    }
    
    function finishSetup(startTour) {
        if (startTour && selectedTour) {
            // Would start the selected tour
            console.log("Starting tour: " + selectedTour)
        }
        Qt.quit()
    }
}
